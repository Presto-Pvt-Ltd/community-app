import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:stacked_services/stacked_services.dart';

void showCustomDialog({
  required String title,
  required String description,
  String buttonTitle = "OK",
}) {
  showDialog(
    barrierDismissible: false,
    context: StackedService.navigatorKey!.currentContext!,
    builder: (context) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          Container(
            height: height * 0.05,
            width: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            child: MaterialButton(
              color: primaryColor,
              child: Text(
                buttonTitle,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
