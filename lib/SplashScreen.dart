import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_petak_rmp/LoginPage.dart';
import 'package:stock_petak_rmp/LoginScan.dart';
import 'package:stock_petak_rmp/MainPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<bool> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("userid")) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MainPage();
      }));
      return true;
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Platform.isAndroid ? LoginScan() : LoginPage();
        }));
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage("assets/icon/stockkelapa.png"),
              height: 200,
              width: 200,
            ),
            Text(
              "STOCK PETAK RMP",
              style: TextStyle(
                  fontFamily: 'quadrat',
                  fontSize: 25,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold),
            ),
            CupertinoActivityIndicator()
          ],
        ),
      ),
    );
  }
}
