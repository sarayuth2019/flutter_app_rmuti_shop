import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/Config/config.dart';
import 'package:flutter_app_rmuti_shop/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'sing_up_page.dart';

class SingIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SingIn();
  }
}

class _SingIn extends State {
  final snackBarKey = GlobalKey<ScaffoldState>();
  final snackBarOnSingIn =
      SnackBar(content: Text("กำลังเข้าสู้ระบบ กรุณารอซักครู่..."));
  final snackBarSingInFail =
      SnackBar(content: Text("กรุณาตรวจสอบ Email หรือ Password"));
  final urlSingIn = "${Config.API_URL}/User/Login";

  int accountID;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: snackBarKey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("Sing IN"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.orange[600],
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.location_searching,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "RMUTI Shop",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Card(
                child: ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: TextField(
                controller: email,
                decoration: InputDecoration(
                    hintText: "Email", border: InputBorder.none),
              ),
            )),
            Card(
                child: ListTile(
              leading: Icon(Icons.vpn_key_outlined),
              title: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password", border: InputBorder.none),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.orange[600],
                onPressed: onSingIn,
                child: Text(
                  "Sing In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(
              "Don't have account ?",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.grey,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SingUp()));
                },
                child: Text(
                  "Sing Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSingIn() {
    snackBarKey.currentState.showSnackBar(snackBarOnSingIn);
    Map params = Map();
    params['email'] = email.text;
    params['password'] = password.text;
    http.post(urlSingIn, body: params).then((res) {
      Map resData = jsonDecode(res.body) as Map;
      var _resStatus = resData['status'];
      var _accountData = resData['data'];
      setState(() {
        if (_resStatus == 1) {
          accountID = _accountData['id'];
          print("Account ID : ${accountID}");
          saveUserIDToDevice();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
        } else if (_resStatus == 0) {
          snackBarKey.currentState.showSnackBar(snackBarSingInFail);
        }
      });
    });
  }

  Future saveUserIDToDevice ()async{
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    _accountID.setInt('accountID', accountID);
    print("save accountID to device : aid ${_accountID.toString()}");
  }

}
