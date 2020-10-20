import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/book.dart';
import 'package:flutter_app/detail.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_app/register.dart';
import 'package:hexcolor/hexcolor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashPage(),
    initialRoute: BookPage.route,
    routes: {
      BookPage.route : (context) => BookPage(),
      LoginPage.route : (context) => LoginPage(),
      RegisterPage.route : (context) => RegisterPage(),
      //Note: I also want to do the same thing above below but it is requires a parameter so I don't know how to do it.
      //'/bookdetails' : (context) => DetailsPage()
    },
    theme: ThemeData(accentColor: Colors.green),

  ));
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      // Navigator.pushNamed(this.context, '/login');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Hexcolor('#6BBC9A')])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              width: 160,
              height: 160,
            ),
            SizedBox(height: 15),
            Text(
              'Loading...',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
