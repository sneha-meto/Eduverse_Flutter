import 'package:flutter/material.dart';

class About extends StatelessWidget {
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
          title: Text('About', style: TextStyle(fontSize: 25)),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.info_outline, color: Colors.white70),
                ),
                Text(
                  "Eduverse aims to make online education convenient for colleges through bringing official messaging, task updates and notifications in one place.\n"
                  "We are a team of enthusiastic students from School of Engineering, Cochin University of Science and Technology and this app was created as part of our third year Android mini project.\n\n"
                  "Developer Team:",
                  softWrap: true,
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                DevCard(
                    isLeft: true,
                    name: "Sneha Meto",
                    email: "snehameto@gmail.com",
                    image: "assets/images/sneha.jpeg"),
                DevCard(
                    isLeft: false,
                    name: "Sangeetha P",
                    email: "sangeethasuseelkumar@gmail.com",
                    image: "assets/images/sangeetha.jpeg"),
                DevCard(
                    isLeft: true,
                    name: "P. A. Adheela Farzana",
                    email: "adhee.asif@gmail.com",
                    image: "assets/images/adheela.jpeg"),
                DevCard(
                    isLeft: false,
                    name: "Resmi A R",
                    email: "resmiar79@gmail.com",
                    image: "assets/images/resmi.jpeg"),
              ],
            ),
          ),
        ));
  }
}

class DevCard extends StatefulWidget {
  DevCard({this.isLeft, this.name, this.email, this.image});

  final bool isLeft;
  final String name;
  final String email;
  final String image;

  @override
  _DevCardState createState() => _DevCardState();
}

class _DevCardState extends State<DevCard> {
  double width = 230;
  double radius = 25;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        width = 290;
        radius = 40;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.bounceOut,
              padding: EdgeInsets.all(10.0),
              height: 55,
              width: width,
              child: Row(
                children: [
                  widget.isLeft ? SizedBox(width: 75) : Container(),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15)),
            ),
//        ),

            AnimatedContainer(
              duration: Duration(seconds: 1),
              child: Positioned(
                top: -10,
                right: widget.isLeft ? null : -10,
                left: widget.isLeft ? -10 : null,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    widget.image,
                  ),
                  radius: radius,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ],
          clipBehavior: Clip.none,
        ),
      ),
    );
  }
}
