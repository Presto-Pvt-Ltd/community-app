import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
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
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: default_big_font_size,
          ),
        ),
        content: Text(
          description,
          style: TextStyle(
            fontSize: default_normal_font_size,
          ),
        ),
        actions: [
          Container(
            height: height * 0.05,
            width: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            child: MaterialButton(
              child: Text(
                buttonTitle,
                style: TextStyle(
                  color: primaryLightColor,
                  fontSize: default_normal_font_size,
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

void showCustomConfirmationDialog({
  required String title,
  required String description,
  String confirmTitle = "OK",
  String cancelTitle = "Cancel",
  required Function confirmCallback,
  required Function cancelCallback,
}) {
  showDialog(
    barrierDismissible: false,
    context: StackedService.navigatorKey!.currentContext!,
    builder: (context) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return AlertDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: default_big_font_size,
          ),
        ),
        content: Text(
          description,
          style: TextStyle(
            fontSize: default_normal_font_size,
          ),
        ),
        actions: [
          Container(
            height: height * 0.05,
            width: width * 0.22,
            color: Colors.white24,
            child: MaterialButton(
              child: Text(
                cancelTitle,
                style: TextStyle(
                  color: primaryLightColor,
                  fontSize: default_normal_font_size,
                ),
              ),
              onPressed: () {
                cancelCallback();
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            height: height * 0.05,
            width: width * 0.22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            child: MaterialButton(
              child: Text(
                confirmTitle,
                style: TextStyle(
                  color: primaryLightColor,
                  fontSize: default_normal_font_size,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                confirmCallback();

                /// ask for upi ID
              },
            ),
          ),
        ],
      );
    },
  );
}
