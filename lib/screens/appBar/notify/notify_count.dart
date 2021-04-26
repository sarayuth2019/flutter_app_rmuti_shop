import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;


class NotifyCount extends StatefulWidget {
  NotifyCount(this.accountID);
  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotifyCount(accountID);
  }
}

class _NotifyCount extends State {
  _NotifyCount(this.accountID);
  final int accountID;
  final urlNotifyByUser =
      "https://testheroku11111.herokuapp.com/Notify/list/user";
  int _notifyCount = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: streamNotifyCount(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          return Container(
            height: 17,
            width: 17,
            child: Center(child: Text("...")),
          );
        } else if (_notifyCount == 0) {
          return Container(
            height: 17,
            width: 17,
          );
        } else {
          return Container(
              height: 17,
              width: 17,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(
                  "${_notifyCount.toString()}",
                  style: TextStyle(color: Colors.white),
                ),
              ));
        }
      },
    );
  }

  Stream <void> streamNotifyCount()async* {
    Map params = Map();
    params['user'] = accountID.toString();
    var res = await http.post(urlNotifyByUser, body: params);
    Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var notifyData = jsonData['data'];
    if (notifyData != null) {
      setState(() {
        _notifyCount = notifyData.length;
      });
    } else {
      print("Count Cart fall !");
    }
    yield _notifyCount;
  }

}
