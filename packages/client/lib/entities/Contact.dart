import 'Message.dart';

class Contact {
  String fullname;
  String id;
  Message? lastMessage;

  Contact({required this.fullname, required this.id, this.lastMessage});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        fullname: json["fullname"],
        id: json["id"],
        lastMessage: json["lastMessage"] != null
            ? Message.fromJson(json["lastMessage"])
            : null);
  }
}
