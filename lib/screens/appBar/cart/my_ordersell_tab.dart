import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MyOrderTab extends StatefulWidget {
  MyOrderTab(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyOrderTab(accountID);
  }
}

class _MyOrderTab extends State {
  _MyOrderTab(this.accountID);

  final int accountID;
  final urlListOrderByCustomer =
      "https://testheroku11111.herokuapp.com/Order/find/customer";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: FutureBuilder(
        future: listOrderByCustomer(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.memory(
                                base64Decode(snapshot.data[index].image),
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              )),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data[index].name}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "฿${snapshot.data[index].price} x ${snapshot.data[index].number}"),
                                Text(
                                    "รวมเป็นเงิน  ${snapshot.data[index].number * snapshot.data[index].price}  บาท")
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Future<List<_Products>> listOrderByCustomer() async {
    Map params = Map();
    List<_Products> listOrderByCustomer = [];
    params['customer'] = accountID.toString();
    print("connect to Api Order by Customer...");
    await http.post(urlListOrderByCustomer, body: params).then((res) {
      print("connect to Api Order by Customer Success");

      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var productsData = jsonData['data'];

      for (var p in productsData) {
        print("list Order products...");
        _Products _products = _Products(
            p['id'],
            p['status'],
            p['name'],
            p['number'],
            p['price'],
            p['customer'],
            p['user'],
            p['item'],
            p['date'],
            p['image']);
        listOrderByCustomer.add(_products);
      }
    });
    print("Order Products length : ${listOrderByCustomer.length}");
    return listOrderByCustomer;
  }
}

class _Products {
  final int id;
  final int status;
  final String name;
  final int number;
  final int price;
  final int customer_id;
  final int seller_id;
  final int item_id;
  final String data;
  final String image;

  _Products(
    this.id,
    this.status,
    this.name,
    this.number,
    this.price,
    this.customer_id,
    this.seller_id,
    this.item_id,
    this.data,
    this.image,
  );
}
