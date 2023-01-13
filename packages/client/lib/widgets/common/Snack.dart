import 'package:flutter/material.dart';

SnackBar Snack(
  BuildContext context,
  String message, [
  Duration? duration,
]) {
  return SnackBar(
    content: Text(message),
    duration: duration ?? const Duration(seconds: 30),
    backgroundColor: Theme.of(context).primaryColor,
  );
}

showSnack(BuildContext context, String message, [Duration? duration]) {
  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(Snack(context, message, duration));
}

clearSnack(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
}

showServerErrorSnack(BuildContext context) {
  showSnack(
    context,
    "Une erreur inattendu est survenue",
    const Duration(seconds: 5),
  );
}
