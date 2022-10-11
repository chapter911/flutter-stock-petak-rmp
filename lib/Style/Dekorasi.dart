import 'package:flutter/material.dart';

class Dekorasi {
  InputDecoration dekorasiInput(Icon icon, String string, double radius) {
    return new InputDecoration(
      prefixIcon: icon,
      labelText: string,
      prefixStyle:
          TextStyle(color: Color(0xFF000080), fontWeight: FontWeight.w600),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: (Colors.blue[900])),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  BoxDecoration containerDecoration(Color colors1, Color colors2) {
    return new BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      gradient: new LinearGradient(
          colors: [
            colors1,
            colors2,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.mirror),
    );
  }

  BoxDecoration containerBorder() {
    return new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: (Colors.blue[900]), width: 2));
  }
}
