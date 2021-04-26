import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class ReviewProductPage extends StatefulWidget {
  ReviewProductPage(this.accountID, this.item_id, this.order_id);

  final int accountID;
  final int item_id;
  final int order_id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReviewProductPage(accountID, item_id, order_id);
  }
}

class _ReviewProductPage extends State {
  _ReviewProductPage(this.accountID, this.item_id, this.order_id);

  final int accountID;
  final int item_id;
  final int order_id;
  final snackBarKey = GlobalKey<ScaffoldState>();
  final snackBarOnReview = SnackBar(content: Text("กำลังบันทึกการรีวิว..."));
  final snackBarOnReviewSuccess =
      SnackBar(content: Text("สำเร็จ ขอบคุณสำหรับการรีวิว !"));
  final snackBarOnReviewFall = SnackBar(content: Text("ผิดพลาด !"));
  final urlSaveReview = "https://testheroku11111.herokuapp.com/Review/save";
  final urlDeleteOrder = "https://testheroku11111.herokuapp.com/Order/delete/";
  TextEditingController content = TextEditingController();
  double _rating = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: snackBarKey,
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          title: Text("Review Product ID : ${item_id.toString()}"),
        ),
        body: Center(
          child: Card(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemCount: 5,
                      initialRating: _rating,
                      minRating: 1,
                      maxRating: 5,
                      allowHalfRating: true,
                      itemBuilder: (context, _ratingCount) => Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                          print(_rating);
                        });
                      },
                    ),
                    Text("${_rating.toString()}")
                  ],
                ),
                Card(
                  child: TextField(
                    controller: content,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "บอกคนอื่นว่าทำไม 'ถูกใจ' สินค้านี้",
                        border: InputBorder.none),
                  ),
                ),
                ElevatedButton(
                  child: Text("ให้คะแนนรีวิว"),
                  style: ElevatedButton.styleFrom(primary: Colors.orange[600]),
                  onPressed: saveReviewToDB,
                )
              ],
            )),
          ),
        ));
  }

  void saveReviewToDB() async {
    snackBarKey.currentState.showSnackBar(snackBarOnReview);
    print("accountID : ${accountID.toString()}");
    print("item ID : ${item_id.toString()}");
    print("rating: ${_rating.toString()}");
    print("content : ${content.text}");

    Map params = Map();
    params['user'] = accountID.toString();
    params['items'] = item_id.toString();
    params['rating'] = _rating.toString();
    params['content'] = content.text;
    await http.post(urlSaveReview, body: params).then((res) {
      print(res.body);
      var jsonDataRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var statusData = jsonDataRes['status'];
      if (statusData == 1) {
        http.get("${urlDeleteOrder}${order_id}");
        snackBarKey.currentState.showSnackBar(snackBarOnReviewSuccess);
      } else {
        snackBarKey.currentState.showSnackBar(snackBarOnReviewFall);
      }
    });
  }
}
