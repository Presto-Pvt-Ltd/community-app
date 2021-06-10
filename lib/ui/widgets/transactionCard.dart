import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';

Widget mixedCard({
  //TransactionModel transaction,
  required double height,
  required double width,
  required CustomTransaction transaction,
  required Function onTap,
  required Key key,
}) {
  late Color textColor;
  bool isBorrower;
  String user = locator<UserDataProvider>().platformData!.referralCode;
  bool inProcess = true;
  if (transaction.razorpayInformation.sentMoneyToBorrower &&
      !transaction.razorpayInformation.sentMoneyToLender) {
    /// Money sent by borrower but no received by lender
    inProcess = false;
    textColor = Colors.orange;
  } else if (transaction.razorpayInformation.sentMoneyToBorrower &&
      !transaction.razorpayInformation.sentMoneyToLender) {
    inProcess = false;
    textColor = Colors.red;
  } else if (!transaction.razorpayInformation.sentMoneyToBorrower) {
    /// Money sent by lender not received by borrower
    textColor = Colors.orange;
  } else if (transaction.razorpayInformation.sentMoneyToLender) {
    /// Money sent by lender not received by borrower
    textColor = Colors.black38;
  } else {}
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
          key: key,
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
                    '₹ ${transaction.genericInformation.amount}',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      color: textColor,
                    ),
                  ),
                  Text(
                    transaction.lenderInformation!.lenderName == null
                        ? "Searching for lender"
                        : 'Lender: ${transaction.lenderInformation!.lenderName}',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      color: transaction.lenderInformation!.lenderName == null
                          ? Colors.orangeAccent
                          : textColor,
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
