import 'package:client/widgets/common/RoundButton.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class ParamRow extends StatelessWidget {
  final String title;
  final String? route;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget? customContent;
  const ParamRow(
      {Key? key,
      required this.title,
      this.route,
      this.padding = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      this.margin = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      this.customContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => route != null ? context.vRouter.to(route!) : null,
      child: Container(
        padding: padding,
        margin: margin,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              if (customContent == null)
                const Expanded(
                  flex: 3,
                  child: RoundButton(
                    child: Text(
                      "Modifier",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                customContent!
            ],
          ),
        ),
      ),
    );
  }
}
