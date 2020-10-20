import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/book.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailsPage extends StatefulWidget {
  final Book book;

  DetailsPage({Key key, @required this.book}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState(book);
}

class _DetailsPageState extends State<DetailsPage> {
  bool _isLoading = false;
  final Book book;
  bool downloading = false;
  var progressString = "";
  _DetailsPageState(this.book);

// Download start

  @override
  void initState() {
    super.initState();
  }

  //get storage permission
  // void getPermission() async {
  //   print("getPermission");
  //   await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  // }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      //getExternalStorageDirectory(); 
      
      

      //Response response = 
      await dio
          .download(book.url, "${dir.path}/${book.title}.pdf",
              onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });

      //write in download folder
      // File file = File(dir.path);
      // var raf = file.openSync(mode: FileMode.write);
      // raf.writeFromSync(response.data);
      // await raf.close();
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  // Download end
  @override
  Widget build(BuildContext context) {
    //book Image
    final topLeft = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Hero(
            tag: Text(book.title),
            child: Material(
              elevation: 15.0,
              shadowColor: Colors.green.shade900,
              child: Image(
                image: NetworkImage(book.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          '${book.page}',
          style: TextStyle(
            color: Colors.black38,
            fontSize: 12,
          ),
        )
      ],
    );

    //book details right
    final topRight =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(book.title,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12.toDouble(),
            )),
      ),
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Author: ${book.author}',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            )),
      ),
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text('Comment: ${book.comment}',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            )),
      ),
      SizedBox(height: 32.0),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.blue.shade200,
          elevation: 5.0,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : MaterialButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    await PDFDocument.fromURL("${book.url}").then((val) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: PDFViewer(
                                document: val,
                                enableSwipeNavigation: true,
                                lazyLoad: false,
                              ),
                            );
                          });
                    });
                    setState(() => _isLoading = false);
                  },
                  minWidth: 70.0,
                  color: Colors.blue,
                  child: Text(
                    'Read Now',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
        ),
        downloading
            ? Center(child: CircularProgressIndicator())
            : Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.green.shade200,
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    downloadFile();
                  },
                  minWidth: 70.0,
                  color: Colors.green,
                  child: Text(
                    'Download',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
      ]),
    ]);

    //top image and text combined
    final topContent = Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 2, child: topLeft),
          Flexible(flex: 3, child: topRight),
        ],
      ),
    );
    Divider();
    //bottom description
    final bottomContent = Container(
      height: 220.0,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20.0, bottom: 16.0),
        child: Text(
          book.description,
          style: TextStyle(fontSize: 13.0, height: 1.5),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        title: Text('Book Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Hexcolor("#8DCCB1"),
                Hexcolor("#043e2a"),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          topContent,
          bottomContent,
          downloading
              ? Container(
                  height: 80.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Downloading File: $progressString",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
