
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rmuti_shop/screens/drawer/account/account_data/account_data_page.dart';
import 'package:flutter_app_rmuti_shop/screens/drawer/account/history_page.dart';
import 'package:flutter_app_rmuti_shop/screens/drawer/account/status_orders/status_order_tab.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.accountID);

  final accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountPage(accountID);
  }
}

class _AccountPage extends State {
  _AccountPage(this.accountID);

  final accountID;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          title: Text("My Account ID ${accountID.toString()}"),
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text("สถานะสินค้า"),
              ),
              Tab(
                child: Text("ประวัติการซื้อ"),
              ),
              Tab(
                child: Text("ข้อมูลผู้ใช้"),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StatusOrderTab(accountID),
            HistoryPage(accountID),
            AccountDataPage(accountID)
          ],
        ),
      ),
      initialIndex: 0,
      length: 3,
    );
  }
}
