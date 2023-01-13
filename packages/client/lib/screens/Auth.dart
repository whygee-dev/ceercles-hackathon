import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'package:transparent_image/transparent_image.dart';

import '../widgets/common/RoundButton.dart';
import 'Login.dart';
import 'Register.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  static const route = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/auth/girl.png"),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(
        //         Color.fromRGBO(255, 255, 255, 0.7), BlendMode.lighten),
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: const AssetImage(
                        'assets/logo-dalmatian.png',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RoundButton(
                      borderWidth: 0,
                      onPressed: () => {context.vRouter.to(Register.route)},
                      child: Text(
                        "S'inscrire",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    RoundButton(
                      onPressed: () => {context.vRouter.to(Login.route)},
                      child: Text(
                        "Se connecter",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      backgroundColor: Colors.white,
                      splashColor: Theme.of(context).primaryColorLight,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
