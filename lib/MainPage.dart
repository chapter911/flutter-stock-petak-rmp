import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stock_petak_rmp/API/APIStockPetak.dart';
import 'package:stock_petak_rmp/Model/DataSharedPreferences.dart';
import 'package:stock_petak_rmp/Model/FormatChanger.dart';
import 'package:stock_petak_rmp/SplashScreen.dart';
import 'package:stock_petak_rmp/Style/Dekorasi.dart';
import 'package:stock_petak_rmp/Style/Notifikasi.dart';
import 'dart:io';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime tanggalSekarang = DateTime.now();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String tanggal;
  bool isToday = true, loading = false;
  String licin = "", jambul = "", total = "", userid = "", serialdevice;

  initState() {
    super.initState();
    tanggal = FormatChanger().tanggalJam(tanggalSekarang);
    getUser();
  }

  Future<void> getUser() async {
    DataSharedPreferences().readString("userid").then((value) {
      setState(() {
        userid = value;
      });
    });
    DataSharedPreferences().readString("serialdevice").then((value) {
      setState(() {
        serialdevice = value;
      });
      getData();
      jalankanTimer();
    });
  }

  Future<void> pilihTanggal(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: tanggalSekarang, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (picked != null) {
      if (FormatChanger().tanggalAPI(picked) ==
          FormatChanger().tanggalAPI(tanggalSekarang)) {
        tanggal = FormatChanger().tanggalJam(tanggalSekarang).toString();
        if (!isToday) {
          isToday = true;
          getData();
          jalankanTimer();
        } else {
          print("Timer Sudah Berjalan");
        }
      } else {
        tanggal = FormatChanger().tanggalIndo(picked);
        isToday = false;
        getData();
      }
    }
  }

  void jalankanTimer() {
    Timer.periodic(Duration(seconds: 60), (timer) {
      if (mounted) {
        if (isToday) {
          print("Timer Berjalan : " + DateTime.now().toString());
          getData();
        } else {
          print("Timer Berhenti : " + DateTime.now().toString());
          timer.cancel();
        }
      } else {
        print("Timer Dihentikan Tampilan Telah Diganti");
        timer.cancel();
      }
    });
  }

  void getData() {
    setState(() {
      _refreshController.refreshCompleted();
      loading = true;
    });
    var tanggalapi = FormatChanger().tanggalAPIString(tanggal);
    APIStockPetak.getData(tanggalapi, userid, serialdevice, context)
        .then((value) {
      if (value[0].keluar == "0") {
        licin = value[0].licin;
        jambul = value[0].jambul;
        total = value[0].total;
        loading = false;
        if (isToday) {
          tanggal = FormatChanger().tanggalJam(DateTime.now()).toString();
        }
        setState(() {});
      } else {
        DataSharedPreferences().clearData();
        Notifikasi().show(
            context, "Anda Tidak Di Perbolehkan Menggunakan Aplikasi Ini");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SplashScreen();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            "Stock Petak RMP",
            style: TextStyle(fontFamily: 'quadrat'),
          ),
          actions: Platform.isAndroid
              ? [
                  IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(
                            'Perhatian?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                              "Apakah Anda Ingin Keluar Dari Aplikasi Ini?"),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Batal")),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                DataSharedPreferences().clearData();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SplashScreen();
                                }));
                              },
                              child: Text("Ya"),
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ]
              : null,
          automaticallyImplyLeading: false),
      body: Container(
        margin: EdgeInsets.all(5),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () {
            getData();
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: Dekorasi()
                    .containerDecoration(Colors.blue[900], Colors.blue[700]),
                child: InkWell(
                  child: Text(
                    tanggal,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  onTap: () {
                    pilihTanggal(context);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: Dekorasi().containerDecoration(
                    Colors.purple[900], Colors.purple[700]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    loading
                        ? CupertinoActivityIndicator()
                        : Text(
                            "Total Stock Kelapa Petak :\n" + tanggal,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              total,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50),
                            ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Butir",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: Dekorasi()
                    .containerDecoration(Colors.blue[900], Colors.blue[700]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    loading
                        ? CupertinoActivityIndicator()
                        : Text(
                            "Total Kelapa Licin\nPetak 01",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              licin,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50),
                            ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Butir",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: Dekorasi()
                    .containerDecoration(Colors.blue[900], Colors.blue[700]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    loading
                        ? CupertinoActivityIndicator()
                        : Text(
                            "Total Kelapa Jambul\nPetak 02",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              jambul,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50),
                            ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Butir",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
