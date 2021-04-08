import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/screens/main_tab/products_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class ProductsGroupPage extends StatefulWidget {
  ProductsGroupPage(this.accountID, this.itemGroup);

  final int accountID;
  final int itemGroup;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductsGroupPage(accountID, itemGroup);
  }
}

class _ProductsGroupPage extends State {
  _ProductsGroupPage(this.accountID, this.itemGroup);

  final int accountID;
  final int itemGroup;
  final urlFindByGroup =
      "https://testheroku11111.herokuapp.com/Item/find/group";
  String textGroup;
  int ratingCount = 10;
  double rating = 3.9;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (itemGroup == 1) {
        textGroup = "Food & Drink";
      } else if (itemGroup == 2) {
        textGroup = "School supplies";
      } else if (itemGroup == 3) {
        textGroup = "Uniform";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text(textGroup),
      ),
      body: Container(
        child: FutureBuilder(
          future: listProductsGroup(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
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
                                      rating,
                                      ratingCount,
                                      snapshot.data[index].price,
                                      snapshot.data[index].location,
                                      snapshot.data[index].user_id,
                                      snapshot.data[index].date,
                                      snapshot.data[index].image,
                                      snapshot.data[index].status_promotion,
                                      snapshot.data[index].count_promotion,
                                      snapshot.data[index].discount,
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
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                            color: Colors.blueGrey,
                                            height: 200,
                                            width: 200,
                                            child: Icon(
                                              Icons.image_outlined,
                                              color: Colors.orange[600],
                                              size: 40,
                                            )),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Image.memory(
                                            base64Decode(
                                                snapshot.data[index].image),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${snapshot.data[index].name}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "ซื้อครบ ${snapshot.data[index].count_promotion} ชิ้น"),
                                                  Text(
                                                      "รับส่วนลด ${snapshot.data[index].discount} %")
                                                ],
                                              )
                                                  : Container())
                                        ],
                                      ),
                                    ),
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      initialRating: rating,
                                      itemBuilder: (context, r) {
                                        return Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        );
                                      },
                                      itemSize: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "(${rating.toString()})",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.supervisor_account,
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            "(${ratingCount.toString()})",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                          ),
                                          Text(
                                              "${snapshot.data[index].location}")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  Future<List<_Products>> listProductsGroup() async {
    Map params = Map();
    List<_Products> listGroupProducts = [];
    params['group'] = itemGroup.toString();
    print("connect to Api Group Products...");
    await http.post(urlFindByGroup, body: params).then((res) {
      print("connect to Api Group Products Success");

      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var productsData = jsonData['data'];

      for (var i in productsData) {
        print("list products...");
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
        listGroupProducts.insert(0, _products);
      }
    });
    print("Group Products length : ${listGroupProducts.length}");
    return listGroupProducts;
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
