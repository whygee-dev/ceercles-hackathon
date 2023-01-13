import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:client/utils/Math.dart';

import '../widgets/common/CAppBar.dart';
import '../widgets/forms/RegisterProfileForm.dart';

class RegisterProfile extends StatelessWidget {
  RegisterProfile({Key? key}) : super(key: key);

  static const route = '/register-profile';
  final int random = RandomInt.generate(min: 1, max: 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageSlideshow(
            indicatorColor: Theme.of(context).primaryColor,
            indicatorBackgroundColor: Colors.grey,
            children: [
              Container(),
              // Image.asset(
              //   "assets/images/register-profile/girl1.png",
              //   fit: BoxFit.cover,
              //   color: const Color.fromRGBO(255, 255, 255, 0.7),
              //   colorBlendMode: BlendMode.lighten,
              // ),
              // Image.asset(
              //   "assets/images/register-profile/girl2.png",
              //   fit: BoxFit.cover,
              //   color: const Color.fromRGBO(255, 255, 255, 0.7),
              //   colorBlendMode: BlendMode.lighten,
              // ),
              // Image.asset(
              //   "assets/images/register-profile/girl3.png",
              //   fit: BoxFit.cover,
              //   color: const Color.fromRGBO(255, 255, 255, 0.7),
              //   colorBlendMode: BlendMode.lighten,
              // ),
            ],
            autoPlayInterval: 7000,
            isLoop: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "Compléter votre profile !",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Text(
                          "Completer votre profil pour se faire mieux suivre, et avoir un contenu adapté.",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
                const RegisterProfileForm()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
