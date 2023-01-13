import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final String label;
  final Function(bool value) onChange;
  final bool value;

  CheckBox(
      {Key? key,
      required this.label,
      required this.onChange,
      required this.value})
      : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(
            MediaQuery.of(context).size.width / 2.25,
            120,
          )),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? Theme.of(context).primaryColorLight
                  : null;
            },
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: Icon(
                Icons.check_circle_outline,
                color: widget.value
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 40),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width / 29,
                ),
              ),
            ),
          ],
        ),
        onPressed: () => widget.onChange(!widget.value));
  }
}
