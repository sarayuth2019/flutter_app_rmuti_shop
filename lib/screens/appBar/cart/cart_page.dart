import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/screens/appBar/cart/my_cart_tab.dart';
import 'package:flutter_app_rmuti_shop/screens/drawer/account/my_order_tab.dart';


class CartPage extends StatefulWidget {
  CartPage(this.accountID);

  final accountID;


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartPage(accountID);
  }
}

class _CartPage extends State {
  _CartPage(this.accountID);

  final accountID;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          title: Text("My Cart ID ${accountID.toString()}"),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text("รถเข็น"),
              ),
              Tab(
                child: Text("ที่สั่งแล้ว"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [MyCartTab(accountID), MyOrderTab(accountID)],
        ),
      ),
      initialIndex: 0,
      length: 2,
    );
  }
}
