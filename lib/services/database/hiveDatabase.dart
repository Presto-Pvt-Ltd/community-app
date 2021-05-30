import 'package:hive/hive.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
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
      log.wtf('Box is opened $uid');
    });
  }

  Future<bool> deleteBox({required String uid}) async {
    return Hive.openBox(uid).then((box) {
      try {
        return box.deleteFromDisk().then((value) => true);
      } catch (e) {
        _errorHandlingService.handleError(error: e);
        return false;
      }
    });
  }

  dynamic getDataFromHive({required String key}) {
    if (isBoxOpened)
      return box.get(key);
    else
      return throw Exception("Reading from your storage");
  }

  List<CustomTransaction> getListFromHive({required String key}) {
    if (isBoxOpened)
      return box.get(key,
          defaultValue: <CustomTransaction>[]).cast<List<CustomTransaction>>();
    else
      return throw Exception("Reading from your storage");
  }

  Map<String, dynamic> getMapDataFromHive({required String key}) {
    if (isBoxOpened)
      return box.get(key, defaultValue: <String, dynamic>{});
    else
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
        return throw Exception("Reading from your storage");
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }
}
