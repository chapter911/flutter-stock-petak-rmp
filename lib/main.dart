import 'package:flutter/material.dart';
import 'package:stock_petak_rmp/LoginPage.dart';
import 'dart:io';
import 'package:stock_petak_rmp/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue[900]),
      // home: SplashScreen(),
      home: Platform.isAndroid ? SplashScreen() : LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
