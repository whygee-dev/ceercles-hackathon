import 'dart:convert';

import 'package:client/screens/Messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/graphql/queries/user.dart';
import 'package:client/handlers/AuthHandler.dart';
import 'package:client/screens/PasswordReset.dart';
import 'package:client/utils/Validators.dart';
import 'package:client/widgets/common/Snack.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../../screens/Login.dart';
import '../common/Input.dart';
import '../common/RoundButton.dart';

class RegisterForm extends StatefulHookWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var window = MediaQuery.of(context).size;

    register(RunMutation runMutation) async {
      showSnack(
          context, "Création de votre compte...", const Duration(minutes: 1));

      if (_formKey.currentState!.validate()) {
        runMutation({
          'data': {
            'fullname': fullnameController.text,
            'email': emailController.text,
            'password': passwordController.text,
          }
        });
      }
    }

    return Mutation(
      options: MutationOptions(
        document: gql(createUser),
        onCompleted: (data) async {
          if (data == null) return;

          var login = await Provider.of<AuthHandler>(context, listen: false)
              .login(emailController.text, passwordController.text);

          if (login != null) {
            clearSnack(context);
            context.vRouter.to(Messenger.route);
          } else {
            showSnack(
                context,
                "La connexion automatique a échoué, veuillez vous connecter manuellement",
                const Duration(minutes: 1));
            context.vRouter.to(Login.route);
          }
          print(data);
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
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult<Object?>? result,
      ) {
        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Input(
                context,
                Icons.person,
                "Nom complet",
                fullnameController,
                (String value) {
                  if (!value.isValidFullname()) {
                    return 'Nom complet invalide';
                  }

                  return null;
                },
                paddingVertical: 20,
              ),
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
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RoundButton(
                        onPressed: () => register(runMutation),
                        borderWidth: 0,
                        child: Text(
                          "S'inscrire",
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
      },
    );
  }
}
