import 'package:flutter/material.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/views/transaction/transaction_viewModel.dart';
import 'package:presto/ui/widgets/ListToken.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:stacked/stacked.dart';
import '../../../models/enums.dart';
import '../../shared/colors.dart';

class TransactionView extends StatelessWidget {
  final CustomTransaction customTransaction;
  final bool isBorrowed;
  const TransactionView(
      {Key? key, required this.customTransaction, required this.isBorrowed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<PaymentMethods> paymentMethods = customTransaction
        .genericInformation.transactionMethodsRequestedByBorrower;
    String paymentMethodsString = '';
    for (int i = 0; i < paymentMethods.length; i++) {
      paymentMethodsString = paymentMethodsToString(paymentMethods[i]);
    }
    bool isTransactionIncomplete =
        !customTransaction.transactionStatus.borrowerSentMoney;
    String buttonText = isTransactionIncomplete ? 'Payback' : 'Already Paid';
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
                              fontSize: height / 15, color: primaryColor),
                        ),
                      ),
                      Center(
                        child: Text(
                          customTransaction.lenderInformation!.lenderName ==
                                  null
                              ? "Searching for lender"
                              : 'Lender: ${customTransaction.lenderInformation!.lenderName}',
                          style: TextStyle(
                            fontSize: height / 35,
                            color: customTransaction
                                        .lenderInformation!.lenderName ==
                                    null
                                ? Colors.orangeAccent
                                : primaryColor,
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
                              fontSize: height / 30,
                            ),
                          ),
                          Text(
                            isTransactionIncomplete
                                ? 'In Progress'
                                : 'Completed',
                            style: TextStyle(
                              fontSize: height / 30,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      ListToken(
                          icon: Icons.date_range,
                          name: 'Date of Transaction:',
                          trailName:
                              '${customTransaction.genericInformation.initiationAt.day}'
                              '/${customTransaction.genericInformation.initiationAt.month}'
                              '/${customTransaction.genericInformation.initiationAt.year}'),
                      Tooltip(
                        message: '$paymentMethodsString',
                        child: ListToken(
                            icon: Icons.chrome_reader_mode,
                            name: 'Modes of Payment',
                            trailName: paymentMethods.length > 1
                                ? '${paymentMethodsToString(paymentMethods[0])}...'
                                : '${paymentMethodsToString(paymentMethods[0])}'),
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
                            .toString(),
                      ),
                      SizedBox(
                        height: height / 10,
                      ),
                      isBorrowed &&
                              customTransaction.lenderInformation!.lenderName !=
                                  null
                          ? BusyButton(
                              height: height / 10,
                              width: width / 2.5,
                              title: buttonText,
                              decoration: BoxDecoration(
                                color: isTransactionIncomplete
                                    ? primaryColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width / 15),
                                ),
                              ),
                              onPressed: () {
                                isTransactionIncomplete
                                    ? model.initiateTransaction()
                                    : null;
                              },
                              textColor: Colors.white,
                            )
                          : Container()
                    ],
                  ),
                ),
        );
      },
    );
  }
}
