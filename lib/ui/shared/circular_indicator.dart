import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

Widget loader = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(primaryLightColor),
);
