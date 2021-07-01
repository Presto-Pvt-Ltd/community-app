import 'package:flutter/material.dart';
import 'package:presto/models/enums.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/paymentCard.dart';

Widget paymentSheet({
  var height,
  var width,
  var customNotification,
  var onCompleteCallBack,
  var onCancel,
}) {
  List<PaymentMethods> paymentMethods = <PaymentMethods>[];
  _addToList(PaymentMethods method) {
    if (!paymentMethods.contains(method)) {
      paymentMethods.add(method);
    }
  }

  _removeFromList(PaymentMethods method) {
    if (paymentMethods.contains(method)) {
      paymentMethods.remove(method);
    }
  }

  return DraggableScrollableSheet(
    initialChildSize: 0.7,
    builder: (context, controller) {
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
                              onCompleteCallBack(paymentMethods);
                            else
                              onCompleteCallBack(
                                  customNotification, paymentMethods);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: height / 45,
                          ),
                        )),
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
                            color: Colors.blue,
                            fontSize: height / 45,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 45,
            ),
            Padding(
              padding: EdgeInsets.all(width / 20),
              child: Text(
                'We will pay you through your contact number, please enter your UPI ID',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: height / 25,
            ),
            Container(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PaymentCard(
                    imagePath: 'assets/images/paytmbox.webp',
                    paymentMethod: PaymentMethods.payTm,
                    callBackToAddInTheOptionInTheList: _addToList,
                    callBackToRemoveInTheOptionInTheList: _removeFromList,
                  ),
                  SizedBox(
                    width: width / 10,
                  ),
                  PaymentCard(
                    imagePath: 'assets/images/gpaybox.png',
                    paymentMethod: PaymentMethods.googlePay,
                    callBackToAddInTheOptionInTheList: _addToList,
                    callBackToRemoveInTheOptionInTheList: _removeFromList,
                  )
                ],
              ),
            ),
            SizedBox(
              height: height / 25,
            ),
            Container(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PaymentCard(
                    imagePath: 'assets/images/paypalbox.png',
                    paymentMethod: PaymentMethods.paypal,
                    callBackToAddInTheOptionInTheList: _addToList,
                    callBackToRemoveInTheOptionInTheList: _removeFromList,
                  ),
                  SizedBox(
                    width: width / 10,
                  ),
                  PaymentCard(
                    imagePath: 'assets/images/phonepaybox.png',
                    paymentMethod: PaymentMethods.phonePay,
                    callBackToAddInTheOptionInTheList: _addToList,
                    callBackToRemoveInTheOptionInTheList: _removeFromList,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height / 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaymentCard(
                  imagePath: 'assets/images/amazonpaybox.png',
                  paymentMethod: PaymentMethods.amazonPay,
                  callBackToAddInTheOptionInTheList: _addToList,
                  callBackToRemoveInTheOptionInTheList: _removeFromList,
                ),
              ],
            ),
            SizedBox(
              height: height / 25,
            ),
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
