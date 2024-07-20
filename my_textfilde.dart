import 'package:flutter/material.dart';

class MyTextFilde extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool obscureText;
  final Icon icon;
  final double width;
  final double? hight;
  final GestureDetector? decoration;
  const MyTextFilde(
      this.controller, this.hintText, this.obscureText, this.icon, this.width,
      {this.labelText, this.decoration, super.key, this.hight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
        height: hight,
        width: width,
        child: TextField(
          textAlign: TextAlign.left,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.circular(30.0)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(30.0)),
            hintText: hintText,
            hintTextDirection: TextDirection.rtl,
            suffixIcon: icon,
            labelText: labelText,
            // suffixIcon: decoration
          ),
        ),
      ),
    );
  }
}
