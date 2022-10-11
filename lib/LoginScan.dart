import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'dart:developer';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:stock_petak_rmp/API/APIRegistrasi.dart';
import 'package:stock_petak_rmp/MainPage.dart';
import 'package:stock_petak_rmp/Model/DataSharedPreferences.dart';
import 'package:stock_petak_rmp/Style/Notifikasi.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginScan extends StatefulWidget {
  @override
  _LoginScanState createState() => _LoginScanState();
}

class _LoginScanState extends State<LoginScan> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flash = false, resume = false;
  String userid = "",
      nama = "-",
      nik = "-",
      departemen = "-",
      jabatan = "-",
      _useruserid = "-";
  RoundedLoadingButtonController _verifikasi =
      new RoundedLoadingButtonController();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // ignore: unused_field
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String merek = "",
      model = "",
      appserial = "",
      macaddress = "",
      apiversion = "",
      androidversion = "",
      appversion = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        merek = deviceData['brand'];
        model = deviceData['model'];
        appserial = deviceData['androidId'];
        apiversion = deviceData['version.sdkInt'].toString();
        androidversion = deviceData['version.release'];
        getAppVersion();
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        merek = "IPhone";
        model = deviceData['model'];
        appserial = deviceData['identifierForVendor'];
        apiversion = deviceData['systemVersion'];
        androidversion = deviceData['systemVersion'];
        getAppVersion();
      } else if (Platform.isMacOS) {
        deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        merek = "MAC";
        model = deviceData['model'];
        appserial = deviceData['MAC-OS'];
        apiversion = deviceData['osRelease'];
        androidversion = "NON";
        getAppVersion();
      } else if (Platform.isWindows) {
        deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        merek = "Windows";
        model = deviceData['windows'];
        appserial = deviceData['computerName'];
        apiversion = "NO-API";
        appversion = "1.0.0+1";
        androidversion = "NON";
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appversion = packageInfo.version;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  // Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'version': data.version,
  //     'id': data.id,
  //     'idLike': data.idLike,
  //     'versionCodename': data.versionCodename,
  //     'versionId': data.versionId,
  //     'prettyName': data.prettyName,
  //     'buildId': data.buildId,
  //     'variant': data.variant,
  //     'variantId': data.variantId,
  //     'machineId': data.machineId,
  //   };
  // }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verifikasi - Scan Barcode",
          style: TextStyle(fontFamily: 'quadrat'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: InkWell(
              // child: Container(
              //   color: Colors.black,
              // ),
              child: _buildQrView(context),
              onTap: resume
                  ? () async {
                      await controller?.resumeCamera();
                      setState(() {
                        userid = "";
                        resume = !resume;
                      });
                    }
                  : () async {
                      await controller?.pauseCamera();
                      setState(() {
                        userid = "";
                        resume = !resume;
                      });
                    },
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.3),
                          1: FractionColumnWidth(0.05),
                          2: FractionColumnWidth(0.65),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text("Nama"),
                              Text(":"),
                              Text(
                                nama,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text("NIK"),
                              Text(":"),
                              Text(
                                nik,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text("Departemen"),
                              Text(":"),
                              Text(
                                departemen,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text("Jabatan"),
                              Text(":"),
                              Text(
                                jabatan,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: RoundedLoadingButton(
                          onPressed: () {
                            verifikasiPerangkat();
                          },
                          controller: _verifikasi,
                          child: Text("VERIFIKASI"),
                          color: Colors.blue[900],
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (userid != result.code) {
        Notifikasi().show(context, "Mengambil Data");
        userid = result.code;
        getKaryawan(userid);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  void getKaryawan(String userid) {
    APIRegistrasi.getTenagaKerja(userid, context).then((value) {
      setState(() {
        nama = value[0].nama;
        nik = value[0].nik;
        departemen = value[0].bagian;
        jabatan = value[0].jabatan;
        _useruserid = value[0].userid;
      });
    });
  }

  void verifikasiPerangkat() {
    setState(() {
      _verifikasi.success();
      _verifikasi.stop();
    });
    APIRegistrasi.verifikasiPerangkat(_useruserid, appserial, merek, model,
            apiversion, androidversion, appversion, context)
        .then((value) {
      Notifikasi().show(context, value[0].status);
      if (value[0].lanjut == "1") {
        DataSharedPreferences().saveString("userid", _useruserid);
        DataSharedPreferences().saveString("serialdevice", appserial);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MainPage();
        }));
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
