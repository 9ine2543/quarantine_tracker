import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class addHomeLocation extends StatefulWidget {

  final Position current;

  addHomeLocation({this.current});

  @override
  _addHomeLocationState createState() => _addHomeLocationState();
}

class _addHomeLocationState extends State<addHomeLocation> {

  double latitude = 0, longitude = 0;
  GoogleMapController _controller;
  Position _currentPosition;
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {

    _currentPosition = widget.current;

    if(_controller != null){
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latitude , longitude),
        zoom: 18
      )));
    }
    
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
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
              // markers: {
              //   Marker(
              //     markerId: MarkerId('HomeMarker'),
              //     position: LatLng(latitude, longitude)
              //     )
              // },
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition.latitude , _currentPosition.longitude),
                zoom: 18,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onCameraMove: (CameraPosition cameraPosition){
                latitude = cameraPosition.target.latitude;
                longitude = cameraPosition.target.longitude;
                print("$latitude : $longitude");
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 193,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/logo/logo2.png',
                      width: 58.5,
                      height: 95,
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pop(context,[latitude,longitude]);
        },
        label: Text('ยืนยัน'),
      ),
    );
  }

  void _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

}