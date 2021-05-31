import 'package:flutter/material.dart';
import 'package:presto/ui/widgets/inputTextField.dart';
import 'package:presto/ui/widgets/paymentCard.dart';
Widget paymentSheet(var height, var width) {
  return DraggableScrollableSheet(
    initialChildSize: 0.9,
    builder: (context,controller) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(width/15))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: height / 45,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  //model.returnTap();
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: height/45,
                  ),
                )
              ),
            ),
          ),
          SizedBox(
            height: height / 45,
          ),
          Text(
            'Choose Your Mode Of Payment',
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          SizedBox(
            height: height / 25,
          ),
          Container(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaymentCard(imagePath: 'assets/images/paytmbox.webp'),
                SizedBox(width: width/10,),
                PaymentCard(imagePath: 'assets/images/gpaybox.png')
              ],
            ),
          ),
          SizedBox(
            height: height/25,
          ),
          Container(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaymentCard(imagePath: 'assets/images/paypalbox.png'),
                SizedBox(width: width/15,),
                PaymentCard(imagePath: 'assets/images/phonepaybox.png'),
              ],
            ),
          ),
          SizedBox(
            height: height/25,
          ),
          PaymentCard(imagePath: 'assets/images/amazonpaybox.png'),
          SizedBox(
            height: height/25,
          ),
          InputField(
            helperText: "Enter your UPI ID",
          )
        ],
      ),
    ),
  );
}