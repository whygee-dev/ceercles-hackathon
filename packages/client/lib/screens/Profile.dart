import 'dart:convert';

import 'package:client/screens/InfosPerso.dart';
import 'package:client/widgets/profile/CustomCard.dart';
import 'package:client/widgets/common/ParamRow.dart';
import 'package:client/widgets/profile/ImageCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:charts_common/common.dart' as common show DateTimeFactory;
import 'package:provider/provider.dart';
import 'package:vrouter/vrouter.dart';

import '../handlers/AuthHandler.dart';
import '../widgets/avatar/CustomizedAvatar.dart';
import '../widgets/common/RoundButton.dart';
import 'ProfileAvatar.dart';

class LocalizedTimeFactory implements common.DateTimeFactory {
  const LocalizedTimeFactory();

  @override
  DateTime createDateTimeFromMilliSecondsSinceEpoch(
      int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  @override
  DateTime createDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    return DateTime(
        year, month, day, hour, minute, second, millisecond, microsecond);
  }

  @override
  DateFormat createDateFormat(String? pattern) {
    initializeDateFormatting('fr');
    return DateFormat(pattern, 'fr');
  }
}

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  static const route = "/profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthHandler>(context, listen: true).getUser;
    var avatar = jsonDecode(user?.profile?.avatar ?? '{}');
    var body = CustomizedAvatar.findIndex("body", avatar["body"]);
    var accessory =
        CustomizedAvatar.findIndex("accessory", avatar["accessory"]);
    var head = CustomizedAvatar.findIndex("head", avatar["head"]);
    _tabController = TabController(length: 3, vsync: this);

    Widget title = GestureDetector(
      onTap: () {
        context.vRouter.to(ProfileAvatar.route);
      },
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            child: user?.profile?.avatar != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: CustomizedAvatar(
                      head: head,
                      body: body,
                      accessory: accessory,
                      editable: false,
                      height: 90,
                      withBackground: false,
                    ),
                  )
                : const Icon(
                    Icons.person_outline,
                  ),
          ),
        ],
      ),
    );

    return ListView(
      children: [
        Center(child: title),
        const Divider(height: 10, color: Colors.transparent),
        if (user?.profile != null)
          Center(
            child: Text(
              user!.fullname,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
        const Divider(height: 10, color: Colors.transparent),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Text(
                    "4",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Trophés",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: VerticalDivider(
                  width: 5,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: const [
                  Text(
                    "6",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "points",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const Divider(height: 30, color: Colors.transparent),
        SizedBox(
          width: double.infinity,
          child: Center(
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColorDark,
              indicatorColor: Theme.of(context).primaryColorDark,
              tabs: const [
                Tab(text: "A PROPOS"),
                Tab(text: "EVENTS"),
                Tab(text: "CEERCLES"),
              ],
            ),
          ),
        ),
        const Divider(height: 10, color: Colors.transparent),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2.6,
          width: MediaQuery.of(context).size.width,
          child: TabBarView(
            children: [
              ListView(
                children: [
                  const CustomCard(
                    title: "Trophés récoltés",
                    children: [
                      Tooltip(
                        message: "5x Donneur de sang",
                        child: Image(
                          image: AssetImage("assets/icons/trophy.png"),
                        ),
                      ),
                      Spacer(),
                      Tooltip(
                        message: "5x Donneur de sang",
                        child: Image(
                          image: AssetImage("assets/icons/trophy.png"),
                        ),
                      ),
                      Spacer(),
                      Tooltip(
                        message: "5x Donneur de sang",
                        child: Image(
                          image: AssetImage("assets/icons/trophy.png"),
                        ),
                      ),
                      Spacer(),
                      Tooltip(
                        message: "5x Donneur de sang",
                        child: Image(
                          image: AssetImage("assets/icons/trophy.png"),
                        ),
                      ),
                      Spacer(flex: 10)
                    ],
                  ),
                  const ParamRow(
                    title: 'Données personnelles',
                    route: InfosPerso.route,
                  ),
                  const ParamRow(
                    title: 'Code de parainnage',
                    customContent: Text("A2XFH50Y"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 50,
                    ),
                    child: RoundButton(
                      borderColor: Colors.red,
                      backgroundColor: Colors.red,
                      onPressed: () =>
                          Provider.of<AuthHandler>(context, listen: false)
                              .logout(context),
                      child: const Text(
                        "Déconnexion",
                        style: TextStyle(color: Colors.white),
                      ),
                      splashColor: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              ListView(
                children: const [
                  ImageCard(
                    title: "Recolte d’argent pour les sans abris",
                    subTitle: "2 FEVRIER 2023",
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/cc14/ec68/69b57d487d0805bb83aa02d8eac8fd8e?Expires=1674432000&Signature=pu7QZWU959eruILqJyYrfEqvXxXClGkNh-Ar6eQEb-qd99n4aEMIgDC~RSzQju5cApZshI2LjzDnqTgHB4o8YTCXXHpkGeYvGqsm0yM9rLk0Z90KqnfA7b3YmVfHub5QpMk-D3kUmu5wWh00pvNMG6sAjVoOaHGVpT8rfUZPDIxoLMo~AGYRRRg52xoVJsdj-UNc79Se-nBfgaLox0GE~ipQhrCfYK1mxooLVTkoidcbKyK9H7L8g~y0QDnsSc2-wjrsC9JYZaneOtg4or7Hot7aK~TA8hYgzoAaKqjtDpQGgGZ44UWSYKn-~lJywo3ZjSJJLG6YigHSs-CGzMA7Ng__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                    button: RoundButton(
                      radius: 7,
                      child: Text(
                        "Plus d'infos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ImageCard(
                    title: "Se lancer dans l’entreprenariat",
                    subTitle: "15 MARS 2023",
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/cc14/ec68/69b57d487d0805bb83aa02d8eac8fd8e?Expires=1674432000&Signature=pu7QZWU959eruILqJyYrfEqvXxXClGkNh-Ar6eQEb-qd99n4aEMIgDC~RSzQju5cApZshI2LjzDnqTgHB4o8YTCXXHpkGeYvGqsm0yM9rLk0Z90KqnfA7b3YmVfHub5QpMk-D3kUmu5wWh00pvNMG6sAjVoOaHGVpT8rfUZPDIxoLMo~AGYRRRg52xoVJsdj-UNc79Se-nBfgaLox0GE~ipQhrCfYK1mxooLVTkoidcbKyK9H7L8g~y0QDnsSc2-wjrsC9JYZaneOtg4or7Hot7aK~TA8hYgzoAaKqjtDpQGgGZ44UWSYKn-~lJywo3ZjSJJLG6YigHSs-CGzMA7Ng__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                    button: RoundButton(
                      radius: 7,
                      child: Text(
                        "Plus d'infos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              ListView(
                children: const [
                  ImageCard(
                    title: "Freelanceurs !",
                    subTitle: "Seb et Justine ont rejoint ce groupe",
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/cc14/ec68/69b57d487d0805bb83aa02d8eac8fd8e?Expires=1674432000&Signature=pu7QZWU959eruILqJyYrfEqvXxXClGkNh-Ar6eQEb-qd99n4aEMIgDC~RSzQju5cApZshI2LjzDnqTgHB4o8YTCXXHpkGeYvGqsm0yM9rLk0Z90KqnfA7b3YmVfHub5QpMk-D3kUmu5wWh00pvNMG6sAjVoOaHGVpT8rfUZPDIxoLMo~AGYRRRg52xoVJsdj-UNc79Se-nBfgaLox0GE~ipQhrCfYK1mxooLVTkoidcbKyK9H7L8g~y0QDnsSc2-wjrsC9JYZaneOtg4or7Hot7aK~TA8hYgzoAaKqjtDpQGgGZ44UWSYKn-~lJywo3ZjSJJLG6YigHSs-CGzMA7Ng__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                    button: RoundButton(
                      radius: 7,
                      child: Text(
                        "Plus d'infos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  ImageCard(
                    title: "Maraudeurs",
                    imageUrl:
                        "https://s3-alpha-sig.figma.com/img/cc14/ec68/69b57d487d0805bb83aa02d8eac8fd8e?Expires=1674432000&Signature=pu7QZWU959eruILqJyYrfEqvXxXClGkNh-Ar6eQEb-qd99n4aEMIgDC~RSzQju5cApZshI2LjzDnqTgHB4o8YTCXXHpkGeYvGqsm0yM9rLk0Z90KqnfA7b3YmVfHub5QpMk-D3kUmu5wWh00pvNMG6sAjVoOaHGVpT8rfUZPDIxoLMo~AGYRRRg52xoVJsdj-UNc79Se-nBfgaLox0GE~ipQhrCfYK1mxooLVTkoidcbKyK9H7L8g~y0QDnsSc2-wjrsC9JYZaneOtg4or7Hot7aK~TA8hYgzoAaKqjtDpQGgGZ44UWSYKn-~lJywo3ZjSJJLG6YigHSs-CGzMA7Ng__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
                    button: RoundButton(
                      radius: 7,
                      child: Text(
                        "Plus d'infos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
            controller: _tabController,
          ),
        )
      ],
    );
  }
}
