import 'package:intl/intl.dart';

class FormatChanger {
  double koordinat(String input) {
    var f = NumberFormat("###.########", "en_US");
    return double.parse(f.format(double.parse(input)));
  }

  String jam(String input) {
    var f = new DateFormat('HH:mm');
    return f.format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(input.toString()));
  }

  String tanggalAPI(DateTime input) {
    var f = new DateFormat('yyyy-MM-dd');
    return f.format(DateFormat('yyyy-MM-dd').parse(input.toString()));
  }

  String tanggalAPIString(String input) {
    var f = new DateFormat('yyyy-MM-dd');
    return f.format(DateFormat('dd-MM-yyyy').parse(input)).toString();
  }

  String tanggalIndo(DateTime input) {
    var f = new DateFormat('dd-MM-yyyy');
    return f.format(DateFormat('yyyy-MM-dd').parse(input.toString()));
  }

  String tanggalJam(DateTime input) {
    var f = new DateFormat('dd-MM-yyyy HH:mm');
    return f.format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(input.toString()));
  }
}
