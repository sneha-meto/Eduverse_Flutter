import 'package:eduverse/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TextBox extends StatefulWidget {
  final TextInputType textInputType;
  final String hint;
  final TextEditingController controller;

  TextBox({this.textInputType, this.hint, this.controller});

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
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
          if (value.isEmpty) {
            return 'This field is required';
          }
          return null;
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

class YearBox extends StatefulWidget {
  final TextInputType textInputType;
  final String hint;
  final TextEditingController controller;

  YearBox({this.textInputType, this.hint, this.controller});
  @override
  _YearBoxState createState() => _YearBoxState();
}

class _YearBoxState extends State<YearBox> {

  var alertStyle = AlertStyle(
    overlayColor: Colors.transparent,
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(60.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Color(0xFF54ABD0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      child: TextFormField(
        obscureText: false,
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        keyboardType: widget.textInputType,
        validator: (String value) {
          if (value.isEmpty) {
            return 'This field is required';
          }
          else if(int.parse(value) >= 2021) {
              print(value);
            }
            else {
              Alert(
                context: context,
                style: alertStyle,
                type: AlertType.info,
                title: "Invalid",
                desc: "Invalid Year ",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Close",
                      style: TextStyle(
                          color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: Color(0xFF54ABD0),
                    radius: BorderRadius.circular(10.0),
                  ),
                ],
              ).show();
            }
          return null;
        },
        // autofocus: true,
        controller: widget.controller,
        // onChanged: (String value) {
        //   try {
        //     if (int.parse(value) >= 2022) {
        //       return value;
        //     }
        //   } catch (e) {
        //     print(e);
        //
        //     }
        // },
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

