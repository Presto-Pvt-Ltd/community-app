import 'package:flutter/material.dart';

Widget mixedCard({
  //TransactionModel transaction,
  required double height,
  required double width,
  required bool isBorrowed,
  required int amount,
  required String? lenderName,
  required Function onTap,
}) {
  Color cardColor;
  Color textColor;
  String displayText;
  String paymentModes = '';
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

  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.02),
      child: Container(
        height: height * 0.135,
        child: Card(
          elevation: 5,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ $amount',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      // color: textColor,
                    ),
                  ),
                  Text(
                    lenderName == null
                        ? "Searching for lender"
                        : 'Lender: $lenderName',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: lenderName == null
                          ? Colors.orangeAccent
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
