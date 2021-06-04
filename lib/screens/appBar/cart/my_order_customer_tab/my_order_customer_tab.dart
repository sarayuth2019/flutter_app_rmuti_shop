import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_rmuti_shop/Config/config.dart';
import 'package:flutter_app_rmuti_shop/screens/appBar/cart/my_order_customer_tab/review_product_page.dart';
import 'package:http/http.dart' as http;

class MyOrderCustomerTab extends StatefulWidget {
  MyOrderCustomerTab(this.accountID);

  final int accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyOrderCustomerTab(accountID);
  }
}

class _MyOrderCustomerTab extends State {
  _MyOrderCustomerTab(this.accountID);

  final int accountID;
  final urlListOrderByCustomer =
      "${Config.API_URL}/Order/find/customer";

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
          } else if (snapshot.data.length == 0) {
            return Center(
                child: Text(
              "No have order",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ));
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              top: 8,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.memory(
                                base64Decode(snapshot.data[index].image),
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text("PID : ${snapshot.data[index].item_id}")
                        ],
                      ),
                      Expanded(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order ID : ${snapshot.data[index].id}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${snapshot.data[index].name}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "Seller ID : ${snapshot.data[index].seller_id}",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${snapshot.data[index].date}"),
                              Row(
                                children: [
                                  Text("สถานะสินค้า : "),
                                  Container(
                                      child: snapshot.data[index].status == 1
                                          ? Text("สำเร็จ",
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold))
                                          : Text("รอดำเนินการ",
                                              style: TextStyle(
                                                  color:
                                                      Colors.yellowAccent[700],
                                                  fontWeight:
                                                      FontWeight.bold))),
                                ],
                              ),
                              Container(
                                child: snapshot.data[index].status == 1
                                    ? Center(
                                        child: TextButton(
                                          child: Text("ให้คะแนนรีวิว",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReviewProductPage(accountID,snapshot.data[index].item_id,snapshot.data[index].id)));
                                          },
                                        ),
                                      )
                                    : Container(),
                              )
                              //RaisedButton(onPressed: () {print(snapshot.data[index].status);})
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Text("จำนวน ${snapshot.data[index].number}"),
                              Text(
                                  "ราคา ฿${snapshot.data[index].number * snapshot.data[index].price} "),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
                });
          }
        },
      ),
    );
  }

  Future<List<_Order>> listOrderByCustomer() async {
    Map params = Map();
    List<_Order> listOrderByCustomer = [];
    params['customer'] = accountID.toString();
    print("connect to Api Order by Customer...");
    await http.post(urlListOrderByCustomer, body: params).then((res) {
      print("connect to Api Order by Customer Success");

      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var productsData = jsonData['data'];

      for (var p in productsData) {
        print("list Order products...");
        _Order _order = _Order(
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
        listOrderByCustomer.add(_order);
      }
    });
    print("Order Products length : ${listOrderByCustomer.length}");
    return listOrderByCustomer;
  }
}

class _Order {
  final int id;
  final int status;
  final String name;
  final int number;
  final int price;
  final int customer_id;
  final int seller_id;
  final int item_id;
  final String date;
  final String image;

  _Order(
    this.id,
    this.status,
    this.name,
    this.number,
    this.price,
    this.customer_id,
    this.seller_id,
    this.item_id,
    this.date,
    this.image,
  );
}
