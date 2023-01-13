import 'dart:collection';
import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../graphql/queries/user.dart';
import '../../handlers/AuthHandler.dart';
import '../common/RoundButton.dart';
import '../common/Snack.dart';

class CustomizedAvatar extends StatefulWidget {
  static List<String> accessories = [
    "accessory=american-football.png",
    "accessory=baseball.png",
    "accessory=basket-ball.png",
    "accessory=blockchain.png",
    "accessory=board-games.png",
    "accessory=brunch.png",
    "accessory=business.png",
    "accessory=car.png",
    "accessory=collector.png",
    "accessory=cooking.png",
    "accessory=cryptocurrency.png",
    "accessory=ecology.png",
    "accessory=extreme-port.png",
    "accessory=fashion.png",
    "accessory=feminism.png",
    "accessory=french-rap.png",
    "accessory=gaming.png",
    "accessory=gastronomy.png",
    "accessory=glasses.png",
    "accessory=hype.png",
    "accessory=investment.png",
    "accessory=jet-set.png",
    "accessory=lgbt.png",
    "accessory=manga.png",
    "accessory=meet.png",
    "accessory=metaverse.png",
    "accessory=motorbike.png",
    "accessory=movies-series.png",
    "accessory=music.png",
    "accessory=oenology.png",
    "accessory=poker.png",
    "accessory=political.png",
    "accessory=rap-us.png",
    "accessory=reggae.png",
    "accessory=rock.png",
    "accessory=senior.png",
    "accessory=sexuality.png",
    "accessory=skateboard.png",
    "accessory=soccer.png",
    "accessory=sociale.png",
    "accessory=spirituality.png",
    "accessory=sport.png",
    "accessory=squirel.png",
    "accessory=techno.png",
    "accessory=trading-card.png",
    "accessory=travel.png"
  ];

  static List<String> bodies = [
    "body=american-football.png",
    "body=animals.png",
    "body=art-culture.png",
    "body=baseball.png",
    "body=basket-ball.png",
    "body=blockchain.png",
    "body=board-games.png",
    "body=brunch.png",
    "body=business.png",
    "body=car.png",
    "body=collector.png",
    "body=cooking.png",
    "body=cryptocurrency.png",
    "body=ecology.png",
    "body=extreme-sport.png",
    "body=fashion.png",
    "body=feminism.png",
    "body=french-rap.png",
    "body=gaming.png",
    "body=gastronomy.png",
    "body=hype.png",
    "body=investment.png",
    "body=jet-set.png",
    "body=lgbt.png",
    "body=manga.png",
    "body=meet.png",
    "body=metaverse.png",
    "body=motorbike.png",
    "body=movies-series.png",
    "body=music.png",
    "body=oenology.png",
    "body=poker.png",
    "body=political.png",
    "body=rap-us.png",
    "body=reggae.png",
    "body=rock.png",
    "body=senior.png",
    "body=sexuality.png",
    "body=skateboard.png",
    "body=soccer.png",
    "body=sociale.png",
    "body=spirituality.png",
    "body=sport.png",
    "body=techno.png",
    "body=trading-card.png",
    "body=travel.png",
  ];

  static List<String> heads = [
    "head=accessory.png",
    "head=american-football.png",
    "head=animals.png",
    "head=art-culture.png",
    "head=baseball.png",
    "head=basket-ball.png",
    "head=blockchain.png",
    "head=board-games.png",
    "head=business.png",
    "head=car.png",
    "head=collector.png",
    "head=cooking.png",
    "head=cryptocurrency.png",
    "head=ecology.png",
    "head=egg.png",
    "head=extreme-sport.png",
    "head=fashion.png",
    "head=feminism.png",
    "head=french-rap.png",
    "head=gaming.png",
    "head=gastronomy.png",
    "head=hype.png",
    "head=investment.png",
    "head=jet-set.png",
    "head=lgbt.png",
    "head=manga.png",
    "head=meet.png",
    "head=metaverse.png",
    "head=motorbike.png",
    "head=movies-series.png",
    "head=music.png",
    "head=oenology.png",
    "head=poker.png",
    "head=political.png",
    "head=rap-us.png",
    "head=reggae.png",
    "head=rock.png",
    "head=senior.png",
    "head=sexuality.png",
    "head=skateboard.png",
    "head=soccer.png",
    "head=sociale.png",
    "head=spirituality.png",
    "head=sport.png",
    "head=trading-card.png",
    "head=travel.png",
  ];

  static findIndex(String type, String? value) {
    if (value == null) return 0;
    if (type == "body") return CustomizedAvatar.bodies.indexOf(value);
    if (type == "head") return CustomizedAvatar.heads.indexOf(value);
    if (type == "accessory") {
      return CustomizedAvatar.accessories.indexOf(value);
    }

    return 0;
  }

  int? head;
  int? body;
  int? accessory;
  bool? editable;
  bool? withBackground;
  double height;

  CustomizedAvatar(
      {super.key,
      this.head,
      this.body,
      this.accessory,
      this.editable = true,
      this.withBackground = true,
      this.height = 250});

  @override
  State<CustomizedAvatar> createState() => _CustomizedAvatarState();
}

class _CustomizedAvatarState extends State<CustomizedAvatar> {
  onHeadChange(int index) {
    setState(() {
      widget.head = index;
    });
  }

  onBodyChange(int index) {
    setState(() {
      widget.body = index;
    });
  }

  onAccessoryChange(int index) {
    setState(() {
      widget.accessory = index;
    });
  }

  saveAvatar() async {
    await Dio().post(
      dotenv.env["GQL_URL"]!,
      data: {
        "query": updateUserProfile,
        "variables": {
          "data": {
            "avatar": jsonEncode({
              "head": CustomizedAvatar.heads[widget.head!],
              "body": CustomizedAvatar.bodies[widget.body!],
              "accessory": CustomizedAvatar.accessories[widget.accessory!]
            })
          }
        }
      },
      options: Options(headers: {
        "Authorization":
            Provider.of<AuthHandler>(context, listen: false).getBearer
      }),
    );

    await Provider.of<AuthHandler>(context, listen: false).refetchUser();
    showSnack(context, "Avatar sauvegardé", const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    String headPath = widget.head != null
        ? CustomizedAvatar.heads[widget.head!]
        : CustomizedAvatar.heads[0];
    String bodyPath = widget.body != null
        ? CustomizedAvatar.bodies[widget.body!]
        : CustomizedAvatar.bodies[0];
    String accessoryPath = widget.accessory != null
        ? CustomizedAvatar.accessories[widget.accessory!]
        : CustomizedAvatar.accessories[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: widget.height,
          child: Center(
            child: Stack(
              children: [
                if (widget.withBackground == true)
                  Image.asset(
                    "assets/avatar/background.png",
                    width: 250,
                    height: 250,
                  ),
                Image.asset(
                  "assets/avatar/dalmat.png",
                  width: 250,
                  height: 250,
                ),
                Image.asset(
                  "assets/avatar/body/$bodyPath",
                  width: 250,
                  height: 250,
                ),
                Image.asset(
                  "assets/avatar/head/$headPath",
                  width: 250,
                  height: 250,
                ),
                Image.asset(
                  "assets/avatar/accessory/$accessoryPath",
                  width: 250,
                  height: 250,
                ),
              ],
            ),
          ),
        ),
        if (widget.editable == true) ...[
          const Divider(height: 20, color: Colors.transparent),
          SizedBox(
            height: 75,
            child: Swiper(
              scrollDirection: Axis.horizontal,
              itemCount: CustomizedAvatar.heads.length,
              viewportFraction: 0.3,
              scale: 0.6,
              onIndexChanged: onHeadChange,
              index: widget.head,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Positioned(
                    child: FractionalTranslation(
                      translation: const Offset(0, 0.2),
                      child: Image.asset(
                        "assets/avatar/head/${CustomizedAvatar.heads[index]}",
                        width: 125,
                        height: 75,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 20, color: Colors.transparent),
          SizedBox(
            height: 75,
            child: Swiper(
              scrollDirection: Axis.horizontal,
              itemCount: CustomizedAvatar.bodies.length,
              viewportFraction: 0.3,
              scale: 0.6,
              onIndexChanged: onBodyChange,
              index: widget.body,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Positioned(
                    child: FractionalTranslation(
                      translation: const Offset(0, -0.3),
                      child: Image.asset(
                        "assets/avatar/body/${CustomizedAvatar.bodies[index]}",
                        width: 125,
                        height: 75,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 20, color: Colors.transparent),
          SizedBox(
            height: 75,
            child: Swiper(
              scrollDirection: Axis.horizontal,
              itemCount: CustomizedAvatar.accessories.length,
              viewportFraction: 0.3,
              scale: 0.6,
              onIndexChanged: onAccessoryChange,
              index: widget.accessory,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Positioned(
                    child: FractionalTranslation(
                      translation: const Offset(0, -0.1),
                      child: Image.asset(
                        "assets/avatar/accessory/${CustomizedAvatar.accessories[index]}",
                        width: 125,
                        height: 75,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 50, color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundButton(
                onPressed: saveAvatar,
                child: const Text(
                  "Sauvegarder",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ],
    );
  }
}
