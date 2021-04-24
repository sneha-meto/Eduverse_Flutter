import 'package:eduverse/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text('User Profile', style: TextStyle(fontSize: 20)),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 55,
                    child: Image.asset(
                      "assets/images/avatar.png",
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Text(
                    'Username',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Container(
                    margin: EdgeInsets.fromLTRB(70, 5, 0, 85),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: kBlue,
                      borderRadius: BorderRadius.circular(13),
                      shape: BoxShape.rectangle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                      child: profileData('Name :', 'Sangeetha'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: profileData('Branch :', 'Information Technology'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: profileData('Year :', '3'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: profileData('Phone :', '9188023790'),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class profileData extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  profileData(this.fieldName, this.fieldValue);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          fieldName,
          style: TextStyle(color: Colors.grey, fontSize: 17),
        ),
        Text(
          fieldValue,
          style: TextStyle(color: Colors.white, fontSize: 17),
        )
      ],
    );
  }
}
