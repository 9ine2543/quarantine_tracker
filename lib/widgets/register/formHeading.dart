import 'package:flutter/material.dart';

class FormHeading extends StatelessWidget {
  final String heading;

  FormHeading({this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: TextStyle(
          color: Color(0xFFFF6204),
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
          letterSpacing: -0.5,
          fontSize: 21),
    );
  }
}
