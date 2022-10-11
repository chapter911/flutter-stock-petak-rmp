import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class APIStockPetak {
  String licin;
  String jambul;
  String total;
  String keluar;

  APIStockPetak({this.licin, this.jambul, this.total, this.keluar});

  factory APIStockPetak.hasilData(Map<String, dynamic> object) {
    return APIStockPetak(
        licin: object['licin'],
        jambul: object['jambul'],
        total: object['total'],
        keluar: object['keluar']);
  }

  static Future<List<APIStockPetak>> getData(String tanggal, String userid,
      String serialdevice, BuildContext context) async {
    String apiURL = "http://222.124.139.234/StockKelapaSambu/StockPetak/get/" +
        tanggal +
        "/" +
        userid +
        "/" +
        serialdevice;

    BaseOptions options = new BaseOptions(
      baseUrl: apiURL,
      connectTimeout: 60000,
      receiveTimeout: 30000,
    );

    Dio dio = new Dio(options);

    Response response = await dio.get(apiURL);

    try {
      if (response.statusCode == 200) {
        dynamic listData = response.data;

        List<APIStockPetak> data = [];
        for (int i = 0; i < listData.length; i++) {
          data.add(APIStockPetak.hasilData(listData[i]));
        }
        return data;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Koneksi Bermasalah")));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Tidak Dapat Mengurai Data")));
      return null;
    }
  }
}
