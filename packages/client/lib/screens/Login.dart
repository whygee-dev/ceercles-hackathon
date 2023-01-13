import 'package:flutter/material.dart';
import 'package:client/widgets/common/CAppBar.dart';
import 'package:vrouter/vrouter.dart';

import '../widgets/common/RoundButton.dart';
import '../widgets/forms/LoginForm.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CAppBar(),
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/login/girl.png"),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(
        //         Color.fromRGBO(255, 255, 255, 0.7), BlendMode.lighten),
        //   ),
        // ),
        child: Padding(
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
                        "Ravi de vous revoir!",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w600),
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
                        "Reprenez là où vous en étiez en vous connectant à votre compte.",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
              const LoginForm()
            ],
          ),
        ),
      ),
    );
  }
}
