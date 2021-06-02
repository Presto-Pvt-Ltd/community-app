import 'package:flutter/material.dart';

class PaymentCard extends StatefulWidget {
  final String imagePath;
  // final Function callBackToAddInTheOptionInTheList;
  // final Function callBackToRemoveInTheOptionInTheList;
  final int index;

  PaymentCard({
    required this.imagePath,
    required this.index,
    // required this.callBackToAddInTheOptionInTheList,
    // required this.callBackToRemoveInTheOptionInTheList,
  });

  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          setState(() {
            isSelected = !isSelected;
          });
          // setState(() {
          //   isSelected = !isSelected;
          //   if (isSelected)
          //     widget.callBackToAddInTheOptionInTheList(widget.index);
          //   else
          //     widget.callBackToRemoveInTheOptionInTheList(widget.index);
          // });
        },
        child: Container(
          height: width / 5,
          width: width / 5,
          decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? Colors.lightGreen : Colors.white,
                  width: width / 200),
              image: DecorationImage(
                  image: AssetImage(widget.imagePath), fit: BoxFit.fitWidth)),
        ));
  }
}
