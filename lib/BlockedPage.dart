import 'package:flutter/material.dart';

class BlockedPage extends StatefulWidget {
  @override
  _BlockedPageState createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.blue[900],
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.vpn_key,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "AKSES DI TOLAK",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'quadrat', fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
