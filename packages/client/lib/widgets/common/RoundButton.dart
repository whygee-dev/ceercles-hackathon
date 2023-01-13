import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final double? radius;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? splashColor;

  const RoundButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.splashColor,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
          (states) {
            return states.contains(MaterialState.pressed)
                ? splashColor ?? Theme.of(context).primaryColorDark
                : null;
          },
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          backgroundColor ?? Theme.of(context).primaryColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 60),
            side: BorderSide(
                width: borderWidth ?? 3,
                color: borderColor ?? Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
