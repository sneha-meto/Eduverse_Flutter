import 'package:eduverse/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eduverse/Utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:eduverse/Pages/media_view.dart';

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
              Flexible(
                child: Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
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
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MediaView(
                                      imgUrl: snapshot.data["images"][i]
                                          ["text"],
                                      user: snapshot.data["images"][i]
                                              ["sent_by"] ??
                                          "User Name",
                                      sentAt: snapshot.data["images"][i]["time"]
                                          .toDate(),
                                      fileName: snapshot.data["images"][i]
                                          ["name"],
                                    )),
                          );
                        },
                        child: Container(
                            child: Image.network(
                          snapshot.data["images"][i]["text"],
                          fit: BoxFit.cover,
                        )));
                  })
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MediaTile extends StatefulWidget {
  MediaTile({this.file});
  final file;

  @override
  _MediaTileState createState() => _MediaTileState();
}

class _MediaTileState extends State<MediaTile> {
  bool downloading = false;
  String progressString = "";
  double downloadProgress = 0;
  final snackBar = SnackBar(
    content: Text(
      "Download Completed",
      textAlign: TextAlign.center,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    margin: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
    behavior: SnackBarBehavior.floating,
    backgroundColor: kPurple,
  );

  Future<void> downloadFile(fileUrl, fileName) async {
    Dio dio = Dio();
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
//        var dir = await getExternalStorageDirectory();

        await dio.download(fileUrl, "/storage/emulated/0/Download/" + fileName,
            onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            downloadProgress = (rec / total);
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        progressString = "Completed";
      });
      print("Download completed");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print("Permission Denied");
    }
  }

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
                Text(widget.file["name"],
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Row(
                  children: [
                    Text(widget.file["extension"].toString().toUpperCase(),
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(width: 10),
                    InkWell(
                      child: Icon(Icons.file_download, color: Colors.white),
                      onTap: () {
                        downloadFile(widget.file["text"], widget.file["name"]);
                      },
                    ),
                  ],
                )
              ],
            ),
            Text(
                "${getSize(widget.file["size"])}  •  ${DateFormat("dd-MM-yy").format(widget.file["time"].toDate())}",
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 8),
            LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kCyan),
                backgroundColor: Colors.white70,
                value: downloadProgress),
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
