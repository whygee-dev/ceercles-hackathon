import 'dart:convert';

import 'package:client/screens/Messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphql/queries/user.dart';
import 'package:client/handlers/AuthHandler.dart';
import 'package:client/widgets/common/Snack.dart';
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';
import '../../graphql/queries/user-profile.dart';
import '../../utils/Enums.dart';
import '../common/CheckBox.dart';
import '../common/Input.dart';
import '../common/RoundButton.dart';
import 'package:intl/intl.dart';

class RegisterProfileForm extends StatefulHookWidget {
  const RegisterProfileForm({Key? key}) : super(key: key);

  @override
  RegisterProfileFormState createState() {
    return RegisterProfileFormState();
  }
}

class RegisterProfileFormState extends State<RegisterProfileForm> {
  int step = 1;
  Gender gender = Gender.MALE;
  TextEditingController birthdayController = TextEditingController();

  @override
  void dispose() {
    birthdayController.dispose();
    super.dispose();
  }

  final _step1Form = GlobalKey<FormState>();

  handleBackPress() {
    switch (step) {
      case 1:
        break;
      case 2:
        setState(() {
          step = 1;
        });

        break;

      case 3:
        setState(() {
          step = 2;
        });

        break;
    }
  }

  handleNextPress() {
    switch (step) {
      case 1:
        if (_step1Form.currentState!.validate()) {
          setState(() {
            step = 2;
          });
        }

        break;
      case 2:
        setState(() {
          step = 3;
        });

        break;

      case 3:
        break;
    }
  }

  createProfile(RunMutation runMutation) async {
    var format = DateFormat('dd/MM/yyyy');

    showSnack(
        context, "Création de votre profile...", const Duration(minutes: 1));

    if (!_step1Form.currentState!.validate()) {
      setState(() {
        step = 1;
      });
    }

    runMutation({
      "data": {
        "userId": Provider.of<AuthHandler>(context, listen: false).getUser!.id,
        "birthday": format.parse(birthdayController.text).toIso8601String(),
        "gender": gender.toString().split('.').last,
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(createUserProfile),
        onCompleted: (data) async {
          if (data == null) return;

          showSnack(
            context,
            "Votre profile a été créé avec succès",
            const Duration(seconds: 5),
          );

          await Provider.of<AuthHandler>(context, listen: false).refetchUser();

          context.vRouter.to(Messenger.route);
        },
        onError: (error) {
          if (error == null) return;

          print(error);
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
        return Column(
          children: [
            Visibility(
              child: Step1Form(
                formKey: _step1Form,
                birthdayController: birthdayController,
              ),
              visible: step == 1,
              maintainState: true,
            ),
            Visibility(
              child: Step2Form(
                gender: gender,
                onGenderChange: (Gender g) => setState(() {
                  gender = g;
                }),
              ),
              visible: step == 2,
              maintainState: true,
            ),
            // Visibility(
            //   child: Step3Form(
            //     level: level,
            //     onLevelChange: (AthleticLevel l) => setState(() {
            //       level = l;
            //     }),
            //   ),
            //   visible: step == 3,
            //   maintainState: true,
            // ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (step > 1)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: RoundButton(
                                child: Text(
                                  'Précédent',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                          fontSize: 16,
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                                onPressed: handleBackPress,
                                backgroundColor: Colors.white,
                                splashColor:
                                    Theme.of(context).primaryColorLight,
                              ),
                            ),
                          ),
                        if (step < 2)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: RoundButton(
                                child: Text(
                                  'Suivant',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(fontSize: 16),
                                ),
                                onPressed: handleNextPress,
                                borderWidth: 0,
                              ),
                            ),
                          ),
                        if (step == 2)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: RoundButton(
                                onPressed: () => createProfile(runMutation),
                                borderWidth: 0,
                                child: Text(
                                  "Valider",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class Step1Form extends StatefulWidget {
  final GlobalKey formKey;
  TextEditingController birthdayController;

  Step1Form({
    Key? key,
    required this.formKey,
    required this.birthdayController,
  }) : super(key: key);

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          Input(
            context,
            Icons.calendar_month,
            "Votre date de naissance",
            widget.birthdayController,
            (value) {
              return null;
            },
            paddingVertical: 20,
            date: true,
            onDateConfirm: (DateTime date) {
              var format = DateFormat('dd/MM/yyyy');
              widget.birthdayController.text = format.format(date);
            },
          )
        ],
      ),
    );
  }
}

class Step2Form extends StatelessWidget {
  Gender gender;
  Function(Gender c) onGenderChange;

  Step2Form({
    Key? key,
    required this.gender,
    required this.onGenderChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     CheckBox(
          //         label: "Je suis en Afrique",
          //         onChange: (v) {
          //           onCampaignChange(Campaign.AFRICA);
          //         },
          //         value: campaign == Campaign.AFRICA),
          //     CheckBox(
          //         label: "Je suis en France",
          //         onChange: (v) {
          //           onCampaignChange(Campaign.FRANCE);
          //         },
          //         value: campaign == Campaign.FRANCE)
          //   ],
          // ),
          // Divider(height: 40, color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CheckBox(
                label: "Je suis un homme",
                onChange: (v) {
                  onGenderChange(Gender.MALE);
                },
                value: gender == Gender.MALE,
              ),
              CheckBox(
                label: "Je suis une femme",
                onChange: (v) {
                  onGenderChange(Gender.FEMALE);
                },
                value: gender == Gender.FEMALE,
              )
            ],
          ),
          Divider(height: 50, color: Colors.transparent)
        ],
      ),
    );
  }
}

class Step3Form extends StatelessWidget {
  AthleticLevel level;
  Function(AthleticLevel level) onLevelChange;
  Step3Form({Key? key, required this.level, required this.onLevelChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 10,
        runSpacing: 20,
        children: <Widget>[
          CheckBox(
            label: "Je suis débutant",
            onChange: (v) {
              onLevelChange(AthleticLevel.BEGINNER);
            },
            value: level == AthleticLevel.BEGINNER,
          ),
          CheckBox(
            label: "Je suis intermédiaire",
            onChange: (v) {
              onLevelChange(AthleticLevel.INTERMEDIATE);
            },
            value: level == AthleticLevel.INTERMEDIATE,
          ),
          CheckBox(
            label: "Je suis avancé(e)",
            onChange: (v) {
              onLevelChange(AthleticLevel.ADVANCED);
            },
            value: level == AthleticLevel.ADVANCED,
          ),
          Divider(height: 50, color: Colors.transparent)
        ],
      ),
    );
  }
}
