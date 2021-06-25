import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

import 'edit_account_page.dart';

class AccountDataPage extends StatefulWidget {
  AccountDataPage(this.accountID);

  final accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountDataPage(accountID);
  }
}

class _AccountDataPage extends State {
  _AccountDataPage(this.accountID);

  final accountID;
  final String urlSendAccountById = "${Config.API_URL}/User/list/id";
  AccountData _accountData;

  @override
  Widget build(BuildContext context) {
    print("Market ID : ${accountID.toString()}");
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[600],
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditAccount(_accountData)));
          },
        ),
        body: FutureBuilder(
          future: sendDataMarketByUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              print('snapshotData : ${snapshot.data}');
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(120),
                        child: Container(
                          child: snapshot.data.image == 'null'
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.blueGrey,
                                )
                              : Image.memory(
                                  base64Decode(snapshot.data.image),
                                  fit: BoxFit.fill,
                                ),
                          color: Colors.white,
                          height: 220,
                          width: 220,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Account ID : ${snapshot.data.id}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ชื่อผู้ใช้ : ${snapshot.data.name} ${snapshot.data.surname}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "อีเมล : ${snapshot.data.email}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "เบอร์ติดต่อ : ${snapshot.data.phone_number}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }

  Future<AccountData> sendDataMarketByUser() async {
    Map params = Map();
    params['id'] = accountID.toString();
    await http.post(urlSendAccountById, body: params).then((res) {
      print("Send Market Data...");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _dataAccount = _jsonRes['data'];
      print("data Market : ${_dataAccount.toString()}");

      _accountData = AccountData(
          _dataAccount['id'],
          _dataAccount['password'],
          _dataAccount['name'],
          _dataAccount['surname'],
          _dataAccount['email'],
          _dataAccount['phone_number'],
          _dataAccount['dateRegister'],
          _dataAccount['image']);
      print("market data : ${_accountData}");
    });
    return _accountData;
  }
}

class AccountData {
  final int id;
  final String password;
  final String name;
  final String surname;
  final String email;
  final String phone_number;
  final String dateRegister;
  final String image;

  AccountData(this.id, this.password, this.name, this.surname, this.email,
      this.phone_number, this.dateRegister, this.image);
}
