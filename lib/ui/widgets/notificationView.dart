import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
Widget notificationView(var height, var width){
  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: height / 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: width / 5.5,
              child: Text('Local Icon',
                  style: TextStyle(
                      color: Colors.white, fontSize: 25.0)),
            ),
            SizedBox(
              width: width / 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Creditworthy Score: 5.0',
                  style: TextStyle(
                    fontSize: height / 45,
                  ),
                ),
                Text(
                  'Mode of payment: PayTM',
                  style: TextStyle(
                    fontSize: height / 45,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: height / 15,
        ),
        Padding(
          padding: EdgeInsets.only(left: width / 25),
          child: Text(
            //'Amount Requested : ${widget.notification.amount}',
            'Amount Requested : 20',
            style: TextStyle(
                fontSize: height / 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: width / 2,
          child: Divider(
            color: primaryColor,
            thickness: height / 100,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: width / 20, top: width / 19),
          child: Container(
            width: width / 2,
            child: Text(
              'A fellow RVCE\'ian is calling...',
              style: TextStyle(
                fontSize: height / 27,
              ),
            ),
          ),
        ),
        SizedBox(
          height: height / 4,
        ),
        Row(
          children: [
            GestureDetector(
              child: Container(
                width: width / 2,
                height: height / 15,
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height / 45),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                width: width / 2,
                height: height / 15,
                color: Colors.red,
                child: Center(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height / 45),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}