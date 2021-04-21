import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/TopSaga/Desktop/flutter_app_rmuti_shop/lib/screens/main_tab/product_page/products_page.dart';
import 'package:http/http.dart'as http;

class AllDealsPage extends StatefulWidget {
  AllDealsPage(this.accountID);
  final int accountID;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AllDealsPage(accountID);
  }
}

class _AllDealsPage extends State {
  _AllDealsPage(this.accountID);
  final int accountID;
  final urlListAllDealsProducts = "https://testheroku11111.herokuapp.com/Item/find/status";
  final statusPromotion = 1;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: FutureBuilder(
            future: _listDealProducts(),
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
    _listDealProducts();
    setState(() {});
    await Future.delayed(Duration(seconds: 3));
  }

  Future<List<_Products>> _listDealProducts() async {
    print("connect to Api All Deals Products...");
    List<_Products> listAllDealsProducts = [];
    Map params = Map();
    params['promotion'] = statusPromotion.toString();
    await http.post(urlListAllDealsProducts,body: params).then((res){
      print("connect to Api All Deals Products Success !");
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var productsData = jsonData['data'];
      for (var i in productsData) {
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
        listAllDealsProducts.insert(0, _products);
      }
    });
    print("All Deals Products length : ${listAllDealsProducts.length}");
    return listAllDealsProducts;
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

