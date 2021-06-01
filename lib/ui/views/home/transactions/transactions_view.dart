import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:stacked/stacked.dart';

import 'transactions_viewModel.dart';

class TransactionsView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const TransactionsView({Key? key, required this.slideChangeView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TransactionsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(slideChangeView),
      viewModelBuilder: () => TransactionsViewModel(),
      disposeViewModel: false,
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        print(model.transactions);
        return GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            print(dragEndDetails.velocity);
            print(dragEndDetails.primaryVelocity);
            if (!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative) {
              model.callback(false);
            } else {
              model.callback(true);
            }
            print('end');
          },
          child: Scaffold(
            body: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Scaffold(
                      body: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: height / 25,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Recent Transactions",
                                style: TextStyle(
                                  fontSize: height / 22,
                                  color: Colors.black,
                                  fontFamily: "Oswald",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 25,
                            ),
                            Column(
                              // children: model.recentTransactions != null
                              //     ? model.recentTransactions
                              children: [
                                Container(
                                  child: Text(
                                    "No Transactions to Display",
                                    style: TextStyle(
                                        fontSize: height / 45,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height / 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "All Transactions",
                                  style: TextStyle(
                                      fontSize: height / 22,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height / 25,
                            ),
                            Column(
                              // children: model.allTransactions.length > 0 &&
                              //     model.allTransactions != null
                              //     ? model.allTransactions
                              children: [
                                Container(
                                  child: Text(
                                    "No Transactions to Display",
                                    style: TextStyle(
                                        fontSize: height / 45,
                                        color: Colors.black),
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
      },
    );
  }
}
