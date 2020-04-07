import 'package:flutter/material.dart';

class RegisterHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 40, bottom: 20),
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 60,
                color: Colors.white,
              )
            ],
          ),
          Positioned(
            bottom: 15,
            child: Text(
              'ลงทะเบียน',
              style: TextStyle(fontSize: 48, color: Colors.white, letterSpacing: -2),
            ),
          ),
          Positioned(
              bottom: 8,
              child: Text(
                'โปรดกรอกข้อมูลตามความจริง',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ))
        ],
      ),
    );
  }
}
