import 'package:flutter/material.dart';
import 'package:eduverse/constants.dart';
import 'package:eduverse/Pages/teacher_signup.dart';
import 'package:eduverse/Pages/student_signup.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0XFF2A2D41),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Hello !',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('EDUVERSE',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('Pick your role to get started',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  // Text('Pick your role to get started'),
                ],
              ),
              SizedBox(height: 20),
              BoxWidget(
                  color: kBlue,
                  image: "assets/images/faculty.png",
                  title: 'Faculty',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Teacher(),
                        ));
                  }),
              SizedBox(
                height: 30,
              ),
              BoxWidget(
                  color: kPurple,
                  image: "assets/images/student.png",
                  title: 'Student',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Student(),
                        ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxWidget extends StatelessWidget {
  final Color color;
  final String title;
  final String image;
  final Function onTap;
  BoxWidget({this.color, this.title, this.image, this.onTap});
  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.5;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        height: boxWidth,
        width: boxWidth,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
