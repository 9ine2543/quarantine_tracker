import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'dart:async';

class quarantineLocation extends StatefulWidget {

  final lat;
  final lng;

  quarantineLocation({this.lat,this.lng});

  @override
  _quarantineLocationState createState() => _quarantineLocationState();
}

class _quarantineLocationState extends State<quarantineLocation> {

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 50, bottom: 30, left: 30, right: 30),
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled:true,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: false,
              // markers: {
              //   Marker(
              //     draggable: false,
              //     markerId: MarkerId("1"),
              //     position: LatLng(widget.lat, widget.lng),
              //   )
              // },
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat-0.000068,widget.lng),
                zoom: 18,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Align(
              alignment: Alignment.center,
              child: RippleAnimation(),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 155,
                width:200,
                child:Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.location_on, size: 70,color: Color(0xFF427496),),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                           'ระบบกำลังติดตาม',
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold
                           ),
                          ),
                    ),
                    Positioned(
                      top: 90,
                      left: 14,
                      child: Text(
                           'ที่อยู่ปัจจุบันของคุณ',
                           style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold
                           ),
                          ),
                    ),
                  ],
                ),
              )
            ),

          ],
        ),
      ),
    );
  }
}

class SpritePainter extends CustomPainter {
  final Animation<double> _animation;

  SpritePainter(this._animation) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (0.7 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = new Color.fromRGBO(66, 116, 150, opacity-10);

    double size = rect.width / 1.5;
    double area = size * size;
    double radius = sqrt(area * value / 4);

    final Paint paint = new Paint()..color = color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = new Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value );
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}

class RippleAnimation extends StatefulWidget {
  @override
  RippleAnimationState createState() => new RippleAnimationState();
}

class RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new CustomPaint(
        painter: new SpritePainter(_controller),
        child: new SizedBox(
          width: 200.0,
          height: 200.0,
        ),
      ),
    );
  }
}