import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/views/transaction/transaction_viewModel.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:presto/ui/widgets/paymentSheet.dart';
import 'package:stacked/stacked.dart';
import '../../shared/colors.dart';

int emiMonthsSelected = 3;
List<bool> emiMonthSelection = [false, false, false];
double interestAmount = 0.0;

class TransactionView extends StatelessWidget {
  final CustomTransaction customTransaction;

  TransactionView({
    Key? key,
    required this.customTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    emiMonthsSelected = customTransaction.borrowerInformation.emiMonths;
    switch (customTransaction.borrowerInformation.emiMonths) {
      case 3:
        {
          emiMonthSelection[0] = true;
          break;
        }
      case 6:
        {
          emiMonthSelection[1] = true;
          break;
        }
      case 9:
        {
          emiMonthSelection[2] = true;
          break;
        }
      default:
        {
          break;
        }
    }
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Type',
                          style: TextStyle(
                            color: primaryLightColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Container(
                          height: height * 0.055,
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.06),
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2.50,
                                blurRadius: 10,
                                offset: Offset(0, 7.5),
                              )
                            ],
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            model.fullPayment ? 'Full Payment' : 'EMI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Text(
                          'Invoice',
                          style: TextStyle(
                            color: primaryLightColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Table(
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  'Payable Amount',
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                                Text(
                                  '\u20B9 ${model.amount}',
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  'Borrowing Date',
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                                Text(
                                  "${model.current.day} ${DateFormat.MMMM().format(model.current)} '${model.current.year.toString().substring(2, 4)}",
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  !model.fullPayment
                                      ? 'Next Installment Date'
                                      : 'Payback Date',
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                                Text(
                                  "${model.current.day} ${DateFormat.MMMM().format(
                                    model.current.add(Duration(days: 90)),
                                  )} '${model.current.year.toString().substring(2, 4)}",
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  'Interest Rate',
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                                Text(
                                  model.fullPayment
                                      ? "0%"
                                      : "${locator<LimitsDataProvider>().transactionLimits!.interest}%",
                                  style: TextStyle(
                                    color: primaryLightColor,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ],
                            ),
                            model.fullPayment
                                ? TableRow(children: [
                                    Container(),
                                    Container(),
                                  ])
                                : TableRow(
                                    children: [
                                      Text(
                                        'Tenure',
                                        style: TextStyle(
                                          color: primaryLightColor,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      Text(
                                        "${customTransaction.borrowerInformation.emiMonths} Months",
                                        style: TextStyle(
                                          color: primaryLightColor,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Visibility(
                          visible: !model.fullPayment,
                          child: Column(
                            children: [
                              Visibility(
                                visible: emiMonthSelection[0],
                                child: Container(
                                  width: width,
                                  child: Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(2),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1)
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: primaryLightColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 90)),
                                              )} '${model.current.year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w400,
                                                decoration: (model.emiPaid >= 1)
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 3).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: (model.emiPaid >= 1)
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 120)),
                                              )} '${model.current.year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: (model.emiPaid >= 2)
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 3).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 2
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 150)),
                                              )} '${model.current.year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                decoration: model.emiPaid >= 3
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${model.amount - ((model.amount / 3).floor().toDouble() * 2)}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 3
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: emiMonthSelection[1],
                                child: Container(
                                  width: width,
                                  child: Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(2),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1)
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: primaryLightColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 90)),
                                              )} '${model.current.add(Duration(days: 90)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w400,
                                                decoration: model.emiPaid >= 1
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 6).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 1
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 120)),
                                              )} '${model.current.add(Duration(days: 120)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 2
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 6).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 2
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 150)),
                                              )} '${model.current.add(Duration(days: 150)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 3
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 6).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 3
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 180)),
                                              )} '${model.current.add(Duration(days: 180)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 4
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 6).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 4
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 210)),
                                              )} '${model.current.add(Duration(days: 210)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 5
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 6).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 5
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 240)),
                                              )} '${model.current.add(Duration(days: 240)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 6
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${model.amount - ((model.amount / 6).floor().toDouble() * 5)}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 6
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: emiMonthSelection[2],
                                child: Container(
                                  width: width,
                                  child: Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(2),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1)
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: primaryLightColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 90)),
                                              )} '${model.current.add(Duration(days: 90)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w400,
                                                decoration: model.emiPaid >= 1
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 1
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 120)),
                                              )} '${model.current.add(Duration(days: 120)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 2
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 2
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 150)),
                                              )} '${model.current.add(Duration(days: 150)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 3
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 3
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 180)),
                                              )} '${model.current.add(Duration(days: 180)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 4
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 4
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 210)),
                                              )} '${model.current.add(Duration(days: 210)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 5
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 5
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 240)),
                                              )} '${model.current.add(Duration(days: 240)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 6
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 6
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 270)),
                                              )} '${model.current.add(Duration(days: 270)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 7
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 7
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 300)),
                                              )} '${model.current.add(Duration(days: 300)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 8
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${(model.amount / 9).floor().toDouble()}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 8
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          Container(
                                            width: 2,
                                            height: 20,
                                            color: Color(0xff070F2C),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "${model.current.day} ${DateFormat.MMMM().format(
                                                model.current
                                                    .add(Duration(days: 330)),
                                              )} '${model.current.add(Duration(days: 330)).year.toString().substring(2, 4)}",
                                              style: TextStyle(
                                                color: Color(0xff070F2C),
                                                fontSize: 17.0,
                                                decoration: model.emiPaid >= 9
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${model.amount - ((model.amount / 9).floor().toDouble() * 8)}',
                                            style: TextStyle(
                                              color: Color(0xff070F2C),
                                              fontSize: 17.0,
                                              decoration: model.emiPaid >= 9
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: BusyButton(
                            busy: model.isBusy,
                            height: height * 0.08,
                            title: model.buttonText,
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
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
                        ),
                      ],
                    ),
                  ),
                ),
          // : SingleChildScrollView(
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       color: backgroundColorLight,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           SizedBox(
          //             height: height / 25,
          //           ),
          //           Center(
          //             child: Text(
          //               '₹ ${customTransaction.genericInformation.amount}',
          //               style: TextStyle(
          //                 fontSize: height / 15,
          //                 color: authButtonColorLight,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: height / 10,
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: horizontal_padding * 0.5,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   'Current Status  ',
          //                   style: TextStyle(
          //                     color: authButtonColorLight,
          //                     fontSize: (default_big_font_size +
          //                             default_normal_font_size) /
          //                         2,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //                 Text(
          //                   model.transactionStatus,
          //                   style: TextStyle(
          //                     fontSize: (default_big_font_size +
          //                             default_normal_font_size) /
          //                         2,
          //                     fontWeight: FontWeight.w500,
          //                     color: model.textColor,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           SizedBox(
          //             height: vertical_padding,
          //           ),
          //           ListTile(
          //             dense: true,
          //             title: Text(
          //               'Transaction Id',
          //               style: TextStyle(
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //             trailing: Text(
          //               customTransaction.genericInformation.transactionId,
          //               style: TextStyle(
          //                 color: primaryLightColor,
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //           ),
          //           ListTile(
          //             dense: true,
          //             title: Text(
          //               model.lenderOrBorrower,
          //               style: TextStyle(
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //             trailing: Text(
          //               model.lenderOrBorrowerName,
          //               style: TextStyle(
          //                 color: primaryLightColor,
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //           ),
          //           ListTile(
          //             dense: true,
          //             title: Text(
          //               'Date of Transaction:',
          //               style: TextStyle(
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //             trailing: Text(
          //               '${customTransaction.genericInformation.initiationAt.day}'
          //               '/${customTransaction.genericInformation.initiationAt.month}'
          //               '/${customTransaction.genericInformation.initiationAt.year}',
          //               style: TextStyle(
          //                 color: primaryLightColor,
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //           ),
          //           ListTile(
          //             dense: true,
          //             title: Text(
          //               'Interest Rate',
          //               style: TextStyle(
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //             trailing: Text(
          //               '${customTransaction.genericInformation.interestRate}%',
          //               style: TextStyle(
          //                 color: primaryLightColor,
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //           ),
          //           ListTile(
          //             dense: true,
          //             title: Text(
          //               'Creditworthy Score',
          //               style: TextStyle(
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //             trailing: Text(
          //               customTransaction
          //                   .borrowerInformation.borrowerCreditScore
          //                   .toStringAsPrecision(3),
          //               style: TextStyle(
          //                 color: primaryLightColor,
          //                 fontSize: default_normal_font_size,
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: vertical_padding * 4,
          //           ),
          //           BusyButton(
          //             busy: model.isBusy,
          //             height: height * 0.08,
          //             title: model.buttonText,
          //             fontSize: (default_normal_font_size +
          //                     default_big_font_size) /
          //                 2,
          //             decoration: BoxDecoration(
          //               color: model.buttonColor,
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(width / 15),
          //               ),
          //             ),
          //             onPressed: (model.buttonText == "Pay Back")
          //                 ? () {
          //                     model.initiateTransaction();
          //                   }
          //                 : null,
          //             textColor: busyButtonTextColorLight,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        );
      },
    );
  }
}
