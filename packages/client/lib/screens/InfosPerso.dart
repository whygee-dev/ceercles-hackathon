import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client/widgets/avatar/CustomizedAvatar.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/handlers/AuthHandler.dart';
import 'package:client/utils/Validators.dart';
import 'package:client/widgets/common/Input.dart';
import 'package:client/widgets/common/RoundButton.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

import '../graphql/queries/user.dart';
import '../utils/Enums.dart';
import '../widgets/common/CAppBar.dart';
import '../widgets/common/Snack.dart';

class InfosPerso extends StatefulWidget {
  const InfosPerso({Key? key}) : super(key: key);

  static const route = '/infos-perso';

  @override
  State<InfosPerso> createState() => _InfosPersoState();
}

class _InfosPersoState extends State<InfosPerso> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  Gender gender = Gender.MALE;

  Map<String, String> file = {"path": "", "name": "", "extension": ""};
  final _formKey = GlobalKey<FormState>();
  var format = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    var user = Provider.of<AuthHandler>(context, listen: false).getUser;
    fullnameController.text = user?.fullname ?? "";
    birthdayController.text = format.format(user!.profile!.birthday);
    gender = user.profile!.gender;
    super.initState();
  }

  selectFile(String userId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      if (result.files.single.size > 2097152) {
        showSnack(context, "Fichier trop volumineux (max 2MB)",
            const Duration(seconds: 5));

        return;
      }

      setState(() {
        file["path"] = result.files.single.path!;
        file["name"] = result.files.single.name;
        file["extension"] = result.files.single.extension!;
      });

      submitAvatar(userId);
    }
  }

  submitAvatar(String userId) async {
    if (file["path"] != null && file["path"]!.isNotEmpty) {
      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(file["path"]!,
            filename: file["name"],
            contentType: MediaType('image', file["extension"]!)),
      });

      try {
        var response = await Dio().post(
          dotenv.env["API_URL"]! + "/upload/avatar",
          data: formData,
          options: Options(headers: {
            "Authorization":
                Provider.of<AuthHandler>(context, listen: false).getBearer
          }, contentType: "form-data"),
        );

        Provider.of<AuthHandler>(context, listen: false).refetchUser();
      } on DioError catch (e) {
        showSnack(
          context,
          "Le téléchargement de l'image a échoué " +
              (e.response?.data["message"] ?? ""),
          const Duration(seconds: 5),
        );
      }
    }
  }

  submit() async {
    if (_formKey.currentState!.validate()) {
      var user = Provider.of<AuthHandler>(context, listen: false).getUser;

      try {
        if (fullnameController.text != user?.fullname) {
          await Dio().post(
            dotenv.env["GQL_URL"]!,
            data: {
              "query": updateUser,
              "variables": {
                "data": {
                  "fullname": fullnameController.text,
                }
              }
            },
            options: Options(headers: {
              "Authorization":
                  Provider.of<AuthHandler>(context, listen: false).getBearer
            }),
          );
        }

        var res = await Dio().post(
          dotenv.env["GQL_URL"]!,
          data: {
            "query": updateUserProfile,
            "variables": {
              "data": {
                "birthday":
                    format.parse(birthdayController.text).toIso8601String(),
                "gender": gender.toString().split('.').last,
              }
            }
          },
          options: Options(headers: {
            "Authorization":
                Provider.of<AuthHandler>(context, listen: false).getBearer
          }),
        );

        await Provider.of<AuthHandler>(context, listen: false).refetchUser();
        showSnack(context, "Vos informations ont été mises à jour",
            const Duration(seconds: 5));
      } on DioError catch (e) {
        showSnack(
          context,
          "Une erreur est survenue " + (e.response?.data["message"] ?? ""),
          const Duration(seconds: 5),
        );
      }
    }
  }

  @override
  void dispose() {
    fullnameController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthHandler>(context, listen: true).getUser;
    var avatar = jsonDecode(user?.profile?.avatar ?? '{}');
    var body = CustomizedAvatar.findIndex("body", avatar["body"]);
    var accessory =
        CustomizedAvatar.findIndex("accessory", avatar["accessory"]);
    var head = CustomizedAvatar.findIndex("head", avatar["head"]);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 210,
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
              ),
              Positioned.fill(
                left: 0,
                bottom: 5,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: 40,
                    child: CustomizedAvatar(
                      editable: false,
                      height: 70,
                      withBackground: false,
                      body: body,
                      accessory: accessory,
                      head: head,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Colors.transparent),
          Form(
            key: _formKey,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Input(
                  context,
                  Icons.person,
                  'John Smith',
                  fullnameController,
                  (String value) {
                    if (!value.isValidFullname()) {
                      return 'Nom complet invalide';
                    }

                    return null;
                  },
                  fillColor: Theme.of(context).cardColor,
                  paddingVertical: 20,
                ),
                Input(
                  context,
                  Icons.calendar_month,
                  "Votre date de naissance",
                  birthdayController,
                  (value) {
                    return null;
                  },
                  date: true,
                  onDateConfirm: (DateTime date) {
                    birthdayController.text = format.format(date);
                  },
                  fillColor: Theme.of(context).cardColor,
                ),
                const Divider(height: 20, color: Colors.transparent),
                Container(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: MediaQuery.of(context).size.width / 1.16,
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    value: gender.name,
                    icon: const Icon(Icons.arrow_downward),
                    dropdownColor: Theme.of(context).cardColor,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          gender = Gender.values.firstWhere(
                              (e) => e.toString() == 'Gender.' + newValue);
                        });
                      }
                    },
                    items: Gender.values
                        .map<DropdownMenuItem<String>>((Gender value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Text(
                          value == Gender.MALE ? "Homme" : "Femme",
                        ),
                      );
                    }).toList(),
                  ),
                ),
                RoundButton(
                  child: const Text(
                    "Envoyer",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: submit,
                )
              ],
            ),
          )
        ],
      ),
      appBar: CAppBar(
        title: Text(
          "Informations personnelles",
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        useBackButton: true,
        centerTitle: true,
      ),
    );
  }
}
