import 'package:eduverse/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class MediaView extends StatefulWidget {
  MediaView(
      {@required this.imgUrl,
      @required this.user,
      @required this.sentAt,
      @required this.fileName});
  final String imgUrl;
  final String user;
  final DateTime sentAt;
  final String fileName;

  @override
  _MediaViewState createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user,
              style: TextStyle(fontSize: 22),
            ),
            Text(
              '${DateFormat("dd-MM-yy").format(widget.sentAt)},  ${DateFormat("h:mm a").format(widget.sentAt)}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white.withOpacity(0.1),
        titleSpacing: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: InteractiveViewer(
                panEnabled: false,
                minScale: 1,
                maxScale: 2.5,
                child: Image.network(widget.imgUrl),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kCyan),
                            backgroundColor: Colors.white70,
                            value: downloadProgress),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.fileName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              softWrap: true,
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              downloadFile(widget.imgUrl, widget.fileName);
                            },
                            child: Icon(
                              Icons.file_download,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
