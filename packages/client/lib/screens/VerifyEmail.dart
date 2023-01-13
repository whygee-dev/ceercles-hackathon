import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphql/queries/user.dart';
import 'package:client/screens/RegisterProfile.dart';
import 'package:client/widgets/common/RoundButton.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../handlers/AuthHandler.dart';
import '../widgets/common/Snack.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  static const route = '/verify-email';

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  var calledVerifyEmail = false;
  var showTimer = false;

  @override
  Widget build(BuildContext context) {
    String? token = context.vRouter.queryParameters["token"];

    return Mutation(
        options: MutationOptions(
          document: gql(token != null ? verifyEmail : resendEmailConfirmation),
          onCompleted: (data) async {
            if (data == null) {
              return;
            }

            if (data["verifyEmail"] != null) {
              if (await Provider.of<AuthHandler>(context, listen: false)
                  .setEmailVerified(data["verifyEmail"])) {
                context.vRouter.to(RegisterProfile.route);
              }
            }

            if (data["resendEmailConfirmation"] != null) {
              setState(() {
                showTimer = true;
              });

              showSnack(
                context,
                "Un nouveau mail de confirmation vous a été envoyé.",
                const Duration(seconds: 5),
              );
            }
          },
          onError: (error) {
            if (error == null) return;

            if (error.graphqlErrors.isNotEmpty) {
              showSnack(context, error.graphqlErrors[0].message,
                  const Duration(minutes: 1));
            } else {
              showSnack(context, 'Une erreur inattendu est survenue :/',
                  const Duration(minutes: 1));
            }

            context.vRouter.to(VerifyEmail.route);
          },
        ),
        builder: (RunMutation runMutation, queryResult) {
          if (token != null && !calledVerifyEmail) {
            calledVerifyEmail = true;

            runMutation({
              'token': token,
            });
          }

          return Scaffold(
            body: Container(
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/images/register/boy.png"),
              //     fit: BoxFit.cover,
              //     colorFilter: ColorFilter.mode(
              //         Color.fromRGBO(255, 255, 255, 0.7), BlendMode.lighten),
              //   ),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Vous avez reçu un email de confirmation, veuillez suivre le lien dans ce dernier pour confirmer votre compte.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!showTimer)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 30.0,
                        horizontal: MediaQuery.of(context).size.width * 0.2,
                      ),
                      child: RoundButton(
                        child: const Text(
                          "Envoyer à nouveau",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          runMutation({});
                        },
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
                            horizontal: MediaQuery.of(context).size.width * 0.3,
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
          );
        });
  }
}
