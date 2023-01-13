import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../utils/Formatters.dart';
import '../common/RoundButton.dart';

class ShopItem extends StatelessWidget {
  String title;
  double value;
  double price;
  String type;
  String image;

  ShopItem(
      {super.key,
      required this.title,
      required this.value,
      required this.price,
      required this.type,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage(
                      image: NetworkImage(image),
                      placeholder: MemoryImage(kTransparentImage),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "${removeDecimalZeroFormat(price)} €",
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Prix: ${removeDecimalZeroFormat(value)} Points",
                  style: const TextStyle(fontSize: 18),
                ),
                const RoundButton(
                  radius: 5,
                  child: Text(
                    "Acheter",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
