import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/views/transaction/transaction_viewModel.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:stacked/stacked.dart';
import '../../shared/colors.dart';

class TransactionView extends StatelessWidget {
  final CustomTransaction customTransaction;
  const TransactionView({
    Key? key,
    required this.customTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TransactionViewModel>.reactive(
      viewModelBuilder: () => TransactionViewModel(),
      disposeViewModel: false,
      onModelReady: (model) => model.onModelReady(customTransaction),
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: backgroundColorLight,
            elevation: 0.0,
            leading: GestureDetector(
              onTap: () {
                model.pop();
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: actions_icon_size,
                  height: actions_icon_size * 0.7,
                  child: SvgPicture.asset(
                    "assets/icons/left-arrow.svg",
                    fit: BoxFit.fitHeight,
                    color: authButtonColorLight,
                  ),
                ),
              ),
            ),
          ),
          body: model.isBusy
              ? Center(
                  child: loader,
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: backgroundColorLight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height / 25,
                      ),
                      Center(
                        child: Text(
                          '₹ ${customTransaction.genericInformation.amount}',
                          style: TextStyle(
                            fontSize: height / 15,
                            color: authButtonColorLight,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Current Status:',
                            style: TextStyle(
                              fontSize: default_big_font_size * 1.4,
                              fontWeight: FontWeight.w500,
                              color: authButtonColorLight,
                            ),
                          ),
                          Text(
                            model.transactionStatus,
                            style: TextStyle(
                              fontSize: default_big_font_size * 1.4,
                              fontWeight: FontWeight.w500,
                              color: model.transactionStatus == "Failed"
                                  ? Colors.red
                                  : customTransaction
                                              .lenderInformation!.lenderName ==
                                          null
                                      ? Colors.orangeAccent
                                      : primaryLightColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      ListTile(
                        title: Text(
                          'Transaction Id:',
                          style: TextStyle(
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                        trailing: Text(
                          customTransaction.genericInformation.transactionId,
                          style: TextStyle(
                            color: primaryLightColor,
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Date of Transaction:',
                          style: TextStyle(
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                        trailing: Text(
                          '${customTransaction.genericInformation.initiationAt.day}'
                          '/${customTransaction.genericInformation.initiationAt.month}'
                          '/${customTransaction.genericInformation.initiationAt.year}',
                          style: TextStyle(
                            color: primaryLightColor,
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Interest Rate',
                          style: TextStyle(
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                        trailing: Text(
                          '${customTransaction.genericInformation.interestRate}%',
                          style: TextStyle(
                            color: primaryLightColor,
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Creditworthy Score',
                          style: TextStyle(
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                        trailing: Text(
                          customTransaction
                              .borrowerInformation.borrowerCreditScore
                              .toStringAsPrecision(3),
                          style: TextStyle(
                            color: primaryLightColor,
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 10,
                      ),
                      BusyButton(
                        busy: model.isBusy,
                        height: height * 0.08,
                        title: model.buttonText,
                        fontSize:
                            (default_normal_font_size + default_big_font_size) /
                                2,
                        decoration: BoxDecoration(
                          color: model.buttonColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(width / 15),
                          ),
                        ),
                        onPressed: (model.buttonText == "Pay Back")
                            ? () {
                                model.initiateTransaction();
                              }
                            : null,
                        textColor: busyButtonTextColorLight,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
