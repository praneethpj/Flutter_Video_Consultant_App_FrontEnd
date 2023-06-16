import 'dart:convert';

List<ChatMessage> jsontoChatMessage(String str) => List<ChatMessage>.from(
    json.decode(str).map((x) => ChatMessage.fromJson(x)));

class ChatMessage {
  String targetClientId;
  String text;
  bool isText;
  String userId;
  String imageUrl;
  String createdAt;
  int status;

  ChatMessage({
    required this.targetClientId,
    required this.text,
    required this.isText,
    required this.userId,
    required this.imageUrl,
    required this.createdAt,
    required this.status,
  });

  ChatMessage.fromJson(Map<String, dynamic> json)
      : targetClientId = json['targetClientId'],
        text = json['message'] ?? "",
        isText = json['isText'],
        userId = json['userId'],
        imageUrl = json['imageUrl'] ?? "",
        status = json['status'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() => {
        'targetClientId': targetClientId,
        'message': text,
        'isText': isText,
        'userId': userId,
        'imageUrl': imageUrl,
        'createdAt': createdAt,
        'status': status,
      };
}
