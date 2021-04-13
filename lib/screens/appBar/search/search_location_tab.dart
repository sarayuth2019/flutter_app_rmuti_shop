import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/screens/main_tab/products_page.dart';


class SearchLocation extends StatefulWidget {
  SearchLocation(this.accountID, this._listAllProducts);

  final int accountID;
  final List _listAllProducts;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchLocation(accountID, _listAllProducts);
  }
}

class _SearchLocation extends State {
  _SearchLocation(this.accountID, this._listAllProducts);

  final int accountID;
  final List _listAllProducts;

  List _searchProducts = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _searchProducts = _listAllProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        children: [
          Card(
            child: TextField(
              decoration: InputDecoration(hintText: "   Enter Location"),
              onChanged: (textSearch) {
                setState(() {
                  _searchProducts = _listAllProducts
                      .where((element) => element.location
                          .toLowerCase()
                          .contains(textSearch.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _searchProducts.length,
                itemBuilder: (BuildContext context, index) {
                  if (_searchProducts == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsPage(
                                  accountID,
                                  _searchProducts[index].id,
                                  _searchProducts[index].name,
                                  _searchProducts[index].description,
                                  _searchProducts[index].price,
                                  _searchProducts[index].location,
                                  _searchProducts[index].user_id,
                                  _searchProducts[index].date,
                                  _searchProducts[index].image,
                                  _searchProducts[index].discount,
                                  _searchProducts[index].count_promotion,
                                  _searchProducts[index].status_promotion,
                                )));
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(
                                  base64Decode(_searchProducts[index].image),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "${_searchProducts[index].name}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "${_searchProducts[index].location}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
