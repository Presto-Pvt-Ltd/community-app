import 'package:flutter/material.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/views/transaction/transaction_viewModel.dart';
import 'package:presto/ui/widgets/ListToken.dart';
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
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                )
              : SafeArea(
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
                            color: primaryColor,
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
                              fontSize: height * 0.027,
                            ),
                          ),
                          Text(
                            model.transactionStatus,
                            style: TextStyle(
                              fontSize: height * 0.027,
                              color: customTransaction
                                          .lenderInformation!.lenderName ==
                                      null
                                  ? Colors.orangeAccent
                                  : primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      ListToken(
                        icon: Icons.receipt,
                        name: 'Transaction Id:',
                        trailName:
                            customTransaction.genericInformation.transactionId,
                      ),
                      ListToken(
                        icon: Icons.date_range,
                        name: 'Date of Transaction:',
                        trailName:
                            '${customTransaction.genericInformation.initiationAt.day}'
                            '/${customTransaction.genericInformation.initiationAt.month}'
                            '/${customTransaction.genericInformation.initiationAt.year}',
                      ),
                      ListToken(
                        icon: Icons.rate_review,
                        name: 'Interest Rate',
                        trailName:
                            '${customTransaction.genericInformation.interestRate}%',
                      ),
                      ListToken(
                        icon: Icons.credit_card_rounded,
                        name: 'Creditworthy Score',
                        trailName: customTransaction
                            .borrowerInformation.borrowerCreditScore
                            .toStringAsPrecision(3),
                      ),
                      SizedBox(
                        height: height / 10,
                      ),
                      BusyButton(
                        busy: model.isBusy,
                        height: height / 10,
                        width: width / 2.5,
                        title: model.buttonText,
                        decoration: BoxDecoration(
                          color: model.buttonColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(width / 15),
                          ),
                        ),
                        onPressed: () {
                          if (model.buttonText == "Pay Back")
                            model.initiateTransaction();
                        },
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
