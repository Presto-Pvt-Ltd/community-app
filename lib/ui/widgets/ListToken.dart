import 'package:flutter/material.dart';

class ListToken extends StatelessWidget {
  final String name;
  final icon;
  final String trailName;

  ListToken({
    required this.name,
    this.icon,
    required this.trailName,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 45.0, right: 45.0),
      child: GestureDetector(
          child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          icon,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: height / 55, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SelectableText(
                      trailName,
                      style: TextStyle(
                        fontSize: height / 45,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5.0,
              width: double.infinity,
              child: Divider(
                color: Colors.black,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
