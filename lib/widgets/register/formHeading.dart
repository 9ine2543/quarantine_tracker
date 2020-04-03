import 'package:flutter/material.dart';

class FormHeading extends StatelessWidget {
  final String heading;

  FormHeading({this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: TextStyle(
          color: Color(0xFF427496),
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          fontSize: 21),
    );
  }
}
