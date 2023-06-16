import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timetalk/models/chat_message_model.dart';
import 'package:timetalk/screens/personal_message/personal_message_screen.dart';

import '../../constants/ApiConstants.dart';
import '../../services/message_service.dart';

class ListOfChatItemScreen extends StatefulWidget {
  const ListOfChatItemScreen({super.key});

  @override
  State<ListOfChatItemScreen> createState() => _ListOfChatItemScreenState();
}

class _ListOfChatItemScreenState extends State<ListOfChatItemScreen> {
  MessageService messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal Chat"),
        ),
        body: FutureBuilder<List<ChatMessage>>(
          future: messageService.readAllChatMessages(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ChatMessage>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(PersonalMessageScreen(
                          targetUserId: snapshot.data![index].targetClientId));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: snapshot.data!.length > 0
                            ? NetworkImage(
                                "${ApiConstants.clouddomain}/image/${snapshot.data![index].targetClientId}/${snapshot.data![index].targetClientId}_professionalprofile.jpg")
                            : NetworkImage(""),
                      ),
                      title: Text(snapshot.data![index].text),
                      subtitle: Text(
                        snapshot.data![index].createdAt,
                        style: GoogleFonts.lato(fontSize: 12),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
