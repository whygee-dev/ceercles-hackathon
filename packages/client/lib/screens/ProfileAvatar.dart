import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../handlers/AuthHandler.dart';
import '../widgets/avatar/CustomizedAvatar.dart';
import '../widgets/common/CAppBar.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  static const route = '/profile-avatar';

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthHandler>(context, listen: true).getUser;
    var avatar = jsonDecode(user?.profile?.avatar ?? '{}');
    var body = CustomizedAvatar.findIndex("body", avatar["body"]);
    var accessory =
        CustomizedAvatar.findIndex("accessory", avatar["accessory"]);
    var head = CustomizedAvatar.findIndex("head", avatar["head"]);

    return Scaffold(
      appBar: CAppBar(
        title: Text(
          "Avatar",
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        useBackButton: true,
        centerTitle: true,
      ),
      body: CustomizedAvatar(
        head: head,
        accessory: accessory,
        body: body,
      ),
    );
  }
}
