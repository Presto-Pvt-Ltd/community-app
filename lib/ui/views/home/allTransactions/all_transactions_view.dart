import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/widgets/transactionCard.dart';
import 'package:stacked/stacked.dart';
import '../../../../app/app.router.dart';
import 'all_transactions_viewModel.dart';

class AllTransactionsView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const AllTransactionsView({Key? key, required this.slideChangeView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<AllTransactionsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(slideChangeView),
      viewModelBuilder: () => AllTransactionsViewModel(),
      disposeViewModel: false,
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
                              height: height * 0.04,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Active Transactions",
                                style: TextStyle(
                                  fontSize: height * 0.045,
                                  color: Colors.black,
                                  fontFamily: "Oswald",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Column(
                              // children: model.recentTransactions != null
                              //     ? model.recentTransactions
                              children: [
                                Container(
                                  height: height * 0.3,
                                  child: model.activeTransactions.length == 0
                                      ? Text(
                                          "No Active Transactions to Display",
                                          style: TextStyle(
                                              fontSize: height * 0.022,
                                              color: Colors.black),
                                        )
                                      : ListView.builder(
                                          itemCount:
                                              model.activeTransactions.length,
                                          itemBuilder: (context, index) {
                                            return mixedCard(
                                              height: height,
                                              width: width,
                                              lenderName: model
                                                  .activeTransactions[index]
                                                  .lenderInformation!
                                                  .lenderName,
                                              isBorrowed: model
                                                      .activeTransactions[index]
                                                      .borrowerInformation
                                                      .borrowerReferralCode ==
                                                  locator<UserDataProvider>()
                                                      .platformData!
                                                      .referralCode,
                                              amount: model
                                                  .activeTransactions[index]
                                                  .genericInformation
                                                  .amount,
                                              onTap: () {
                                                model.navigationService
                                                    .navigateTo(
                                                  Routes.transactionView,
                                                  arguments:
                                                      TransactionViewArguments(
                                                    customTransaction: model
                                                        .transactions[index],
                                                    isBorrowed: model
                                                            .activeTransactions[
                                                                index]
                                                            .borrowerInformation
                                                            .borrowerReferralCode ==
                                                        locator<UserDataProvider>()
                                                            .platformData!
                                                            .referralCode,
                                                  ),
                                                );
                                                print("Mujhe dabaya gaya hai");
                                              },
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Center(
                              child: Text(
                                "All Transactions",
                                style: TextStyle(
                                    fontSize: height * 0.045,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Column(
                              // children: model.allTransactions.length > 0 &&
                              //     model.allTransactions != null
                              //     ? model.allTransactions
                              children: [
                                Container(
                                  height: height * 0.3,
                                  child: model.transactions.length == 0
                                      ? Text(
                                          "No Transactions to Display",
                                          style: TextStyle(
                                              fontSize: height * 0.022,
                                              color: Colors.black),
                                        )
                                      : ListView.builder(
                                          itemCount: model.transactions.length,
                                          itemBuilder: (context, index) {
                                            return mixedCard(
                                              height: height,
                                              width: width,
                                              lenderName: model
                                                  .transactions[index]
                                                  .lenderInformation!
                                                  .lenderName,
                                              isBorrowed: model
                                                      .transactions[index]
                                                      .borrowerInformation
                                                      .borrowerReferralCode ==
                                                  locator<UserDataProvider>()
                                                      .platformData!
                                                      .referralCode,
                                              amount: model.transactions[index]
                                                  .genericInformation.amount,
                                              onTap: () {
                                                model.navigationService
                                                    .navigateTo(
                                                  Routes.transactionView,
                                                  arguments:
                                                      TransactionViewArguments(
                                                    customTransaction: model
                                                        .transactions[index],
                                                    isBorrowed: model
                                                            .transactions[index]
                                                            .borrowerInformation
                                                            .borrowerReferralCode ==
                                                        locator<UserDataProvider>()
                                                            .platformData!
                                                            .referralCode,
                                                  ),
                                                );
                                                print("Mujhe dabaya gaya hai");
                                              },
                                            );
                                          },
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
