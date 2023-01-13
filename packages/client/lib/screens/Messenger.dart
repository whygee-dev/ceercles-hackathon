import 'dart:convert';

import 'package:client/widgets/avatar/CustomizedAvatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/graphql/queries/messenger.dart';
import 'package:client/handlers/AuthHandler.dart';
import 'package:client/widgets/common/Snack.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vrouter/vrouter.dart';

import '../entities/Contact.dart';
import 'MessengerThread.dart';

class Messenger extends StatefulWidget {
  const Messenger({Key? key}) : super(key: key);

  static const route = '/messenger';

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  List<Contact> contacts = [];

  @override
  void initState() {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    fetchContacts();
    super.initState();
  }

  fetchContacts() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        var req = await Dio().post(
          dotenv.env['GQL_URL']!,
          data: {"query": getAllContacts},
          options: Options(
            headers: {
              "Authorization":
                  Provider.of<AuthHandler>(context, listen: false).getBearer
            },
          ),
        );

        setState(() {
          contacts = (req.data["data"]["getAllContacts"] as List)
              .map(
                (c) => Contact.fromJson(c),
              )
              .toList();
        });
      } catch (e) {
        showSnack(context, "La récupération des contacts a échouée");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthHandler>(context).getUser;
    var avatar = jsonDecode(user?.profile?.avatar ?? '{}');
    var body = CustomizedAvatar.findIndex("body", avatar["body"]);
    var accessory =
        CustomizedAvatar.findIndex("accessory", avatar["accessory"]);
    var head = CustomizedAvatar.findIndex("head", avatar["head"]);

    return ListView(
      children: [
        ...contacts.map(
          (c) => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20.0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                context.vRouter.to(
                  MessengerThread.route
                      .replaceFirst(MessengerThread.firstParam, c.id)
                      .replaceFirst(
                        MessengerThread.secondParam,
                        c.fullname,
                      ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.all(10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: CustomizedAvatar(
                                    height: 50,
                                    editable: false,
                                    withBackground: false,
                                    body: body,
                                    accessory: accessory,
                                    head: head,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              c.fullname,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (c.lastMessage != null)
                            Text(
                              timeago.format(c.lastMessage!.createdAt.toLocal(),
                                  locale: 'fr'),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                      const Divider(height: 10, color: Colors.transparent),
                      Row(
                        children: [
                          if (c.lastMessage != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  c.lastMessage!.text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
