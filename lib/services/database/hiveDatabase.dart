import 'package:hive/hive.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/error/error.dart';

class HiveDatabaseService {
  final log = getLogger("HiveDatabaseService");

  var box = Hive.box('Local_Database');
  ErrorHandlingService _errorHandlingService = locator<ErrorHandlingService>();

  dynamic getDataFromHive({required String key}) {
    return box.get(key);
  }

  List<Map<String, dynamic>> getListFromHive({required String key}){
    return box.get(key);
  }

  Map<String,dynamic> getMapDataFromHive({required String key}) {
    return box.get(key, defaultValue: <String,dynamic>{});
  }

  Future<bool> setDataInHive(
      {required dynamic data, required String key}) async {
    try {
      return await box.put(key, data).then((value) => true);
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }
}
