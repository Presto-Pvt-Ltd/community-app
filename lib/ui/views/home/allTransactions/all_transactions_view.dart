import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
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
          child: model.isBusy
              ? Center(
                  child: loader,
                )
              : model.transactions.length == 0
                  ? Container(
                    color: backgroundColorLight,
                    alignment: Alignment.center,
                    child: Text(
                        "No Transactions to Display",
                        style: TextStyle(
                            fontSize: height * 0.022, color: Colors.black),
                      ),
                  )
                  : Container(
                      color: backgroundColorLight,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: horizontal_padding,
                              left: horizontal_padding,
                              top: vertical_padding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width * 0.39,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Amount",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                        ),
                                      ),
                                      Text(
                                        "Borrowed",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Divider(
                                        color: authButtonColorLight,
                                        thickness: 1,
                                      ),
                                      Text(
                                        "\u20B9 ${model.amountBorrowed}",
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width * 0.39,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Amount",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                        ),
                                      ),
                                      Text(
                                        "Lent",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Divider(
                                        color: authButtonColorLight,
                                        thickness: 1,
                                      ),
                                      Text(
                                        "\u20B9 ${model.amountLent}",
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Expanded(
                            child: Container(
                              child: ListView(
                                children: [
                                  for (int i = model.transactions.length - 1;
                                      i >= 0;
                                      i--) ...[
                                    transactionCard(
                                      transaction: model.transactions[i],
                                      key: Key(
                                        model.transactions[i].genericInformation
                                            .transactionId,
                                      ),
                                      height: height,
                                      width: width,
                                      onTap: () {
                                        model.navigationService.navigateTo(
                                          Routes.transactionView,
                                          arguments: TransactionViewArguments(
                                            customTransaction:
                                                model.transactions[i],
                                          ),
                                        );
                                        print("Mujhe dabaya gaya hai");
                                      },
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
