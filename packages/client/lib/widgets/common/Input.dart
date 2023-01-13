import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:vrouter/vrouter.dart';

Widget Input(BuildContext context, IconData? icon, String hint,
    TextEditingController controller, Function validate,
    {double? width,
    double paddingVertical = 0.0,
    double paddingHorizontal = 0.0,
    bool requiredField = true,
    bool obscureText = false,
    bool date = false,
    Function(String)? onChanged,
    Function(DateTime)? onDateConfirm,
    Color? fillColor,
    double? radius,
    Function()? onTap,
    Color? hintColor,
    bool withCounter = false,
    int? maxLength}) {
  var window = MediaQuery.of(context).size;

  return SizedBox(
    width: width ?? window.width / 1.15,
    child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: paddingVertical, horizontal: paddingHorizontal),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textDirection: TextDirection.ltr,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 17),
        cursorColor: Theme.of(context).primaryColor,
        controller: controller,
        obscureText: obscureText,
        maxLengthEnforcement:
            maxLength != null ? MaxLengthEnforcement.enforced : null,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: withCounter
              ? controller.text.length.toString() + "/" + maxLength.toString()
              : null,
          filled: true,
          fillColor: fillColor ?? Colors.white,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 15.0),
            ),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 6),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 15.0),
            ),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 6),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(radius ?? 15.0),
            ),
            borderSide:
                BorderSide(color: Theme.of(context).errorColor, width: 6),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: hintColor ?? Color.fromRGBO(0, 0, 0, 0.3),
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: Theme.of(context).primaryColor)
              : null,
          isCollapsed: true,
        ),
        validator: (value) {
          if (requiredField && (value == null || value.isEmpty)) {
            return 'Ce champs est requis';
          }

          return validate(value);
        },
        onChanged: onChanged,
        readOnly: date,
        onTap: () {
          if (onTap != null) {
            onTap();
          }

          if (date) {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1900, 1, 1),
              maxTime: DateTime(DateTime.now().year - 10, DateTime.now().month,
                  DateTime.now().day),
              onConfirm: onDateConfirm,
              currentTime: DateTime.now(),
              locale: LocaleType.fr,
              theme: DatePickerTheme(
                backgroundColor: Theme.of(context).primaryColor,
                cancelStyle: const TextStyle(color: Colors.white),
                doneStyle: const TextStyle(color: Colors.white),
                itemStyle: const TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    ),
  );
}
