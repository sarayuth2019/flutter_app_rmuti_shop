import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/screens/appBar/search/search_location_tab.dart';
import 'package:flutter_app_rmuti_shop/screens/appBar/search/search_nameProducts_tab.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  SearchPage(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPage(accountID);
  }
}

class _SearchPage extends State {
  _SearchPage(this.accountID);

  final int accountID;
  final urlListAllProducts = "https://testheroku11111.herokuapp.com/Item/list";

  List _listAllProducts = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      child: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            backgroundColor: Colors.orange[600],
            title: Text("Search"),
            bottom: TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        Text("Search Products"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        Text("Search Location"),
                      ],
                    ),
                  ),
                ]),
          ),
          body: FutureBuilder(
            future: _listProducts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return TabBarView(children: [
                  SearchNameProducts(accountID,_listAllProducts),
                  SearchLocation(accountID,_listAllProducts)
                ]);
              }
            },
          )),
      initialIndex: 0,
      length: 2,
    );
  }

  Future<List<_Products>> _listProducts() async {
    print("connect to Api...");
    var _getDataProDucts = await http.get(urlListAllProducts);
    print("connect to Api Success");
    var _jsonDataAllProducts =
        jsonDecode(utf8.decode(_getDataProDucts.bodyBytes));
    var _dataAllProducts = _jsonDataAllProducts['data'];

    List<_Products> listAllProducts = [];
    for (var i in _dataAllProducts) {
      _Products _products = _Products(
          i['id'],
          i['name'],
          i['group'],
          i['description'],
          i['price'],
          i['location'],
          i['user'],
          i['discount'],
          i['count_promotion'],
          i['status'],
          i['date'],
          i['image']);
      listAllProducts.add(_products);
    }
    print("Search All Products length : ${listAllProducts.length}");
    _listAllProducts = listAllProducts;
    return listAllProducts;
  }
}

class _Products {
  final int id;
  final String name;
  final int group;
  final String description;
  final int price;
  final String location;
  final int user_id;
  final int discount;
  final int count_promotion;
  final int status_promotion;
  final String date;
  final String image;

  _Products(
      this.id,
      this.name,
      this.group,
      this.description,
      this.price,
      this.location,
      this.user_id,
      this.discount,
      this.count_promotion,
      this.status_promotion,
      this.date,
      this.image);
}
