import 'package:eduverse/Utils/constants.dart';
import 'package:flutter/material.dart';

class TextBox extends StatefulWidget {
  final TextInputType textInputType;
  final String hint;
  final TextEditingController controller;
  final String fieldName;

  TextBox({this.textInputType, this.hint, this.controller, this.fieldName});

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  String validate(String value, String type) {
    if (value.isEmpty) {
      return 'This field is required';
    }

    switch (type) {
      case "year":
        if (int.parse(value) < 2021 || int.parse(value) > 2031) {
          return 'Please enter a valid year';
        }
        break;

      case "password":
        if (value.length < 6) {
          return 'Password should be at least 6 characters';
        }
        break;

      case "register":
        if (value.length != 8) {
          return 'Register number should be 8 digits long';
        }
        break;

      case "phone":
        if (value.length != 10) {
          return 'Phone number should be 10 digits long';
        }
        break;

      case "email":
        Pattern pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$";
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value) || value == null)
          return 'Enter a valid email address';
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      child: TextFormField(
        obscureText: false,
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        keyboardType: widget.textInputType,
        validator: (value) {
          String result = validate(value, widget.fieldName);
          return result;
        },
        // autofocus: true,
        controller: widget.controller,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Color(0xFF54ABD0),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Color(0xFF54ABD0),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Color(0xFF54ABD0),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Color(0xFF54ABD0), width: 2),
          ),
        ),
      ),
    );
  }
}

class Button extends StatefulWidget {
  final String buttonName;
  final Function onTap;

  Button({this.buttonName, this.onTap});

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(colors: [kBlue, kCyan])),
            child: Center(
              child: Text(
                widget.buttonName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2)]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
