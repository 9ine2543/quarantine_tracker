import 'package:flutter/material.dart';
import 'package:quarantine_tracker/pages/quarantineLocation.dart';
import 'package:quarantine_tracker/utils/RegisterValidation.dart';
import 'package:quarantine_tracker/utils/RegisterSizing.dart';
import 'package:quarantine_tracker/widgets/register/heading.dart';
import 'package:quarantine_tracker/widgets/register/formHeading.dart';
import 'package:quarantine_tracker/widgets/register/formInput.dart';
import 'package:quarantine_tracker/services/registration.dart';

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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            RegisterHeading(),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: boxHeight,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFD2ECFF),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                              right: Radius.circular(40))),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'ข้อมูลผู้ป่วย',
                                      style: TextStyle(
                                          color: Color(0xFF427496),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          fontSize: 21),
                                    ),
                                  ],
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
            SizedBox(
              height: 15,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                decoration: BoxDecoration(
                    color: _canConfirm ? Color(0xFF427496) : Color(0xFFC4C4C4),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40))),
                child: _canConfirm
                    ? FlatButton(
                        onPressed: () {
                          sendPayloadForRegister(
                              citizenId: citizenId,
                              name: name,
                              surname: surname,
                              phoneNumber: phoneNumber,
                              organization: organization,
                              hospital: hospital,
                              days: days);
                          saveToSharedPreferences(
                              citizenId: citizenId,
                              name: name,
                              surname: surname,
                              hospital: hospital,
                              organization: organization,
                              days: days);
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ))
                    : FlatButton(
                        onPressed: null,
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ))),
          ],
        ),
      ),
    );
  }
}
