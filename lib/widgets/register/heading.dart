import 'package:flutter/material.dart';

class RegisterHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 40, bottom: 20),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0, 0),
              blurRadius: 10,
            )
          ]),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 60,
                color: Color(0xFF427496),
              )
            ],
          ),
          Positioned(
            bottom: 15,
            child: Text(
              'ลงทะเบียน',
              style: TextStyle(fontSize: 48, color: Color(0xFF427496)),
            ),
          ),
          Positioned(
              bottom: 8,
              child: Text(
                'โปรดกรอกข้อมูลตามความจริง',
                style: TextStyle(fontSize: 11, color: Colors.black),
              ))
        ],
      ),
    );
  }
}
