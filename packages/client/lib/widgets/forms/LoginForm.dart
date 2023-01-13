import 'dart:convert';

import 'package:client/screens/Messenger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/handlers/AuthHandler.dart';
import 'package:client/screens/PasswordReset.dart';
import 'package:client/utils/Validators.dart';
import 'package:client/widgets/common/Snack.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../common/Input.dart';
import '../common/RoundButton.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  login() async {
    showSnack(context, "Connexion...", const Duration(minutes: 1));

    if (_formKey.currentState!.validate()) {
      var login = await Provider.of<AuthHandler>(context, listen: false)
          .login(emailController.text, passwordController.text);

      if (login != null) {
        clearSnack(context);
        context.vRouter.to(Messenger.route);
      } else {
        showSnack(context, "Email et/ou mot de passe incorrect(s)",
            const Duration(minutes: 1));
      }
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
            Icons.email,
            "Email",
            emailController,
            (String value) {
              if (!value.isValidEmail()) {
                return 'Email invalide';
              }

              return null;
            },
          ),
          Input(
            context,
            Icons.lock,
            "Mot de passe",
            passwordController,
            (value) {
              if (value.length < 8) {
                return 'Minimum 8 caractères';
              }

              return null;
            },
            paddingVertical: 20,
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
                    onPressed: login,
                    borderWidth: 0,
                    child: Text(
                      "Se connecter",
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {context.vRouter.to(PasswordReset.route)},
                    style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        "Mot de passe oublié ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(0, 0, 0, 0.75),
                          fontWeight: FontWeight.w200,
                        ),
                      ),
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
