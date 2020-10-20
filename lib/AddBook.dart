import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Globals.dart';
import 'package:flutter_app/sidemenu.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multi_media_picker/multi_media_picker.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  File img = new File('path');
  TextEditingController title = new TextEditingController();
  TextEditingController author = new TextEditingController();
  TextEditingController desc = new TextEditingController();
  TextEditingController page = new TextEditingController();
  TextEditingController url = new TextEditingController();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _drawerKey,
      drawer: SideMenu(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        title: Center(child: Text('Create Book')),
        actions: [Icon(Icons.more_vert)],
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
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 320,
                  child: TextField(
                    controller: title,
                    // decoration: InputDecoration(labelText: 'title'),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(90.0)),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 320,
                  child: TextField(
                    controller: author,
                    decoration: InputDecoration(
                      hintText: 'Author',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(90.0)),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 320,
                  child: TextField(
                    controller: desc,
                    decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 320,
                  child: TextField(
                    // controller: ,
                    readOnly: true,
                    onTap: () {
                      MultiMediaPicker.pickImages(source: ImageSource.gallery)
                          .then((value) async {
                        img = value[0];
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Image',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 320,
                  child: TextField(
                    controller: page,
                    decoration: InputDecoration(
                        hintText: 'Page',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 320,
                  child: TextField(
                    controller: url,
                    decoration: InputDecoration(
                        hintText: 'URL',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                SizedBox(height: 40),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.fromLTRB(120, 20, 120, 20),
                  color: Hexcolor("#043e2a"),
                  child: Text(
                    'Add Book',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    getPdfAndUpload();
                  },
                ),
              ],
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    File file;
    await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf']).then((value) {
      file = File(value.files.single.path);
    });
    String fileName = '${randomName}.pdf';
    print(fileName);
    print('${file.readAsBytesSync()}');
    savePdf(file.readAsBytesSync(), fileName);
  }

  Future savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    documentFileUpload(url);
    return url;
  }

  Future<void> documentFileUpload(String str) async {
    await (await FirebaseStorage.instance
            .ref()
            .child('${Globals.currentuser.uid} ${DateTime.now()}')
            .putFile(img)
            .onComplete)
        .ref
        .getDownloadURL()
        .then((val) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(Globals.currentuser.uid)
          .update({
        'title': title.text,
        'description': desc.text,
        'page': page,
        'url': url,
        'author': author.text,
        'image': val.toString(),
      }).then((value) {
        Navigator.pop(context);
      });
    });
  }
}
