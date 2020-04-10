import 'package:flutter/material.dart';

class RegisterHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 40,),
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 38,
            child: Text(
              'ลงทะเบียน',
              style: TextStyle(fontSize: 48, color: Colors.white, letterSpacing: -2),
            ),
          ),
          Positioned(
              bottom: 31,
              child: Text(
                'โปรดกรอกข้อมูลตามความจริง',
                style: TextStyle(fontSize: 11, color: Colors.white),
              )),
          Positioned(
            top: 5,
            left: 170,
            child: Transform.scale(
              scale: 1,
              child: Image.asset(
                'assets/logo/logo.png',
                ),
              )
          )
        ],
      ),
    );
  }
}
