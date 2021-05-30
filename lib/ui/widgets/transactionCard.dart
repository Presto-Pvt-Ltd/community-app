import 'package:flutter/material.dart';
Widget mixedCard({
  //TransactionModel transaction,
  required double height,
  required double width,
  required bool isBorrowed,
  required int duration,
}) {
  Color cardColor;
  Color textColor;
  String displayText;
  String paymentModes = '';
  List<String> options = ['PayTm', 'GPay', 'UPI', 'PhonePay', 'PayPal'];
  // transaction.transactionMethods.forEach((element) {
  //   paymentModes = paymentModes + options[element] + ', ';
  // });
  // String date = transaction.initiationDate.toDate().day.toString() +
  //     '/' +
  //     transaction.initiationDate.toDate().month.toString() +
  //     '/' +
  //     transaction.initiationDate.toDate().year.toString();
  // print("Getting initial data ----------------");
  // if (transaction.approvedStatus) {
  //   displayText =
  //   !isBorrowed ? transaction.borrowerName : transaction.lenderName;
  // } else {
  //   displayText = "Failed";
  // }
  // textColor = isBorrowed ? Colors.red[800] : Colors.green[800];

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Card(
      // color: cardColor,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0, bottom: 6.0),
        child: ExpansionTile(
          title: Text(
            '',
            // displayText ?? "",
            style: TextStyle(
              fontSize: 20,
              // color: textColor,
            ),
          ),
          subtitle: Text(
            "₹ ",// + transaction.amount,
            style: TextStyle(
              fontSize: 15,
              // color: textColor,
            ),
          ),
          // trailing: TransactionCardButton(
          //   height: height,
          //   width: width,
          //   transaction: transaction,
          //   isBorrowed: isBorrowed,
          // ),
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Transaction Date:"),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    ''
                    //date,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text("Payment Mode:"),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(paymentModes),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Due Date:"),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    ''
                    // transaction.approvedStatus
                    //     ? transaction.initiationDate
                    //     .toDate()
                    //     .add(
                    //   Duration(
                    //     days: duration,
                    //   ),
                    // )
                    //     .toString()
                    //     : "N/A",
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Interest Rate:"),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  // child: Text("${transaction.interestRate.toString()} %"),
                ),
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
