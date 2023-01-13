import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/handlers/AuthHandler.dart';
import 'package:client/screens/PasswordReset.dart';
import 'package:client/utils/Validators.dart';
import 'package:client/widgets/common/Snack.dart';
import 'package:vrouter/vrouter.dart';

import '../common/Input.dart';
import '../common/RoundButton.dart';

class GeneratePasswordResetForm extends StatefulWidget {
  RunMutation onSubmit;

  GeneratePasswordResetForm({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  GeneratePasswordResetFormState createState() {
    return GeneratePasswordResetFormState();
  }
}

class GeneratePasswordResetFormState extends State<GeneratePasswordResetForm> {
  final _formKey = GlobalKey<FormState>();

  var showTimer = false;
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  generatePasswordReset(RunMutation callback) async {
    if (_formKey.currentState!.validate()) {
      if ((await callback({
            'email': emailController.text,
          }).networkResult)
              ?.data?['generatePasswordReset'] ==
          true) {
        setState(() {
          showTimer = true;
        });
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
            paddingVertical: 30,
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!showTimer)
                    RoundButton(
                      onPressed: () => generatePasswordReset(widget.onSubmit),
                      borderWidth: 0,
                      child: Text(
                        "Envoyer",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontSize: 16),
                      ),
                    )
                  else
                    TweenAnimationBuilder<Duration>(
                      duration: const Duration(minutes: 1),
                      tween: Tween(
                          begin: const Duration(minutes: 1),
                          end: Duration.zero),
                      onEnd: () {
                        print('Timer ended');
                        setState(() {
                          showTimer = false;
                        });
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 30.0,
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                          ),
                          child: RoundButton(
                            child: Text(
                              '$minutes:$seconds',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              showSnack(
                                context,
                                "Veuillez attendre $minutes:$seconds",
                                const Duration(seconds: 3),
                              );
                            },
                          ),
                        );
                      },
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
