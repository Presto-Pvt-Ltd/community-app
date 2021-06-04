import 'package:flutter/material.dart';

Widget notificationCard({
  required List<dynamic> paymentOptions,
  required String amount,
  required String score,
  required Function handShakeCallBack,
  required var height,
  required var width,
}) {
  // FireStoreService _fireStoreService = FireStoreService();
  // String paymentModes = '';
  // List<String> options = ['PayTm', 'GPay', 'UPI', 'PhonePay', 'PayPal'];
  // print("Initiating payment modes =----------------------");
  // print("$paymentOptions");
  // print("\n\n\n\n ----------------------------------- \n\n\n\n");
  // for (int i = 0; i < paymentOptions.length; i++) {
  //   print("Setting up payment modes =----------------------");
  //   i == paymentModes.length - 1
  //       ? paymentModes = paymentModes + options[i]
  //       : paymentModes = paymentModes + options[i] + ', ';
  // }

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    child: Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: ExpansionTile(
          title: Text(
            '₹ $amount',
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Credit Score: $score',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Text(
                'Modes of Payment: Paytm, GPay',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              )
            ],
          ),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.only(left: 20),
            //       child: Text("Due Date:"),
            //     ),
            //     Padding(
            //         padding: EdgeInsets.only(right: 20),
            //         child: Text('12/2/2021')),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Padding(
            //       padding: EdgeInsets.only(left: 20),
            //       child: Text("Interest Rate:"),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(right: 20),
            //       child: Text("1%"),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Do You Want To Lend?'),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: width / 10,
                          color: Colors.green,
                          child: Center(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          handShakeCallBack();
                          // var result = await _fireStoreService
                          //     .approveHandshake(transactionId);
                          // if (result is bool && result) {
                          //   locator<DialogService>().showDialog(
                          //       title: "Success",
                          //       description:
                          //       "Handshake Success!!\n You can pay the amount by closing the app and view the transaction in the transaction's screen. Please upload transcript when transaction is done.");
                          // }
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      // GestureDetector(
                      //   child: Container(
                      //     width: width / 10,
                      //     color: Colors.red,
                      //     child: Center(
                      //       child: Text(
                      //         'No',
                      //         style: TextStyle(
                      //             fontSize: 20.0, color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ),
  );
}
