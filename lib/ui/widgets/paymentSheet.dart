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
      child: ListView(
        controller: controller,
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
          Center(
            child: Text(
              'Choose Your Mode Of Payment',
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
                PaymentCard(imagePath: 'assets/images/paytmbox.webp',index: 0,),
                SizedBox(width: width/10,),
                PaymentCard(imagePath: 'assets/images/gpaybox.png', index: 1,)
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
                PaymentCard(imagePath: 'assets/images/paypalbox.png', index: 2,),
                SizedBox(width: width/10,),
                PaymentCard(imagePath: 'assets/images/phonepaybox.png', index: 3,),
              ],
            ),
          ),
          SizedBox(
            height: height/25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaymentCard(imagePath: 'assets/images/amazonpaybox.png', index: 4,),
            ],
          ),
          SizedBox(
            height: height/25,
          ),
          Padding(
            padding: EdgeInsets.all(width/20),
            child: InputField(
              helperText: "Enter your UPI ID",
            ),
          )
        ],
      ),
    ),
  );
}