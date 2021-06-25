import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  HistoryPage(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HistoryPage(accountID);
  }
}

class _HistoryPage extends State {
  _HistoryPage(this.accountID);

  final int accountID;
  final urlListHistoryByUser = "${Config.API_URL}/Backup/list/user";
  final statusProducts = 'ส่งมอบสินค้า สำเร็จ';
  List listHistory = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(backgroundColor: Colors.blueGrey,
      body: FutureBuilder(
        future: _listHistory(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${snapshot.data[index].name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text("ราคา : ${snapshot.data[index].price} บาท"),
                            Text(
                                "จำนวน : ${snapshot.data[index].number} ชิ้น"),
                            Column(
                              children: [
                                Container(
                                    child: snapshot.data[index].status ==
                                        "จัดเตรียมสินค้า สำเร็จ"
                                        ? Row(
                                      children: [
                                        Text(
                                          "สถานะสินค้า : ",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data[index].status,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    )
                                        : Container()),
                                Container(
                                    child: snapshot.data[index].status ==
                                        "ส่งมอบสินค้า สำเร็จ"
                                        ? Row(
                                      children: [
                                        Text(
                                          "สถานะสินค้า : ",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data[index].status,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    )
                                        : Container()),
                                Container(
                                    child: snapshot.data[index].status ==
                                        "สินค้าหมด"
                                        ? Row(
                                      children: [
                                        Text(
                                          "สถานะสินค้า : ",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        Text(
                                          snapshot.data[index].status,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ],
                                    )
                                        : Container()),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text("${snapshot.data[index].date}"),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Future<List<_HistoryData>> _listHistory() async {
    Map params = Map();
    List<_HistoryData> listHistoryByUser = [];
    params['user'] = accountID.toString();
    print("List History By user...");
    await http.post(urlListHistoryByUser, body: params).then((res) {
      print("List History By user success !");
      var _jsonDataNotify = jsonDecode(utf8.decode(res.bodyBytes));
      var _dataNotify = _jsonDataNotify['data'];
      for (var i in _dataNotify) {
        _HistoryData _notifyData = _HistoryData(
            i['id'],
            i['name'],
            i['number'],
            i['price'],
            i['status'],
            i['user'],
            i['item'],
            i['date'],
            i['image']);
        listHistoryByUser.insert(0, _notifyData);
      }
    });
    print("History length : ${listHistoryByUser.length}");

    listHistory = listHistoryByUser
        .where((element) =>
        element.status.toLowerCase().contains(statusProducts.toLowerCase()))
        .toList();
    print("History Status Success length  : ${listHistory.length}");
    print("History  : ${listHistory.toList()}");

    return listHistory;
  }
}

class _HistoryData {
  final int id;
  final String name;
  final int number;
  final int price;
  final String status;
  final int user;
  final int item_id;
  final String date;
  final String image;

  _HistoryData(this.id, this.name, this.number, this.price, this.status,
      this.user, this.item_id, this.date, this.image);
}
