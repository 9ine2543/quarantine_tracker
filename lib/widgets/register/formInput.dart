import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatefulWidget {
  final String dataType;
  final Function(String) onChange;

  FormInput({this.dataType, this.onChange});

  @override
  _FormInput createState() => new _FormInput();
}

class _FormInput extends State<FormInput> {
  final TextEditingController inputController = new TextEditingController();

  _handleChange() {
    print("Input : ${inputController.text}");
    widget.onChange(inputController.text);
  }

  @override
  void initState() {
    super.initState();
    inputController.addListener(_handleChange);
  }

  Widget _buildInput() {
    switch (widget.dataType) {
      case 'text':
        return Container(
            height: 50,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]),
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(40), right: Radius.circular(40))),
            child: TextField(
              controller: inputController,
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.text,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[A-Za-zก-๙ ]")),
                BlacklistingTextInputFormatter(RegExp("[๐-๙]"))
              ],
            ));
      case 'number':
        return Container(
          height: 50,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(40), right: Radius.circular(40))),
          child: TextField(
            controller: inputController,
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(13),
              WhitelistingTextInputFormatter.digitsOnly
            ],
          ),
        );
      case 'days':
        return Container(
          height: 50,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(40), right: Radius.circular(40))),
          child: TextField(
            controller: inputController,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: '( xx วัน )'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[0-9]")),
            ],
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildInput();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}
