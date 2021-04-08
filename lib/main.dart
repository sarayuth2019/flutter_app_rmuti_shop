
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/appBar/cart/cart_page.dart';
import 'screens/appBar/promotion/promotion_page.dart';
import 'screens/appBar/search/search_page.dart';
import 'screens/drawer/account/account_page.dart';
import 'screens/drawer/account/sing_in_up/sing_in_page.dart';
import 'screens/drawer/location/location_page.dart';
import 'screens/drawer/productsGroup/products_group_page.dart';
import 'screens/main_tab/all_deals.dart';
import 'screens/main_tab/all_products.dart';
import 'screens/main_tab/cart_count.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }
}

class _HomePage extends State {
  _HomePage();

  int accountID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[600],
            title: Text("RMUTI SHOP"),
            actions: [
              Container(
                child: Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(accountID)));
                        }),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          accountID == null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingIn()))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CartPage(accountID)));
                        }),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: accountID == null
                            ? Container(
                                height: 17,
                                width: 17,
                              )
                            : Center(child: CartCount(accountID)))
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.notifications_on),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromotionPage()));
                        }),
                  ],
                ),
              ),
            ],
            bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: "All Products",
                ),
                Tab(
                  text: "All Deals",
                ),
              ],
            ),
          ),
          drawer: Drawer(
            child: Container(
              color: Colors.blueGrey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: accountID == null
                                ? Text(
                                    "Hello",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Hello ID ${accountID.toString()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )),
                        GestureDetector(
                          onTap: () {
                            accountID == null
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingIn()))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AccountPage(accountID)));
                          },
                          child: Card(
                            color: Colors.orange[600],
                            child: ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Account',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationPage()));
                          },
                          child: Card(
                            color: Colors.orange[600],
                            child: ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Location',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            accountID == null
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingIn()))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CartPage(accountID)));
                          },
                          child: Card(
                            color: Colors.orange[600],
                            child: ListTile(
                              leading: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Categories",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductsGroupPage(accountID, 1)));
                          },
                          child: Card(
                            color: Colors.orange[600],
                            child: ListTile(
                              leading: Icon(
                                Icons.fastfood_outlined,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Food & Drink",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductsGroupPage(accountID, 2)));
                          },
                          child: Card(
                            color: Colors.orange[600],
                            child: ListTile(
                              leading: Icon(
                                Icons.work,
                                color: Colors.white,
                              ),
                              title: Text(
                                "School supplies",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductsGroupPage(accountID, 3)));
                          },
                          child: Card(
                            color: Colors.orange[600],
                            child: ListTile(
                              leading: Icon(
                                Icons.wc_outlined,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Uniform",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      child: GestureDetector(
                        onTap:logout,
                        child: Card(
                          color: Colors.orange[600],
                          child: ListTile(
                            leading: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [AllProductsPage(), AllDealsPage(accountID)],
          )),
      initialIndex: 0,
      length: 2,
    );
  }

  Future autoLogin() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    final accountIDInDevice = _accountID.getInt('accountID');
    if (accountIDInDevice != null) {
      setState(() {
        accountID = accountIDInDevice;
        print("account login future: accountID ${accountID.toString()}");
      });
    }
  }

  Future logout() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    _accountID.setInt('accountID', null);
    print("account logout !");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
  }
}
