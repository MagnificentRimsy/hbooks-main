import 'package:flutter/material.dart';
import 'package:flutter_app/login.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConfirmPage()
      )
    );
}

class ConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        appBar: AppBar(
          title: Text('Confirmation Page'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 70.0,
            ),
            Text(
              'Thank you for your contribution',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Dancing',
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: Colors.green,
            )
          ],
        )),
      ),
    );
  }
}
