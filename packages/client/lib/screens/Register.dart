import 'package:flutter/material.dart';

import '../widgets/common/CAppBar.dart';
import '../widgets/forms/RegisterForm.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  static const route = '/register';

  @override
  Widget build(BuildContext context) {
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
                        "Let's act together",
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
                        "Commencer votre aventure en créant votre compte",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
              const RegisterForm()
            ],
          ),
        ),
      ),
    );
  }
}
