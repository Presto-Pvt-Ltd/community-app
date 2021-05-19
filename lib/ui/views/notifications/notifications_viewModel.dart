import 'package:flutter/cupertino.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.router.dart';
import '../../../services/authentication.dart';
import '';

class NotificationsViewModel extends BaseViewModel {
  final log = getLogger("NotificationsViewModel");
  String title = "I am Notifications";
  late void Function(bool) callback;

  void onModelReady(void Function(bool) callback){
    this.callback = callback;
  }
}
