import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';

Widget transactionCard({
  //TransactionModel transaction,
  required double height,
  required double width,
  required CustomTransaction transaction,
  required Function onTap,
  required Key key,
}) {
  late String status;
  late DateTime dueDate;
  int days = locator<LimitsDataProvider>()
      .transactionLimits!
      .transactionDefaultsAfterDays;
  dueDate =
      transaction.genericInformation.initiationAt.add(Duration(days: days));
  late Color textColor;
  int hours = locator<LimitsDataProvider>()
      .transactionLimits!
      .keepTransactionActiveForHours;
  int minutes = locator<LimitsDataProvider>()
      .transactionLimits!
      .keepTransactionActiveForMinutes;
  int minutesPassed = DateTime.now()
      .difference(transaction.genericInformation.initiationAt)
      .inMinutes;
  void assign() {
    textColor = textGreyShade;
    if (locator<UserDataProvider>().platformData!.referralCode ==
        transaction.borrowerInformation.borrowerReferralCode) {
      if (minutesPassed >= (minutes + (hours * 60))) {
        if (!transaction.transactionStatus.lenderSentMoney) {
          status = "Failed";
          textColor = Colors.red;
          return;
        }
      }
      if (!transaction.razorpayInformation.sentMoneyToBorrower &&
          transaction.transactionStatus.lenderSentMoney) {
        status = "Processing money";
        textColor = Colors.orange;
      } else if (transaction.razorpayInformation.sentMoneyToBorrower &&
          !transaction.transactionStatus.borrowerSentMoney) {
        status = "Your turn to pay back";
        textColor = primaryLightColor;
      } else if (transaction.transactionStatus.borrowerSentMoney &&
          !transaction.razorpayInformation.sentMoneyToLender) {
        status = "Processing money";
        textColor = Colors.orange;
      } else {
        status = "Success";
        textColor = neonGreen;
      }
    } else {
      if (transaction.transactionStatus.lenderSentMoney &&
          !transaction.razorpayInformation.sentMoneyToBorrower) {
        status = "Processing money";
        textColor = Colors.orange;
      } else if (transaction.razorpayInformation.sentMoneyToLender) {
        status = "Success";
        textColor = neonGreen;
      } else if (transaction.transactionStatus.borrowerSentMoney &&
          !transaction.razorpayInformation.sentMoneyToLender) {
        status = "Processing money";
        textColor = Colors.orange;
      } else {
        status = "Wait for Pay Back";
      }
    }
    return;
  }

  assign();
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontal_padding * 1.5,
        vertical: vertical_padding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 125),
        child: Container(
          key: key,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: blue98,
            boxShadow: [
              BoxShadow(
                color: authButtonColorLight.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 4),
              )
            ],
          ),
          height: height * 0.15,
          child: Padding(
            padding: const EdgeInsets.only(
              left: horizontal_padding,
              right: horizontal_padding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹ ${transaction.genericInformation.amount}',
                      style: TextStyle(
                        fontSize: (default_headers + default_big_font_size) / 2,
                        color: authButtonColorLight,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    transaction.lenderInformation!.lenderName == null
                        ? Text(
                            "Searching for lender",
                            style: TextStyle(
                              fontSize: (default_normal_font_size +
                                      default_small_font_size) /
                                  2,
                              color: primaryLightColor,
                            ),
                          )
                        : Text(
                            'Lender: ${transaction.lenderInformation!.lenderName}',
                            style: TextStyle(
                              fontSize: (default_normal_font_size +
                                      default_small_font_size) /
                                  2,
                              color: primaryLightColor,
                            ),
                          ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Txn Date:' +
                          '${transaction.genericInformation.initiationAt.day}'
                              '/${transaction.genericInformation.initiationAt.month}'
                              '/${transaction.genericInformation.initiationAt.year}',
                      style: TextStyle(
                        fontSize: (default_normal_font_size +
                                default_small_font_size) /
                            2,
                        color: primaryLightColor,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    transaction.lenderInformation!.lenderName == null
                        ? Text(
                            "Searching for lender",
                            style: TextStyle(
                              fontSize: (default_normal_font_size +
                                      default_small_font_size) /
                                  2,
                              color: primaryLightColor,
                            ),
                          )
                        : Text(
                            'Due Date:' +
                                '${dueDate.day}'
                                    '/${dueDate.month}'
                                    '/${dueDate.year}',
                            style: TextStyle(
                              fontSize: (default_normal_font_size +
                                      default_small_font_size) /
                                  2,
                              color: primaryLightColor,
                            ),
                          ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: default_normal_font_size,
                        color: primaryLightColor,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: default_normal_font_size,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
