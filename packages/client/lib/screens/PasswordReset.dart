import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/screens/Login.dart';
import 'package:client/widgets/common/CAppBar.dart';
import 'package:client/widgets/forms/GeneratePasswordResetForm.dart';
import 'package:vrouter/vrouter.dart';

import '../graphql/queries/user.dart';
import '../widgets/common/Snack.dart';
import '../widgets/forms/ResetPasswordForm.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  static const route = '/password-reset';

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  @override
  Widget build(BuildContext context) {
    String? token = context.vRouter.queryParameters["token"];

    return Mutation(
      options: MutationOptions(
        document: gql(token == null ? generatePasswordReset : resetPassword),
        onCompleted: (data) async {
          if (data == null) {
            return;
          }

          if (data["generatePasswordReset"] != null) {
            if (data["generatePasswordReset"] != true) {
              showServerErrorSnack(context);
            } else {
              showSnack(
                context,
                "Si l'adresse renseigné correspond a un compte ceercles, un email avec des instructions sera envoyé.",
                const Duration(seconds: 5),
              );
            }
          }

          if (data["resetPassword"] != null) {
            if (data["resetPassword"] != true) {
              showServerErrorSnack(context);
            } else {
              showSnack(
                context,
                "Votre mot de passe a été changé avec succés",
                const Duration(seconds: 5),
              );
              context.vRouter.to(Login.route);
            }
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

          context.vRouter.to(PasswordReset.route);
        },
      ),
      builder: (RunMutation runMutation, queryResult) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const CAppBar(),
          body: Container(
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/register/boy.png"),
            //     fit: BoxFit.cover,
            //     colorFilter: ColorFilter.mode(
            //         Color.fromRGBO(255, 255, 255, 0.7), BlendMode.lighten),
            //   ),
            // ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (token == null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Vous avez oublié votre mot de passe ?",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Réinitialiser votre mot de passe",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      if (token == null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Text(
                              "On y a pensé. Entrez votre email pour le réinitialiser.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (token == null)
                    GeneratePasswordResetForm(
                      onSubmit: runMutation,
                    )
                  else
                    ResetPasswordForm(onSubmit: runMutation, token: token),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
