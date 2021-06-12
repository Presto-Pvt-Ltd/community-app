import 'package:flutter/material.dart';
import 'package:presto/models/enums.dart';

class PaymentCard extends StatefulWidget {
  final String imagePath;
  final Function callBackToAddInTheOptionInTheList;
  final Function callBackToRemoveInTheOptionInTheList;
  final PaymentMethods paymentMethod;

  PaymentCard({
    required this.imagePath,
    required this.paymentMethod,
    required this.callBackToAddInTheOptionInTheList,
    required this.callBackToRemoveInTheOptionInTheList,
  });

  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          // setState(() {
          //   isSelected = !isSelected;
          // });
          setState(() {
            isSelected = !isSelected;
            print(
                " ${isSelected ? "" : "Not"} Selected : ${widget.paymentMethod}");
            if (isSelected)
              widget.callBackToAddInTheOptionInTheList(widget.paymentMethod);
            else
              widget.callBackToRemoveInTheOptionInTheList(widget.paymentMethod);
          });
        },
        child: Container(
          height: width / 5,
          width: width / 5,
          decoration: BoxDecoration(
              // color: isSelected ? Colors.green : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.lightGreen : Colors.white,
                width: 1,
              ),
              image: DecorationImage(
                  image: AssetImage(widget.imagePath), fit: BoxFit.fitWidth)),
        ));
  }
}
