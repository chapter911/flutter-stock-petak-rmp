import 'package:flutter/material.dart';

class Notifikasi {
  void show(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
