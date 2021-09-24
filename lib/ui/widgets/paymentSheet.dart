import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/widgets/dialogBox.dart';

int emiMonthsSelected = 3;
List<bool> emiMonthSelection = [true, false, false];
double interestAmount = 0.0;
// Widget paymentSheet({
//   required double height,
//   required double width,
//   var customNotification,
//   var onCompleteCallBack,
//   required double amount,
//   required double interest,
//   var onCancel,
// }) {
//   return DraggableScrollableSheet(
//     initialChildSize: 1,
//     // minChildSize: 0.3,
//     builder: (context, controller) {
//       // print(controller.offset);
//       bool fullPayment = true;
//       interestAmount = (amount *
//               locator<LimitsDataProvider>().transactionLimits!.interest /
//               100)
//           .ceilToDouble();
//       void setPayment() {
//         fullPayment = !fullPayment;
//         if (!fullPayment) {
//           amount = amount + interestAmount;
//         } else {
//           amount = amount - interestAmount;
//         }
//         Logger().wtf(amount);
//         print("Toggling : " + fullPayment.toString());
//       }
//
//       return WillPopScope(
//         onWillPop: () {
//           onCancel();
//           return Future.value(true);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: backgroundColorLight,
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(width / 15),
//             ),
//           ),
//           child: ListView(
//             controller: controller,
//             children: <Widget>[
//               SizedBox(
//                 height: height / 45,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: GestureDetector(
//                         onTap: () {
//                           if (onCompleteCallBack != null) {
//                             if (customNotification == null)
//                               onCompleteCallBack(fullPayment);
//                             else
//                               onCompleteCallBack(
//                                 customNotification,
//                                 fullPayment,
//                               );
//                           }
//                           Navigator.of(context).pop();
//                         },
//                         child: Text(
//                           'Done',
//                           style: TextStyle(
//                             color: primaryLightColor,
//                             fontSize: height / 45,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 20.0),
//                     child: Align(
//                       alignment: Alignment.topRight,
//                       child: GestureDetector(
//                         onTap: () {
//                           if (onCancel != null) {
//                             onCancel();
//                           }
//                           Navigator.of(context).pop();
//                         },
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(
//                             color: primaryLightColor,
//                             fontSize: height / 45,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: height / 45,
//               ),
//               PaymentOptions(
//                 height: height,
//                 width: width,
//                 paymentOption: fullPayment,
//                 toggle: setPayment,
//                 amount: amount,
//                 interest: interest,
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: InkWell(
//                   onTap: () {
//                     onCompleteCallBack(
//                         fullPayment, amount, emiMonthsSelected);
//                   },
//                   child: Container(
//                     height: height * 0.055,
//                     width: width * 0.4,
//                     padding: EdgeInsets.symmetric(horizontal: width * 0.06),
//                     decoration: BoxDecoration(
//                       color: primaryLightColor,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           spreadRadius: 2.50,
//                           blurRadius: 10,
//                           offset: Offset(0, 7.5),
//                         ),
//                       ],
//                     ),
//                     alignment: AlignmentDirectional.center,
//                     child: Text(
//                       'Borrow',
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 17.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

class paymentSheet extends StatelessWidget {
  late double height;
  late double width;
  late var customNotification;
  late var onCompleteCallBack;
  late double amount;
  late double interest;
  late var onCancel;
  paymentSheet({
    Key? key,
    required this.height,
    required this.width,
    var this.customNotification,
    var this.onCompleteCallBack,
    required this.amount,
    required this.interest,
    var this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // print(controller.offset);
    bool fullPayment = true;
    interestAmount = (amount *
            locator<LimitsDataProvider>().transactionLimits!.interest /
            100)
        .ceilToDouble();
    void setPayment() {
      fullPayment = !fullPayment;
      if (!fullPayment) {
        amount = amount + interestAmount;
      } else {
        amount = amount - interestAmount;
      }
      Logger().wtf(amount);
      print("Toggling : " + fullPayment.toString());
    }

    return WillPopScope(
      onWillPop: () {
        onCancel();
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColorLight,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(width / 15),
          ),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: height / 45,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (onCompleteCallBack != null) {
                          if (customNotification == null)
                            onCompleteCallBack(fullPayment);
                          else
                            onCompleteCallBack(
                              customNotification,
                              fullPayment,
                            );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: primaryLightColor,
                          fontSize: height / 45,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        if (onCancel != null) {
                          onCancel();
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: primaryLightColor,
                          fontSize: height / 45,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 45,
            ),
            PaymentOptions(
              height: height,
              width: width,
              paymentOption: fullPayment,
              toggle: setPayment,
              amount: amount,
              interest: interest,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  onCompleteCallBack(fullPayment, amount, emiMonthsSelected);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: height * 0.055,
                  width: width * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  decoration: BoxDecoration(
                    color: primaryLightColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2.50,
                        blurRadius: 10,
                        offset: Offset(0, 7.5),
                      ),
                    ],
                  ),
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'Borrow',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOptions extends StatefulWidget {
  final double height;
  final double width;
  final double interest;
  final bool paymentOption;
  final Function toggle;
  final amount;
  const PaymentOptions({
    Key? key,
    required this.height,
    required this.width,
    required this.paymentOption,
    required this.toggle,
    required this.amount,
    required this.interest,
  }) : super(key: key);

  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  late bool fullPayment;
  late final DateTime current;
  late double _amount;
  @override
  void initState() {
    // TODO: implement initState
    current = DateTime.now();
    _amount = widget.amount;
    super.initState();
    fullPayment = widget.paymentOption;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.width * 0.05),
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
            height: widget.height * 0.025,
          ),
          InkWell(
            onTap: () {
              print('tapped toggle');
              if (!fullPayment) {
                widget.toggle();
                setState(() {
                  _amount = _amount - interestAmount;
                  fullPayment = !fullPayment;
                });
              }
            },
            child: Container(
              height: widget.height * 0.055,
              padding: EdgeInsets.symmetric(horizontal: widget.width * 0.06),
              decoration: BoxDecoration(
                color: fullPayment ? primaryLightColor : Colors.white,
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
                'Full Payment',
                style: TextStyle(
                  color: fullPayment ? Colors.white : Colors.black,
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: vertical_padding,
          ),
          InkWell(
            onTap: widget.amount <
                    locator<LimitsDataProvider>()
                        .transactionLimits!
                        .lowerEmiLimit
                ? () {
                    showCustomDialog(
                      title: "Not Available",
                      description:
                          "Possible Only for transactions greater than Rs. ${locator<LimitsDataProvider>().transactionLimits!.lowerEmiLimit}",
                    );
                  }
                : () {
                    if (fullPayment) {
                      widget.toggle();
                      setState(() {
                        _amount = _amount + interestAmount;
                        fullPayment = !fullPayment;
                      });
                    }
                  },
            child: Container(
              height: widget.height * 0.055,
              padding: EdgeInsets.symmetric(horizontal: widget.width * 0.06),
              decoration: BoxDecoration(
                color: fullPayment ? Colors.white : primaryLightColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2.50,
                    blurRadius: 10,
                    offset: Offset(0, 7.5),
                  ),
                ],
              ),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'EMI',
                style: TextStyle(
                  color: fullPayment ? Colors.black : Colors.white,
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: widget.height * 0.05,
          ),
          _buildChildren(),
        ],
      ),
    );
  }

  Widget _buildChildren() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    '\u20B9 $_amount',
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
                    "${current.day} ${DateFormat.MMMM().format(current)} '${current.year.toString().substring(2, 4)}",
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
                    !fullPayment ? 'Next Installment Date' : 'Payback Date',
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "${current.day} ${DateFormat.MMMM().format(
                      current.add(Duration(days: 90)),
                    )} '${current.year.toString().substring(2, 4)}",
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
                    fullPayment ? "0%" : "${widget.interest}%",
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),

              ///transaction screen copy paste
              // TableRow(
              //         children: [
              //           Text(
              //             'Amount Paid',
              //             style: TextStyle(
              //               color: primaryLightColor,
              //               fontSize: 17.0,
              //             ),
              //           ),
              //           Text(
              //             "${widget.interest}%",
              //             style: TextStyle(
              //               color: primaryLightColor,
              //               fontSize: 17.0,
              //             ),
              //           ),
              //         ],
              //       ),
              // TableRow(
              //         children: [
              //           Text(
              //             'Upstanding Amount',
              //             style: TextStyle(
              //               color: primaryLightColor,
              //               fontSize: 17.0,
              //             ),
              //           ),
              //           Text(
              //             "${widget.interest}%",
              //             style: TextStyle(
              //               color: primaryLightColor,
              //               fontSize: 17.0,
              //             ),
              //           ),
              //         ],
              //       ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !fullPayment,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        onTapEmiSelection(3);
                      },
                      child: Container(
                        height: widget.height * 0.055,
                        width: widget.width * 0.22,
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.width * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: !emiMonthSelection[0]
                              ? Color(0xffF6F8FE)
                              : primaryLightColor,
                        ),
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '3 months',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            color: emiMonthSelection[0]
                                ? Color(0xffF6F8FE)
                                : primaryLightColor,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: InkWell(
                        onTap: () {
                          onTapEmiSelection(6);
                        },
                        child: Container(
                          height: widget.height * 0.055,
                          width: widget.width * 0.22,
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.width * 0.02),
                          decoration: BoxDecoration(
                            color: !emiMonthSelection[1]
                                ? Color(0xffF6F8FE)
                                : primaryLightColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            '6 months',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              color: emiMonthSelection[1]
                                  ? Color(0xffF6F8FE)
                                  : primaryLightColor,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onTapEmiSelection(9);
                      },
                      child: Container(
                        height: widget.height * 0.055,
                        width: widget.width * 0.22,
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.width * 0.02),
                        decoration: BoxDecoration(
                          color: !emiMonthSelection[2]
                              ? Color(0xffF6F8FE)
                              : primaryLightColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          '9 months',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            color: emiMonthSelection[2]
                                ? Color(0xffF6F8FE)
                                : primaryLightColor,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Visibility(
                  visible: emiMonthSelection[0],
                  child: Container(
                    width: widget.width,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 90)),
                                )} '${current.year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 3).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 120)),
                                )} '${current.year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 3).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 150)),
                                )} '${current.year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${_amount - ((_amount / 3).floor().toDouble() * 2)}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),

                        ///transaction screen copy paste
                        // TableRow(
                        //         children: [
                        //           Text(
                        //             'Amount Paid',
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //           Text(
                        //             "${widget.interest}%",
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        // TableRow(
                        //         children: [
                        //           Text(
                        //             'Upstanding Amount',
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //           Text(
                        //             "${widget.interest}%",
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: emiMonthSelection[1],
                  child: Container(
                    width: widget.width,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 90)),
                                )} '${current.add(Duration(days: 90)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 6).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 120)),
                                )} '${current.add(Duration(days: 120)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 6).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 150)),
                                )} '${current.add(Duration(days: 150)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 6).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 180)),
                                )} '${current.add(Duration(days: 180)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 6).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 210)),
                                )} '${current.add(Duration(days: 210)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 6).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 240)),
                                )} '${current.add(Duration(days: 240)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${_amount - ((_amount / 6).floor().toDouble() * 5)}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),

                        ///transaction screen copy paste
                        // TableRow(
                        //         children: [
                        //           Text(
                        //             'Amount Paid',
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //           Text(
                        //             "${widget.interest}%",
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        // TableRow(
                        //         children: [
                        //           Text(
                        //             'Upstanding Amount',
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //           Text(
                        //             "${widget.interest}%",
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: emiMonthSelection[2],
                  child: Container(
                    width: widget.width,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 90)),
                                )} '${current.add(Duration(days: 90)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 120)),
                                )} '${current.add(Duration(days: 120)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 150)),
                                )} '${current.add(Duration(days: 150)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 180)),
                                )} '${current.add(Duration(days: 180)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 210)),
                                )} '${current.add(Duration(days: 210)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 240)),
                                )} '${current.add(Duration(days: 240)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 270)),
                                )} '${current.add(Duration(days: 270)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 300)),
                                )} '${current.add(Duration(days: 300)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${(_amount / 9).floor().toDouble()}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
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
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "${current.day} ${DateFormat.MMMM().format(
                                  current.add(Duration(days: 330)),
                                )} '${current.add(Duration(days: 330)).year.toString().substring(2, 4)}",
                                style: TextStyle(
                                  color: Color(0xff070F2C),
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Text(
                              '\u20B9 ${_amount - ((_amount / 9).floor().toDouble() * 8)}',
                              style: TextStyle(
                                color: Color(0xff070F2C),
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),

                        ///transaction screen copy paste
                        // TableRow(
                        //         children: [
                        //           Text(
                        //             'Amount Paid',
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //           Text(
                        //             "${widget.interest}%",
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        // TableRow(
                        //         children: [
                        //           Text(
                        //             'Upstanding Amount',
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //           Text(
                        //             "${widget.interest}%",
                        //             style: TextStyle(
                        //               color: primaryLightColor,
                        //               fontSize: 17.0,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
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
        ],
      ),
    );
  }

  void onTapEmiSelection(int month) {
    switch (month) {
      case 3:
        emiMonthsSelected = 3;
        emiMonthSelection[0] = true;
        emiMonthSelection[1] = false;
        emiMonthSelection[2] = false;
        setState(() {});
        break;
      case 6:
        emiMonthsSelected = 6;
        emiMonthSelection[0] = false;
        emiMonthSelection[1] = true;
        emiMonthSelection[2] = false;
        setState(() {});
        break;
      case 9:
        emiMonthsSelected = 9;
        emiMonthSelection[0] = false;
        emiMonthSelection[1] = false;
        emiMonthSelection[2] = true;
        setState(() {});
        break;
    }
    Logger().i(emiMonthsSelected);
  }
}
