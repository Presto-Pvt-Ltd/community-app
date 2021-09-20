import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/models/enums.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';

Widget paymentSheet({
  required double height,
  required double width,
  var customNotification,
  var onCompleteCallBack,
  required double amount,
  required double interest,
  var onCancel,
}) {
  return DraggableScrollableSheet(
    initialChildSize: 0.3,
    builder: (context, controller) {
      bool fullPayment = true;
      void setPayment() {
        fullPayment = !fullPayment;
        // print("Toggling : " + fullPayment.toString());
      }

      return Container(
        decoration: BoxDecoration(
          color: backgroundColorLight,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(width / 15),
          ),
        ),
        child: ListView(
          controller: controller,
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

            // Container(
            //   width: width,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       PaymentCard(
            //         imagePath: 'assets/images/paytmbox.webp',
            //         paymentMethod: PaymentMethods.payTm,
            //         callBackToAddInTheOptionInTheList: _addToList,
            //         callBackToRemoveInTheOptionInTheList: _removeFromList,
            //       ),
            //       SizedBox(
            //         width: width / 10,
            //       ),
            //       PaymentCard(
            //         imagePath: 'assets/images/gpaybox.png',
            //         paymentMethod: PaymentMethods.googlePay,
            //         callBackToAddInTheOptionInTheList: _addToList,
            //         callBackToRemoveInTheOptionInTheList: _removeFromList,
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: height / 25,
            // ),
            // Container(
            //   width: width,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       PaymentCard(
            //         imagePath: 'assets/images/paypalbox.png',
            //         paymentMethod: PaymentMethods.paypal,
            //         callBackToAddInTheOptionInTheList: _addToList,
            //         callBackToRemoveInTheOptionInTheList: _removeFromList,
            //       ),
            //       SizedBox(
            //         width: width / 10,
            //       ),
            //       PaymentCard(
            //         imagePath: 'assets/images/phonepaybox.png',
            //         paymentMethod: PaymentMethods.phonePay,
            //         callBackToAddInTheOptionInTheList: _addToList,
            //         callBackToRemoveInTheOptionInTheList: _removeFromList,
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: height / 25,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     PaymentCard(
            //       imagePath: 'assets/images/amazonpaybox.png',
            //       paymentMethod: PaymentMethods.amazonPay,
            //       callBackToAddInTheOptionInTheList: _addToList,
            //       callBackToRemoveInTheOptionInTheList: _removeFromList,
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: height / 25,
            // ),

            // Padding(
            //   padding: EdgeInsets.all(width / 20),
            //   child: InputField(
            //     helperText: "Enter your UPI ID",
            //   ),
            // )
          ],
        ),
      );
    },
  );
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
  @override
  void initState() {
    // TODO: implement initState
    current = DateTime.now();
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
              if (!fullPayment) {
                widget.toggle();
                setState(() {
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
            onTap: widget.amount < 5000
                ? null
                : () {
                    widget.toggle();
                    setState(() {
                      fullPayment = !fullPayment;
                    });
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
                  )
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
          Text(
            'Invoice',
            style: TextStyle(
              color: primaryLightColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
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
                    '\u20B9 ${widget.amount}',
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
                    'Payback Date',
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "${current.day} ${DateFormat.MMMM().format(
                      current.add(
                        Duration(
                          days: locator<LimitsDataProvider>()
                              .transactionLimits!
                              .transactionDefaultsAfterDays,
                        ),
                      ),
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
                    "${widget.interest}%",
                    style: TextStyle(
                      color: primaryLightColor,
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
