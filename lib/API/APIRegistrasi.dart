import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class APIRegistrasi {
  String userid, regno, nik, nama, bagian, jabatan, status, lanjut;

  APIRegistrasi(
      {this.userid,
      this.regno,
      this.nik,
      this.nama,
      this.bagian,
      this.jabatan,
      this.status,
      this.lanjut});

  factory APIRegistrasi.hasilTenagaKerja(Map<String, dynamic> object) {
    return APIRegistrasi(
        userid: object['UserID'],
        regno: object['RegNo'],
        nik: object['NIK'],
        nama: object['NAMA'],
        bagian: object['bagian'],
        jabatan: object['jabatan']);
  }

  factory APIRegistrasi.hasilVerifikasi(Map<String, dynamic> object) {
    return APIRegistrasi(status: object['status'], lanjut: object['lanjut']);
  }

  static Future<List<APIRegistrasi>> getTenagaKerja(
      String userid, BuildContext context) async {
    String apiURL =
        "http://222.124.139.234/StockKelapaSambu/StockPetak/getTenagaKerja/" +
            userid;

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

        List<APIRegistrasi> data = [];
        for (int i = 0; i < listData.length; i++) {
          data.add(APIRegistrasi.hasilTenagaKerja(listData[i]));
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

  static Future<List<APIRegistrasi>> verifikasiPerangkat(
      String userid,
      String serialdevice,
      String device,
      String model,
      String api,
      String androidversion,
      String appversion,
      BuildContext context) async {
    String apiURL =
        "http://222.124.139.234/StockKelapaSambu/StockPetak/verifikasiPerangkat";

    BaseOptions options = new BaseOptions(
      baseUrl: apiURL,
      connectTimeout: 60000,
      receiveTimeout: 30000,
    );

    Dio dio = new Dio(options);

    Response response = await dio.post(apiURL, data: {
      "UserID": userid,
      "SerialDevice": serialdevice,
      "Device": device,
      "Model": model,
      "API": api,
      "AndroidVersion": androidversion,
      "AppVersion": appversion
    });

    try {
      if (response.statusCode == 200) {
        dynamic listData = response.data;

        List<APIRegistrasi> data = [];
        for (int i = 0; i < listData.length; i++) {
          data.add(APIRegistrasi.hasilVerifikasi(listData[i]));
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
