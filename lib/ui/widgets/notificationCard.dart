import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';

Widget notificationCard({
  required String amount,
  required String score,
  required Function handShakeCallBack,
  required double height,
  required double width,
  required Function onTap,
}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontal_padding * 1.5,
        vertical: vertical_padding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 100,
        ),
        child: Container(
          height: height * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: blue98,
            boxShadow: [
              BoxShadow(
                color: authButtonColorLight.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: horizontal_padding,
              right: horizontal_padding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹ $amount',
                      style: TextStyle(
                        fontSize: (default_headers + default_big_font_size) / 2,
                        color: authButtonColorLight,
                      ),
                    ),
                    Text(
                      'Credit Score: $score',
                      style: TextStyle(
                        fontSize: default_normal_font_size,
                        color: primaryLightColor,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => handShakeCallBack(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 40),
                    child: Container(
                      width: width * 0.2,
                      height: height * 0.045,
                      decoration: BoxDecoration(
                        color: primaryLightColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Lend',
                          style: TextStyle(
                            fontSize: default_normal_font_size,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
