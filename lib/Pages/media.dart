import 'package:eduverse/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:intl/intl.dart';

class ChatMedia extends StatefulWidget {
  const ChatMedia(
      {@required this.groupId, @required this.name, @required this.isGroup});
  final String groupId;
  final String name;
  final bool isGroup;

  @override
  _ChatMediaState createState() => _ChatMediaState();
}

class _ChatMediaState extends State<ChatMedia> {
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
              TabTitle('Materials'),
              TabTitle('Assignments'),
              TabTitle('Images')
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
                widget.name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [materialsListing(), assignmentsListing(), imagesListing()],
        ),
      ),
    );
  }

  Widget materialsListing() {
    return Container(
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: widget.isGroup
            ? DatabaseMethods().getChats("groups", widget.groupId)
            : DatabaseMethods().getChats("chats", widget.groupId),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data["materials"].length,
                  itemBuilder: (context, i) {
                    return MediaTile(
                      file: snapshot.data["materials"][i],
                    );
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget assignmentsListing() {
    return Container(
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: widget.isGroup
            ? DatabaseMethods().getChats("groups", widget.groupId)
            : DatabaseMethods().getChats("chats", widget.groupId),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data["assignments"].length,
                  itemBuilder: (context, i) {
                    return MediaTile(
                      file: snapshot.data["assignments"][i],
                    );
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
    ;
  }

  Widget imagesListing() {
    return Container(
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: widget.isGroup
            ? DatabaseMethods().getChats("groups", widget.groupId)
            : DatabaseMethods().getChats("chats", widget.groupId),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemCount: snapshot.data["images"].length,
                  itemBuilder: (context, i) {
                    return Container(
                        child: Image.network(
                      snapshot.data["images"][i]["text"],
                      fit: BoxFit.cover,
                    ));
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MediaTile extends StatelessWidget {
  MediaTile({this.file});
  final file;

  String getSize(int size) {
    double mb = size / (1000 * 1000);
    double kb = size / 1000;
    if (mb < 1)
      return "${kb.toStringAsFixed(2)} KB";
    else
      return "${mb.toStringAsFixed(2)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(file["name"],
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(file["extension"].toString().toUpperCase(),
                    style: TextStyle(color: Colors.white70, fontSize: 16))
              ],
            ),
            Text(
                "${getSize(file["size"])}  •  ${DateFormat("dd-MM-yy").format(file["time"].toDate())}",
                style: TextStyle(color: Colors.white70, fontSize: 14))
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.1)),
      ),
    );
  }
}

class TabTitle extends StatelessWidget {
  final String heading;
  TabTitle(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        heading,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
