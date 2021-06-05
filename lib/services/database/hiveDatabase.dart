import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/services/error/error.dart';

class HiveDatabaseService {
  final log = getLogger("HiveDatabaseService");
  bool isBoxOpened = false;
  late Box box;
  ErrorHandlingService _errorHandlingService = locator<ErrorHandlingService>();

  Future<void> openBox({required String uid}) async {
    await Hive.openBox(uid).then((value) {
      box = value;
      isBoxOpened = true;
    });
  }

  Future<bool> deleteBox({required String uid}) async {
    try {
      return Hive.deleteBoxFromDisk(uid).then((value) => true);
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }

  dynamic getDataFromHive({required String key}) {
    if (isBoxOpened)
      return box.get(key);
    else
      return throw Exception("Reading from your storage");
  }

  Map<String, dynamic> getMapDataFromHive({required String key}) {
    // box.keys.forEach((e) {
    //   //log.wtf(box.get(e));
    // });
    if (isBoxOpened) {
      //log.wtf(box.get(key));
      //log.wtf(Map<String, dynamic>.from(box.get(key)).runtimeType);
      //return <String, dynamic>{};
      try {
        return Map<String, dynamic>.from(
          Map<String, dynamic>.from(
            box.get(key, defaultValue: <String, dynamic>{}),
          ),
        );
      } catch (e) {
        log.e(e.toString());
        return <String, dynamic>{};
      }
    } else
      return throw Exception("Reading from your storage");
  }

  Future<bool> setDataInHive({
    required dynamic data,
    required String key,
  }) async {
    try {
      if (isBoxOpened)
        return await box.put(key, data).then((value) => true);
      else
        return throw false;
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }
}
