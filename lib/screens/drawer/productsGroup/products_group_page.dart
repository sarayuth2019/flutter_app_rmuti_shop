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
                                      snapshot.data[index].rating,
                                      snapshot.data[index].countRating,
                                      snapshot.data[index].price,
                                      snapshot.data[index].location,
                                      snapshot.data[index].user_id,
                                      snapshot.data[index].data,
                                      snapshot.data[index].image,
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
                                      child: Text(
                                        "฿${snapshot.data[index].price}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      initialRating: snapshot.data[index].rating
                                          .toDouble(),
                                      itemBuilder: (context, r) {
                                        return Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        );
                                      },
                                      itemSize: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "(${snapshot.data[index].rating})",
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
                                            "(${snapshot.data[index].countRating})",
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

      for (var p in productsData) {
        print("list products...");
        _Products _products = _Products(
            p['id'],
            p['name'],
            p['description'],
            p['rating'],
            p['count_rating'],
            p['price'],
            p['location'],
            p['user'],
            p['date'],
            p['image']);
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
  final String description;
  final int rating;
  final int countRating;
  final int price;
  final String location;
  final int user_id;
  final String data;
  final String image;

  _Products(
    this.id,
    this.name,
    this.description,
    this.rating,
    this.countRating,
    this.price,
    this.location,
    this.user_id,
    this.data,
    this.image,
  );
}
