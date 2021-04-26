import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/TopSaga/Desktop/flutter_app_rmuti_shop/lib/screens/main_tab/product_page/products_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllProductsPage extends StatefulWidget {
  AllProductsPage();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AllProductsPage();
  }
}

class _AllProductsPage extends State {
  _AllProductsPage();

  int accountID;
  final urlListAllProducts = "https://testheroku11111.herokuapp.com/Item/list";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountID();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: FutureBuilder(
            future: _listProducts(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsPage(
                                        accountID,
                                        snapshot.data[index].id,
                                        snapshot.data[index].name,
                                        snapshot.data[index].description,
                                        snapshot.data[index].price,
                                        snapshot.data[index].location,
                                        snapshot.data[index].user_id,
                                        snapshot.data[index].date,
                                        snapshot.data[index].image,
                                        snapshot.data[index].discount,
                                        snapshot.data[index].count_promotion,
                                        snapshot.data[index].status_promotion,
                                      )));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: snapshot.data[index].image == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Container(
                                              color: Colors.blueGrey,
                                              height: 150,
                                              width: 150,
                                              child: Icon(
                                                Icons.image_outlined,
                                                color: Colors.orange[600],
                                                size: 40,
                                              )),
                                        )
                                      : ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.memory(
                                      base64Decode(
                                          snapshot.data[index].image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data[index].name}",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "฿${snapshot.data[index].price}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                                child: snapshot.data[index]
                                                            .status_promotion ==
                                                        1
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "ซื้อครบ ${snapshot.data[index].count_promotion} ชิ้น"),
                                                          Text(
                                                              "รับส่วนลด ${snapshot.data[index].discount} %")
                                                        ],
                                                      )
                                                    : Container()),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                    "${snapshot.data[index].location}")
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }));
  }

  Future<void> _onRefresh() async {
    _listProducts();
    setState(() {});
    await Future.delayed(Duration(seconds: 3));
  }

  Future<List<_Products>> _listProducts() async {
    print("connect to Api All Products...");
    var _getDataProDucts = await http.get(urlListAllProducts);
    print("connect to Api All Products Success");
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
          i['promotion'],
          i['date'],
          i['image']);
      listAllProducts.insert(0, _products);
    }
    print("All Products length : ${listAllProducts.length}");
    return listAllProducts;
  }

  Future getAccountID() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    final accountIDInDevice = _accountID.getInt('accountID');
    if (accountIDInDevice != null) {
      setState(() {
        accountID = accountIDInDevice;
        print("Get account login future: accountID ${accountID.toString()}");
      });
    } else {
      print("no have accountID login");
    }
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
