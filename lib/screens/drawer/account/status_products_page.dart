import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusProductsPage extends StatefulWidget {
  StatusProductsPage(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StatusProductsPage(accountID);
  }
}

class _StatusProductsPage extends State {
  _StatusProductsPage(this.accountID);

  final int accountID;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}
