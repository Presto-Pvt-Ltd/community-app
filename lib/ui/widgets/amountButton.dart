import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';

class AmountButton extends StatelessWidget {
  final String text;
  final Function onTap;
  AmountButton({required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          height: height / 20,
          width: width / 5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(width / 17)),
              color: primaryLightSwatch[900]),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
