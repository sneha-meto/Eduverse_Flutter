import 'package:eduverse/Services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:eduverse/Pages/groups_page.dart';
import 'package:eduverse/Pages/inbox_page.dart';
import 'package:eduverse/Pages/home_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    GroupsWidget(),
    InboxWidget()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getUserInfo() async {
    Constants.myName = await UserHelper.getName();
    Constants.myRole = await UserHelper.getRole();
    Constants.myBranch = await UserHelper.getBranch();
    print(Constants.myName);
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
          child: BottomNavigationBar(
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              iconSize: 26,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              backgroundColor: Colors.transparent,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: "Groups",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail),
                  label: "Inbox",
                ),
              ]),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
