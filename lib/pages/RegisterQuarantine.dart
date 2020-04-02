import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quarantine_tracker/utils/RegisterValidation.dart';
import 'package:quarantine_tracker/utils/RegisterSizing.dart';
import 'package:quarantine_tracker/widgets/register/heading.dart';

class RegisterQuarantine extends StatefulWidget {
  @override
  _RegisterQuarantineState createState() => _RegisterQuarantineState();
}

class _RegisterQuarantineState extends State<RegisterQuarantine> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController surnameController = new TextEditingController();
  final TextEditingController idCardController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController organizeController = new TextEditingController();

  final TextEditingController dayController = new TextEditingController();
  //typeOne ONLY
  final TextEditingController hospitalController = new TextEditingController();
  //TypeTwo ONLY
  final TextEditingController covidNameController = new TextEditingController();
  final TextEditingController covidSurNameController =
      new TextEditingController();
  final TextEditingController covidIDCardController =
      new TextEditingController();

  bool _canConfirm, typeOne, typeTwo;
  String _value;
  double boxHeight;
  @override
  Widget build(BuildContext context) {
    boxHeight = getRegisterFormSizing(_value);
    typeOne = enablePatientForm(_value);
    typeTwo = enableRelativesForm(_value);

    if (validateGeneralInputs(
            nameController.text,
            surnameController.text,
            idCardController.text,
            phoneController.text,
            organizeController.text) &&
        _value != null) {
      if (_value == '1') {
        _canConfirm =
            validatePatientInputs(dayController.text, hospitalController.text);
      } else if (_value == '2') {
        _canConfirm = validateRelativeInputs(
            dayController.text,
            covidIDCardController.text,
            covidNameController.text,
            covidSurNameController.text);
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
                    Text(
                      'ชื่อจริง',
                      style: TextStyle(
                          color: Color(0xFF427496),
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          fontSize: 21),
                    ),
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
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                              RegExp("[A-Za-zก-๙ ]")),
                          BlacklistingTextInputFormatter(RegExp("[๐-๙]"))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'นามสกุล',
                      style: TextStyle(
                          color: Color(0xFF427496),
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          fontSize: 21),
                    ),
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
                      child: TextField(
                        controller: surnameController,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                              RegExp("[A-Za-zก-๙ ]")),
                          BlacklistingTextInputFormatter(RegExp("[๐-๙]"))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'เลขบัตรประชาชน',
                      style: TextStyle(
                          color: Color(0xFF427496),
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          fontSize: 21),
                    ),
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
                      child: TextField(
                        controller: idCardController,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(13),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'หมายเลขโทรศัพท์เคลื่อนที่',
                      style: TextStyle(
                          color: Color(0xFF427496),
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          fontSize: 21),
                    ),
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
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'รหัสหน่วยงานที่ดูแล',
                      style: TextStyle(
                          color: Color(0xFF427496),
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          fontSize: 21),
                    ),
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
                      child: TextField(
                          controller: organizeController,
                          decoration: InputDecoration(border: InputBorder.none),
                          keyboardType: TextInputType.text),
                    ),
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
                                Text(
                                  'โรงพยาบาล',
                                  style: TextStyle(
                                      color: Color(0xFF427496),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 21),
                                ),
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
                                  child: TextField(
                                    controller: hospitalController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp("[A-Za-z0-9ก-๙ ]")),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'ระยะเวลา',
                                  style: TextStyle(
                                      color: Color(0xFF427496),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 21),
                                ),
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
                                  child: TextField(
                                    controller: dayController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '( xx วัน )'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp("[0-9]")),
                                    ],
                                  ),
                                ),
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
                                Text(
                                  'ชื่อจริง',
                                  style: TextStyle(
                                      color: Color(0xFF427496),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 21),
                                ),
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
                                  child: TextField(
                                    controller: covidNameController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp("[A-Za-zก-๙ ]")),
                                      BlacklistingTextInputFormatter(
                                          RegExp("[๐-๙]"))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'นามสกุล',
                                  style: TextStyle(
                                      color: Color(0xFF427496),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 21),
                                ),
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
                                  child: TextField(
                                    controller: covidSurNameController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp("[A-Za-zก-๙ ]")),
                                      BlacklistingTextInputFormatter(
                                          RegExp("[๐-๙]"))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'เลขบัตรประชาชน',
                                  style: TextStyle(
                                      color: Color(0xFF427496),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 21),
                                ),
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
                                  child: TextField(
                                    controller: covidIDCardController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(13),
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'ระยะเวลา',
                                  style: TextStyle(
                                      color: Color(0xFF427496),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 21),
                                ),
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
                                  child: TextField(
                                    controller: dayController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '( xx วัน )'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp("[0-9]")),
                                    ],
                                  ),
                                ),
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
                        onPressed: () {},
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