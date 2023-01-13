import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? route;
  final List<Widget>? children;
  const CustomCard({Key? key, required this.title, this.route, this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: children != null
                  ? children!
                  : const [
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
                      Spacer(flex: 10),
                    ],
            ),
          )
        ],
      ),
    );
  }
}
