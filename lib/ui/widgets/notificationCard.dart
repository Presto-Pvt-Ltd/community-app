import 'package:flutter/material.dart';

Widget notificationCard(
    {required String amount,
    required String score,
    required Function handShakeCallBack,
    required double height,
    required double width,
    required Function onTap}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: width * 0.02),
      child: Container(
        height: height * 0.135,
        child: Card(
          elevation: 5,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, top: width * 0.01, right: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ $amount',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      // color: textColor,
                    ),
                  ),
                  Text(
                    'Credit Score: $score',
                    style: TextStyle(fontSize: width * 0.05),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Do you want to Lend?',
                        style: TextStyle(fontSize: width * 0.05),
                      ),
                      GestureDetector(
                        onTap: () => handShakeCallBack(),
                        child: Container(
                          width: width * 0.1,
                          color: Colors.green,
                          child: Center(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  fontSize: width * 0.05, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
