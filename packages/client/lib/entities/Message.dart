import 'Contact.dart';

class Message {
  String text;
  DateTime createdAt;
  Contact sender;
  Contact receiver;

  Message(
      {required this.text,
      required this.createdAt,
      required this.sender,
      required this.receiver});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json["text"],
      createdAt: DateTime.tryParse(json["createdAt"])!,
      receiver: Contact.fromJson(json["receiver"]),
      sender: Contact.fromJson(json["sender"]),
    );
  }
}
