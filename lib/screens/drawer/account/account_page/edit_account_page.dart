import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/config/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditAccount extends StatefulWidget {
  EditAccount(this.accountData);

  final accountData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditAccount(accountData);
  }
}

class _EditAccount extends State {
  _EditAccount(this.accountData);

  var accountData;
  final urlSingUp = "${Config.API_URL}/User/update";
  final snackBarEdit = SnackBar(content: Text("กำลังบันทึกการแก้ไข..."));
  final snackBarEditSuccess = SnackBar(content: Text("แก้ไขสำเร็จ"));
  final snackBarEditFall = SnackBar(content: Text("แก้ไขผิดพลาด"));

  String name;
  String surname;
  String email;
  String phone_number;
  String image;
  File imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = accountData.name;
    surname = accountData.surname;
    email = accountData.email;
    phone_number = accountData.phone_number;
    image = accountData.image;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Market ID : ${accountData.id}"),
        backgroundColor: Colors.orange[600],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _showAlertSelectImage(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: Container(
                        child: image == 'null'
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : Image.memory(
                                base64Decode(image),
                                fit: BoxFit.fill,
                              ),
                        color: Colors.blueGrey,
                        height: 220,
                        width: 220,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    maxLength: 32,
                    decoration: InputDecoration(
                        hintText: " ชื่อผู้ใช้ : ${accountData.name}"),
                    onChanged: (text) {
                      setState(() {
                        name = text;
                      });
                    },
                  ),
                  TextField(
                    maxLength: 32,
                    decoration: InputDecoration(
                        hintText: " นามสกุล : ${accountData.surname}"),
                    onChanged: (text) {
                      setState(() {
                        surname = text;
                      });
                    },
                  ),
                  TextField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText:
                            " เบอร์โทรติดต่อ : ${accountData.phone_number}"),
                    onChanged: (text) {
                      setState(() {
                        phone_number = text;
                      });
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print("save edit");
                  editMarketData();
                },
                child: Text('บันทึก'),
                style: ElevatedButton.styleFrom(primary: Colors.orange[600])),
          ],
        ),
      ),
    );
  }

  void _showAlertSelectImage(BuildContext context) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Choice'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('Gallery'), onTap: _onGallery)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('Camera'), onTap: _onCamera)),
                ],
              ),
            ),
          );
        });
  }

  _onGallery() async {
    print('Select Gallery');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      image = base64Encode(imageFile.readAsBytesSync());
      Navigator.of(context).pop();
      return image;
    } else {
      return null;
    }
  }

  _onCamera() async {
    print('Select Camera');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1920, maxWidth: 1080);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      image = base64Encode(imageFile.readAsBytesSync());
      Navigator.of(context).pop();
      return image;
    } else {
      return null;
    }
  }

  void editMarketData() {
    print("account ID : ${accountData.id.toString()}");
    print("ชื่อ : ${name.toString()}");
    print("นามสกุล : ${surname.toString()}");
    print("อีเมล : ${email.toString()}");
    print("เบอร์โทร : ${phone_number.toString()}");
    saveToDB();
  }

  void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarEdit);
    Map params = Map();
    params['id'] = accountData.id.toString();
    params['password'] = accountData.password.toString();
    params['name'] = name.toString();
    params['surname'] = surname.toString();
    params['email'] = email.toString();
    params['phone_number'] = phone_number.toString();
    params['image'] = image.toString();

    http.post(urlSingUp, body: params).then((res) {
      print(res.body);
      Map resBody = jsonDecode(res.body) as Map;
      var _resStatus = resBody['status'];
      print("Sing Up Status : ${_resStatus}");

      setState(() {
        if (_resStatus == 1) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarEditSuccess);
        } else if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarEditFall);
          //_snackBarKey.currentState.showSnackBar(singUpFail);
        }
      });
    });
  }
}
