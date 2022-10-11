import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class APICheckUser {
  String userid, serialdevice, windowsaccess, status, lanjut;

  APICheckUser(
      {this.userid,
      this.serialdevice,
      this.windowsaccess,
      this.status,
      this.lanjut});

  factory APICheckUser.hasilData(Map<String, dynamic> object) {
    return APICheckUser(
      userid: object['UserID'],
      serialdevice: object['SerialDevice'],
      windowsaccess: object['WindowsAccess'],
      status: object['status'],
      lanjut: object['lanjut'],
    );
  }

  static Future<List<APICheckUser>> checkUser(
      String userid, String serialdevice, BuildContext context) async {
    Response response;
    String apiURL =
        "http://192.168.0.4/StockKelapaSambu/StockPetak/CheckActivated/" +
            userid +
            "/" +
            serialdevice;

    try {
      BaseOptions options = new BaseOptions(
        baseUrl: apiURL,
        connectTimeout: 60000,
        receiveTimeout: 30000,
      );

      Dio dio = new Dio(options);

      response = await dio.get(apiURL);

      if (response.statusCode == 200) {
        dynamic listData = response.data;

        List<APICheckUser> dataKelapas = [];
        for (int i = 0; i < listData.length; i++) {
          dataKelapas.add(APICheckUser.hasilData(listData[i]));
        }
        return dataKelapas;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Koneksi Bermasalah")));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal Mendapat Data")));
      return null;
    }
  }
}
