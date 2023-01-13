import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/handlers/AuthHandler.dart';
import 'package:client/screens/PasswordReset.dart';
import 'package:client/utils/Validators.dart';
import 'package:client/widgets/common/Snack.dart';
import 'package:vrouter/vrouter.dart';

import '../common/Input.dart';
import '../common/RoundButton.dart';

class ResetPasswordForm extends StatefulWidget {
  Function onSubmit;
  String token;

  ResetPasswordForm({Key? key, required this.onSubmit, required this.token})
      : super(key: key);

  @override
  ResetPasswordFormState createState() {
    return ResetPasswordFormState();
  }
}

class ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  resetPassword(Function callback) async {
    if (_formKey.currentState!.validate()) {
      callback({
        "data": {
          "newPassword": passwordController.text,
          "token": widget.token,
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var window = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Input(
            context,
            Icons.lock,
            "Nouveau mot de passe",
            passwordController,
            (String value) {
              if (value.length < 8) {
                return 'Minimum 8 caractères';
              }

              return null;
            },
            paddingVertical: 30,
            obscureText: true,
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RoundButton(
                    onPressed: () => resetPassword(widget.onSubmit),
                    borderWidth: 0,
                    child: Text(
                      "Envoyer",
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
