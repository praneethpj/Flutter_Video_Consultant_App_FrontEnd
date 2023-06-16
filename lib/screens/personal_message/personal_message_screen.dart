import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/material.dart';
import 'package:timetalk/helpers/ConvertHelper.dart';
import 'package:timetalk/main.dart';
import 'package:timetalk/models/chat_message_model.dart';
import 'package:timetalk/screens/personal_message/view_image_screen.dart';
import 'package:timetalk/screens/profile_screen.dart';

import '../../constants/ApiConstants.dart';
import '../../services/message_service.dart';

class PersonalMessageScreen extends StatefulWidget {
  String targetUserId;
  PersonalMessageScreen({required this.targetUserId});
  @override
  State<PersonalMessageScreen> createState() => _PersonalMessageScreenState();
}

class _PersonalMessageScreenState extends State<PersonalMessageScreen> {
  Socket? socketIO;
  List<ChatMessage> messages = <ChatMessage>[];
  double? height, width;
  TextEditingController? textController;

  final ScrollController scrollController = ScrollController();

  MessageService messageService = MessageService();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var userId = '';
  final myFocusNode = FocusNode();
  var _messageStreamController =
      StreamController<List<ChatMessage>>.broadcast();

  @override
  void initState() {
    final box = GetStorage();
    userId = box.read("id").toString();

    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();

    super.initState();
    // Set up listener to focus node to show keyboard when it gets focus
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        FocusScope.of(context).requestFocus(myFocusNode);
      }
    });
    // Set focus to the node
    Future.delayed(Duration.zero, () => myFocusNode.requestFocus());
    loadData();
    connectSocketIO();
  }

  loadData() async {
    List<ChatMessage> myData =
        await messageService.readChatMessagesPerUser(widget.targetUserId);
    for (var element in myData) {
      ChatMessage message = ChatMessage(
          userId: element.userId,
          text: element.text,
          isText: element.isText,
          imageUrl: element.imageUrl,
          createdAt: element.createdAt,
          status: element.status,
          targetClientId: element.targetClientId);

      // Add the new message to the list of messages
      messages.add(message);

      _messageStreamController.add(messages);

      moveScroll();
    }
  }

  connectSocketIO() {
    print("Method calling.");
    socketIO = io(
        '${ApiConstants.cloudmsgaddress}/?userId=${userId}', <String, dynamic>{
      'transports': ['websocket'],
    });
    socketIO!.on('connect', (_) {
      String clientId = userId;
      socketIO!.emit('register', clientId);
    });

    socketIO!.onConnect((_) {
      print('Connected to server');
    });

    socketIO!.on('fromServer', (data) {
      print('Received message from server: ${data}');

      // Parse the JSON string into a map
      Map<String, dynamic> jsonMap = jsonDecode(data);

      // Decode the map into a MyData object
      MyData myData = MyData.fromJson(jsonMap);

      // Create a new ChatMessage using the decoded data
      ChatMessage message = ChatMessage(
          userId: myData.userId,
          text: myData.text,
          isText: myData.isText,
          imageUrl: myData.imageUrl,
          createdAt: myData.createdAt,
          status: myData.status,
          targetClientId: myData.targetClientId);

      // setState(() {
      // Add the new message to the list of messages
      messages.add(message);
      //});
      _messageStreamController.add(messages);
      moveScroll();
    });
  }

  moveScroll() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController!.animateTo(
        scrollController!.position.maxScrollExtent + 2000,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      connectSocketIO();

      socketIO!.onConnect((_) {
        socketIO!.emit('msg', {
          'image': base64Image,
          'userId': userId,
          'targetClientId': widget.targetUserId,
        });
      });

      // this.setState(
      //     () => messages.add(Message(text: "", imageUrl: base64Image!)));
      if (userId == widget.targetUserId) {
        flutterLocalNotificationsPlugin.show(
          888,
          'Messages',
          'Image recieved',
          NotificationDetails(
              android: AndroidNotificationDetails(
                  'your other channel id', 'your other channel name')),
        );
      }
    }
  }

  saveImage(String url) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    print("imgurl ${url}");
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));

    File? imgFile;
    Directory d = Directory('/storage/emulated/0');
    if (d.existsSync()) {
      Directory(d.path + '/MyApp').createSync();
      imgFile =
          new File(d.path + '/MyApp/${ConvertHelper.getRandomString(10)}');
      print('saving to ${imgFile.path}');
      imgFile.createSync();
      imgFile.writeAsBytes(Uint8List.fromList(response.data));
    }

    // print("resultimg ${result}");
    Get.to(ImageViewScreen(imagePath: imgFile!.path));
  }

  Future<void> downloadImages(String imgurl) async {
    try {
      var path = saveImage("${ApiConstants.clouddomain}/chatimage/${imgurl}");
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Widget buildSingleMessage(String msg, String imgurl, String datetime,
      String msguserId, String msgtargetId) {
    return userId == msguserId
        ? Container(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: imgurl.isEmpty
                  ? Column(
                      children: [
                        Text(
                          msg,
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          datetime,
                          style: TextStyle(
                              color: Color.fromARGB(255, 181, 181, 181),
                              fontSize: 10.0),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        downloadImages(imgurl);
                      },
                      child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Image.network(
                                  "${ApiConstants.clouddomain}/chatimage/${imgurl}",
                                ),
                              ),
                              Text(
                                datetime,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 181, 181, 181),
                                    fontSize: 10.0),
                              ),
                            ],
                          )),
                    ),
            ),
          )
        : Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 20.0, left: 20.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: imgurl.isEmpty
                  ? Column(
                      children: [
                        Text(
                          msg,
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          datetime,
                          style: TextStyle(
                              color: Color.fromARGB(255, 181, 181, 181),
                              fontSize: 10.0),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () async {
                        try {
                          //showLoadingDialog(context);
                          // Saved with this method.
                          var imageId = await ImageDownloader.downloadImage(
                              "${ApiConstants.clouddomain}/chatimage/${imgurl}");
                          if (imageId == null) {
                            return;
                          }

                          var path = await ImageDownloader.findPath(imageId);
                          var image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          //Navigator.pop(context);
                          //showToast('Image downloaded.');
                        } on PlatformException catch (error) {
                          print(error);
                        }
                      },
                      child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.network(
                            "${ApiConstants.clouddomain}/chatimage/${imgurl}",
                          )),
                    ),
            ),
          );
  }

  Widget buildMessageList() {
    return Container(
      height: height! / 2,
      width: width,
      child: StreamBuilder<List<ChatMessage>>(
        stream: _messageStreamController.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ChatMessage>> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            // Get the list of messages from the snapshot data
            List<ChatMessage> messages = snapshot.data!;
            // Build a list of widgets to display the messages
            return ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                ChatMessage message = messages[index];
                return buildSingleMessage(
                  message.text,
                  message.imageUrl,
                  message.createdAt,
                  message.userId,
                  message.targetClientId,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("hasError");
          } else if (snapshot.data!.length == 0) {
            return Text(
              "Start a Chat here ",
              style: GoogleFonts.lato(color: Colors.black26),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }
        },
      ),
    );

    return Container(
      child: Text("data"),
    );
  }

  Widget buildChatInput() {
    return Container(
      width: width! * 0.7,
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: width! * 0.6,
        child: TextField(
          focusNode: myFocusNode,
          style: TextStyle(fontSize: 20.0, height: 2, color: Colors.black),
          maxLines: 8, //or null
          decoration: InputDecoration.collapsed(
            border: OutlineInputBorder(),
            hintText: 'Write a message...',
          ),
          controller: textController,
        ),
      ),
    );
  }

  Widget buildAttachment() {
    return IconButton(
        onPressed: () {
          sendImage();
        },
        icon: Icon(
          CupertinoIcons.news,
          color: Colors.black54,
          size: 30,
        ));
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        //Check if the textfield has text or not
        if (textController!.text.isNotEmpty) {
          //Send the message as JSON data to send_message event
          // socketIO!.emit('msg', {
          //   'message': textController!.text,
          //   'userId': userId,
          //   'targetClientId': widget.targetUserId,
          // });
          connectSocketIO();
          // socketIO!.connect();
          String chatString = textController!.text;
          print("MSG ${chatString}");
          socketIO!.onConnect((_) {
            print('Connected to server');
            socketIO!.emit('msg', {
              'message': chatString,
              'userId': userId,
              'targetClientId': widget.targetUserId,
            });

            setState(() {
              buildMessageList();
            });
          });

          //Add the message to the list
          if (userId == widget.targetUserId) {
            flutterLocalNotificationsPlugin.show(
              888,
              'Messages',
              '${textController!.text}',
              NotificationDetails(
                  android: AndroidNotificationDetails(
                      'your other channel id', 'your other channel name')),
            );
          }
          textController!.text = '';
          //Scrolldown the list to show the latest message
          // scrollController!.animateTo(
          //   scrollController!.position.maxScrollExtent,
          //   duration: Duration(milliseconds: 600),
          //   curve: Curves.ease,
          // );
          //  this.setState(() =>
          //     messages.add(Message(text: textController!.text, imageUrl: "")));
        }
      },
      child: Icon(
        Icons.send,
        size: 18,
      ),
    );
  }

  Widget buildInputArea() {
    return Expanded(
      child: Container(
        height: height! * 0.09,
        width: width,
        child: Row(
          children: <Widget>[
            buildAttachment(),
            buildChatInput(),
            buildSendButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios), onTap: () => Get.back()),
          actions: [
            GestureDetector(
                child: Icon(CupertinoIcons.calendar),
                onTap: () => Get.to(ProfileScreen(
                    profileId: int.parse(widget.targetUserId),
                    costperhour: 0))),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            SingleChildScrollView(child: buildMessageList()),
            buildInputArea(),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final String imageUrl;

  Message({required this.text, required this.imageUrl});
}

class MyData {
  String targetClientId;
  String text;
  bool isText;
  String userId;
  String imageUrl;
  String createdAt;
  int status;
  MyData(
      {required this.targetClientId,
      required this.text,
      required this.isText,
      required this.userId,
      required this.imageUrl,
      required this.createdAt,
      required this.status});

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      targetClientId: json['targetClientId'],
      text: json['text'],
      isText: json['isText'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      createdAt: (json['createdAt']),
      status: json['status'],
    );
  }
}
