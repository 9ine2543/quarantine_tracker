import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dashBoardMain extends StatefulWidget {
  final String name, surname, hospital;

  dashBoardMain({this.name, this.surname, this.hospital});
  @override
  _dashBoardMainState createState() => _dashBoardMainState();
}

class _dashBoardMainState extends State<dashBoardMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.1,
              0.3,
              0.5,
              0.7,
            ],
            colors: [
              Color(0xFFFFA24C), 
              Color(0xFFFF8122),
              Color(0xFFFF6204),
              Color(0xFFF25300)
            ]
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0,-0.84),
              child: Container(
                child: Text(
                  'สวัสดี',
                  style: TextStyle(
                    color: Color(0xFF6B6B6B),
                    fontSize: 24
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment(0,-0.775),
              child: Container(
                child: Text(
                  'คุณ ${widget.name} ${widget.surname}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    letterSpacing: -2 
                  ),
                  ),
              )
            ),
            widget.hospital != null ? Align(
              alignment: Alignment(0,-0.64),
              child: Container(
                child: Text(
                  'โรงพยาบาล${widget.hospital}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: -2,
                    fontWeight: FontWeight.w300 
                  ),
                ),
              )
            ):PreferredSize(
                child: Container(),
                preferredSize: Size(0.0, 0.0),
              ),
            Align(
              alignment: Alignment(0,-0.48),
              child: Container(
                child: Transform.scale(scale: 0.8, child: Image.asset('assets/logo/Union.png'))
              )
            ),
            Align(
              alignment: Alignment(0,-0.52),
              child: Container(
                child: Text(
                  'วันที่กักตัว',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w100 
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment(0,-0.435),
              child: Container(
                child: Text(
                  '14',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Prompt',
                    fontSize: 90,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w100 
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment(-0.64,-0.165),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white 
                ),
                child: Stack(
                 children: <Widget>[
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Text(
                        'ออกนอก',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 13
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.4),
                      child: Text(
                        'เขตบ้าน',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 13
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 1.89),
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          fontFamily: 'Prompt',
                          letterSpacing: -0.5,
                          fontSize: 48
                        ),
                      ),
                    )
                 ], 
                ),
              )
            ),
            Align(
              alignment: Alignment(0.64,-0.165),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white 
                ),
                child: Stack(
                 children: <Widget>[
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Text(
                        'ขาดการ',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 13
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.4),
                      child: Text(
                        'เชื่อมต่อ',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 13
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 1.89),
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          fontFamily: 'Prompt',
                          letterSpacing: -0.5,
                          fontSize: 48
                        ),
                      ),
                    )
                 ], 
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}