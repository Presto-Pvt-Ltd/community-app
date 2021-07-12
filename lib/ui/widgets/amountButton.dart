import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';

class AmountButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color? buttonColor;
  AmountButton({required this.text, required this.onTap, this.buttonColor});
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: buttonColor ?? primaryLightColor,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: default_normal_font_size,
                color: authButtonColorLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
