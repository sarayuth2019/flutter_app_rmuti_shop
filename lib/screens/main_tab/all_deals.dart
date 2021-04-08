import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllDealsPage extends StatefulWidget {
  AllDealsPage(this.accountID);
  final int accountID;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AllDealsPage(accountID);
  }
}

class _AllDealsPage extends State {
  _AllDealsPage(this.accountID);
  final int accountID;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "All Deals ${accountID}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [Text("Deals 1"), Text("Deals 2")],
      ),
    );
  }
}
