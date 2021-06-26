import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      onModelReady: (model) =>
          SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        model.onModelReady(slideChangeView);
      }),
      viewModelBuilder: () => AllTransactionsViewModel(),
      disposeViewModel: false,
      builder: (context, model, child) {
        print(model.transactions);
        return GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            print(dragEndDetails.velocity);
            print(dragEndDetails.primaryVelocity);
            if (!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative &&
                dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300) {
              model.callback(false);
            } else if (dragEndDetails.velocity.pixelsPerSecond.dx.isNegative &&
                dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300) {
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
                            Container(
                              height: height * 0.745,
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
                                          transaction: model.transactions[
                                              model.transactions.length -
                                                  1 -
                                                  index],
                                          key: Key(
                                            model
                                                .transactions[
                                                    model.transactions.length -
                                                        1 -
                                                        index]
                                                .genericInformation
                                                .transactionId,
                                          ),
                                          height: height,
                                          width: width,
                                          onTap: () {
                                            model.navigationService.navigateTo(
                                              Routes.transactionView,
                                              arguments:
                                                  TransactionViewArguments(
                                                customTransaction: model
                                                        .transactions[
                                                    model.transactions.length -
                                                        1 -
                                                        index],
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
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
