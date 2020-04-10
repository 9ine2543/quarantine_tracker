import 'package:flutter/material.dart';
import 'package:quarantine_tracker/utils/RegisterValidation.dart';
import 'package:quarantine_tracker/utils/RegisterSizing.dart';
import 'package:quarantine_tracker/widgets/register/heading.dart';
import 'package:quarantine_tracker/widgets/register/formHeading.dart';
import 'package:quarantine_tracker/widgets/register/formInput.dart';
import 'package:quarantine_tracker/services/registration.dart';
import 'package:geolocator/geolocator.dart';
import 'addHomeLocation.dart';

class RegisterQuarantine extends StatefulWidget {
  @override
  _RegisterQuarantineState createState() => _RegisterQuarantineState();
}

class _RegisterQuarantineState extends State<RegisterQuarantine> {
  bool _canConfirm, typeOne, typeTwo;
  String _value;
  double boxHeight;
  String name, surname, citizenId, phoneNumber, organization, days;
  String hospital, patientName, patientSurname, patientCitizenId;
  Position _currentPosition;
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String _title = 'โปรดเลือกที่อยู่อาศัย';
  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  void moveToAddHome() async {
    final information = await Navigator.push(context,MaterialPageRoute(builder: (context) => addHomeLocation(current: _currentPosition,)));

    if(information[0] != null){
      _title = 'ระบบเก็บที่อยู่ของคุณเรียบร้อยแล้ว';
    }

  }

  @override
  Widget build(BuildContext context) {
    boxHeight = getRegisterFormSizing(_value);
    typeOne = enablePatientForm(_value);
    typeTwo = enableRelativesForm(_value);

    if (validateGeneralInputs(
            name, surname, citizenId, phoneNumber, organization) &&
        _value != null) {
      if (_value == '1') {
        _canConfirm = validatePatientInputs(days, hospital);
      } else if (_value == '2') {
        _canConfirm = validateRelativeInputs(
            days, patientCitizenId, patientName, patientSurname);
      }
    } else {
      _canConfirm = false;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.05,
              0.2,
              0.3,
              0.4,
            ],
            colors: [
              Color(0xFFFFA24C), 
              Color(0xFFFF8122),
              Color(0xFFFF6204),
              Color(0xFFF25300)
            ]
          ),
        ),
        child: ListView(
          children: <Widget>[
            RegisterHeading(),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: boxHeight,
              padding: EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 14,),
                    FormHeading(heading: 'ชื่อจริง'),
                    SizedBox(
                      height: 10,
                    ),
                    FormInput(
                        dataType: 'text',
                        onChange: (input) {
                          setState(() {
                            name = input;
                          });
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    FormHeading(heading: 'นามสกุล'),
                    SizedBox(
                      height: 10,
                    ),
                    FormInput(
                        dataType: 'text',
                        onChange: (input) {
                          setState(() {
                            surname = input;
                          });
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    FormHeading(heading: 'เลขบัตรประชาชน'),
                    SizedBox(
                      height: 10,
                    ),
                    FormInput(
                        dataType: 'number',
                        onChange: (input) {
                          setState(() {
                            citizenId = input;
                          });
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    FormHeading(heading: 'หมายเลขโทรศัพท์เคลื่อนที่'),
                    SizedBox(
                      height: 10,
                    ),
                    FormInput(
                        dataType: 'number',
                        onChange: (input) {
                          setState(() {
                            phoneNumber = input;
                          });
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    FormHeading(heading: 'ที่อยู่อาศัย'),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(40), right: Radius.circular(40))),
                      child: FlatButton(
                        onPressed: (){
                          moveToAddHome();
                        }, 
                        child: Text(_title)
                      )
                    ),
                    FormHeading(heading: 'รหัสหน่วยงานที่ดูแล'),
                    SizedBox(
                      height: 10,
                    ),
                    FormInput(
                        dataType: 'number',
                        onChange: (input) {
                          setState(() {
                            organization = input;
                          });
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(40),
                            right: Radius.circular(40)),
                        border: Border.all(color: Colors.grey[300])
                      ),
                        
                      child: DropdownButton<String>(
                        items: [
                          DropdownMenuItem<String>(
                            child: Text('ผู้ป่วย covid-19'),
                            value: '1',
                          ),
                          DropdownMenuItem<String>(
                            child: Text('ผู้ใกล้ชิดผู้ป่วย'),
                            value: '2',
                          ),
                        ],
                        onChanged: (String value) {
                          setState(() {
                            _value = value;
                          });
                        },
                        hint: Text('ประเภทของผู้สมัคร'),
                        isExpanded: true,
                        value: _value,
                      ),
                    ),
                    typeOne
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                FormHeading(heading: 'โรงพยาบาล'),
                                SizedBox(
                                  height: 10,
                                ),
                                FormInput(
                                    dataType: 'text',
                                    onChange: (input) {
                                      setState(() {
                                        hospital = input;
                                      });
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                FormHeading(heading: 'ระยะเวลา'),
                                SizedBox(
                                  height: 10,
                                ),
                                FormInput(
                                    dataType: 'days',
                                    onChange: (input) {
                                      setState(() {
                                        days = input;
                                      });
                                    }),
                              ],
                            ),
                          )
                        : PreferredSize(
                            child: Container(),
                            preferredSize: Size(0.0, 0.0),
                          ),
                    typeTwo
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFFFFA24C), 
                                        Color(0xFFFF8122),
                                        Color(0xFFFF6204),
                                        Color(0xFFF25300)
                                      ]
                                    ),
                                  ),
                                  child: Text(
                                      'ข้อมูลผู้ป่วย',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.none,
                                          fontSize: 21,
                                          ),
                                    ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FormHeading(heading: 'ชื่อจริง'),
                                SizedBox(
                                  height: 10,
                                ),
                                FormInput(
                                    dataType: 'text',
                                    onChange: (input) {
                                      setState(() {
                                        patientName = input;
                                      });
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                FormHeading(heading: 'นามสกุล'),
                                SizedBox(
                                  height: 10,
                                ),
                                FormInput(
                                    dataType: 'text',
                                    onChange: (input) {
                                      setState(() {
                                        patientSurname = input;
                                      });
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                FormHeading(heading: 'เลขบัตรประชาชน'),
                                SizedBox(
                                  height: 10,
                                ),
                                FormInput(
                                    dataType: 'number',
                                    onChange: (input) {
                                      setState(() {
                                        patientCitizenId = input;
                                      });
                                    }),
                                SizedBox(
                                  height: 10,
                                ),
                                FormHeading(heading: 'ระยะเวลา'),
                                SizedBox(
                                  height: 10,
                                ),
                                FormInput(
                                    dataType: 'days',
                                    onChange: (input) {
                                      setState(() {
                                        days = input;
                                      });
                                    }),
                              ],
                            ),
                          )
                        : PreferredSize(
                            child: Container(),
                            preferredSize: Size(0.0, 0.0),
                          ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                    color: _canConfirm ? Color(0xFF427496) : Color(0xFFC4C4C4),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40))),
                child: _canConfirm
                    ? FlatButton(
                        onPressed: () {
                          _getCurrentLocation();

                          sendPayloadForRegister(
                              citizenId: citizenId,
                              name: name,
                              surname: surname,
                              phoneNumber: phoneNumber,
                              organization: organization,
                              hospital: hospital,
                              days: days,
                              lat: _currentPosition.latitude,
                              lng: _currentPosition.longitude);
                          saveToSharedPreferences(
                              citizenId: citizenId,
                              name: name,
                              surname: surname,
                              hospital: hospital,
                              organization: organization,
                              days: days,
                              lat: _currentPosition.latitude,
                              lng: _currentPosition.longitude);
                          
                          print(_currentPosition);
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        )
                      )
                    : FlatButton(
                        onPressed: null,
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        )
                      )
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
