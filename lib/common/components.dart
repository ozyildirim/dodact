import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonComponents {
  Widget textField(String title,
      {bool isPassword = false,
      bool isNumber = false,
      int length,
      TextEditingController textController,
      String initialValue,
      bool readOnly = false,
      int lines = 1,
      Icon prefixIcon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 2,
          ),
          TextFormField(
            key: Key(initialValue),
            initialValue: initialValue,
            maxLines: lines,
            controller: textController,
            maxLength: length,
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
            obscureText: isPassword,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            readOnly: readOnly,
            decoration: InputDecoration(
                prefixIcon: prefixIcon,
                counterText: '',
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }
}
