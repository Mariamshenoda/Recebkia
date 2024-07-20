import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDivider extends StatelessWidget {
  MyDivider({super.key, required this.titel});
  String titel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            endIndent: 20,
            indent: 500,
            color: Colors.green,
            thickness: 6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            textAlign: TextAlign.right,
            titel,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Marhey-Regular"),
          ),
        ),
        Expanded(
          child: Divider(
            endIndent: 500,
            indent: 20,
            color: Colors.green,
            thickness: 6,
          ),
        ),
      ],
    );
  }
}
