import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? ontap;
  final String text;
  final IconData? icon;
  final double? width;

  // ignore: prefer_const_constructors_in_immutables
  MyButton(
    this.text, {
    this.width,
    this.icon,
    Key? key,
    @required this.ontap,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        if (widget.ontap != null) {
          widget.ontap!();
        }
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        width: widget.width,
        height: 50,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: _isPressed
                ? [
                    const Color.fromARGB(255, 0, 108, 5),
                    const Color.fromARGB(255, 0, 47, 2)
                  ]
                : [
                    const Color.fromARGB(255, 0, 108, 5),
                    const Color.fromARGB(255, 0, 47, 2)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              // ignore: prefer_const_constructors
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) Icon(widget.icon, color: Colors.white),
            if (widget.icon != null) const SizedBox(width: 8),
            Text(
              widget.text,
              style: const TextStyle(
                fontFamily: "Marhey-Regular",
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
