import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:eduverse/Utils/constants.dart';

class Tabs extends StatefulWidget {
  Tabs();

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.1),
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.white,
            labelColor: kCyan,
            tabs: [
              tabData('Materials'),
              tabData('Assignments'),
              tabData('Images')
            ],
          ),
          leading: IconButton(
            padding: EdgeInsets.only(left: 5),
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 20,
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Icon(Icons.photo_library),
              SizedBox(
                width: 15,
              ),
              Text(
                'Official IT',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            margin:
                                EdgeInsets.only(top: 20, left: 20, right: 20),
                            decoration: new BoxDecoration(
                              color: kCyan,
                              border:
                                  Border.all(color: Colors.black, width: 0.0),
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Text('Material 1'),
                                      Center(child: Text('120 KB')),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text('PDF'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(''),
            Text(''),
          ],
        ),
      ),
    );
  }
}

class tabData extends StatelessWidget {
  final String heading;
  tabData(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        heading,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}
