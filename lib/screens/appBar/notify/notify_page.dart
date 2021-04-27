import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/screens/appBar/cart/cart_page.dart';
import 'package:flutter_app_rmuti_shop/screens/drawer/account/account_page.dart';
import 'package:http/http.dart' as http;

class NotifyPage extends StatefulWidget {
  NotifyPage(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotifyPage(accountID);
  }
}

class _NotifyPage extends State {
  _NotifyPage(this.accountID);

  final int accountID;
  final urlListNotifyByUser =
      "https://testheroku11111.herokuapp.com/Backup/list/user";
  final urlDeleteNotify =
      "https://testheroku11111.herokuapp.com/Notify/delete/user";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deleteNotify();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("NotifyPage ID ${accountID.toString()}"),
      ),
      body: FutureBuilder(
        future: _listNotify(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (snapshot.data[index].status ==
                          "จัดเตรียมรายการสินค้าของท่าน สำเร็จ") {
                        Navigator.push(
                            context,
                            (MaterialPageRoute(
                                builder: (context) => CartPage(accountID, 1))));
                      }
                      if (snapshot.data[index].status ==
                          "มีคนสั่งรายการสินค้าของท่าน") {
                        Navigator.push(
                            context,
                            (MaterialPageRoute(
                                builder: (context) => AccountPage(accountID))));
                      }
                    },
                    child: Card(
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
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          : Container()),
                                  Container(
                                      child: snapshot.data[index].status ==
                                              "มีคนสั่งรายการสินค้าของท่าน"
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
                                                      color: Colors
                                                          .yellowAccent[700],
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
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Future<List<_NotifyData>> _listNotify() async {
    Map params = Map();
    List<_NotifyData> listNotifyByUser = [];
    params['user'] = accountID.toString();
    print("List notify By user...");
    await http.post(urlListNotifyByUser, body: params).then((res) {
      print("List notify By user success !");
      var _jsonDataNotify = jsonDecode(utf8.decode(res.bodyBytes));
      var _dataNotify = _jsonDataNotify['data'];
      for (var i in _dataNotify) {
        _NotifyData _notifyData = _NotifyData(
            i['id'],
            i['name'],
            i['number'],
            i['price'],
            i['status'],
            i['user'],
            i['item'],
            i['date'],
            i['image']);
        listNotifyByUser.insert(0, _notifyData);
      }
    });
    print("notify length : ${listNotifyByUser.length}");
    return listNotifyByUser;
  }
  void deleteNotify() async {
    Map params = Map();
    params['user'] = accountID.toString();
    print("delete notify...");
    http.post(urlDeleteNotify,body: params).then((res) {
      print(res.body);
      print("delete notify success !");
    });
  }
}

class _NotifyData {
  final int id;
  final String name;
  final int number;
  final int price;
  final String status;
  final int user;
  final int item_id;
  final String date;
  final String image;

  _NotifyData(this.id, this.name, this.number, this.price, this.status,
      this.user, this.item_id, this.date, this.image);
}
