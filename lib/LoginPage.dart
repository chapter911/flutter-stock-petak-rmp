import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:stock_petak_rmp/API/APICheckUser.dart';
import 'package:stock_petak_rmp/BlockedPage.dart';
import 'package:stock_petak_rmp/MainPage.dart';
import 'package:stock_petak_rmp/Model/DataSharedPreferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

/*
OL                                                   1009054              29191f1c5d06ab18
*/

class _LoginPageState extends State<LoginPage> {
  var _username = "", _password = "";

  @override
  void initState() {
    super.initState();
    _getWindowSize();
    Future.delayed(Duration(seconds: 2), () {
      FlutterClipboard.paste().then((value) {
        if (value.length == 90) {
          try {
            setState(() {
              _username = value.substring(30, 60).replaceAll(" ", "");
              _password = value.substring(60, 90).replaceAll(" ", "");
            });
            FlutterClipboard.copy(" ");
            verifikasiUser();
          } catch (e) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlockedPage();
            }));
          }
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlockedPage();
          }));
        }
      });
    });
  }

  Future _getWindowSize() async {
    try {
      var size = await DesktopWindow.getWindowSize();
      print(size.width.toString() + " - " + size.height.toString());
      await DesktopWindow.setMinWindowSize(
          Size((size.width * 0.4), (size.height)));
      await DesktopWindow.setMaxWindowSize(
          Size((size.width * 0.4), (size.height * 3)));
      await DesktopWindow.setFullScreen(false);
    } catch (e) {
      print("Window Has Resized");
    }
  }

  void verifikasiUser() {
    try {
      APICheckUser.checkUser(_username, _password, context).then((value) {
        if (value[0].lanjut == "0") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlockedPage();
          }));
        } else {
          if (value[0].windowsaccess == "0") {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BlockedPage();
            }));
          } else {
            DataSharedPreferences().saveString("userid", value[0].userid);
            DataSharedPreferences()
                .saveString("serialdevice", value[0].serialdevice);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MainPage();
            }));
          }
        }
      });
    } catch (e) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlockedPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
                    fontSize: 30,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              CircularProgressIndicator(
                color: Colors.blue[900],
              )
            ],
          ),
        ),
      ),
    );
  }
}
