// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/authentication.dart';
import '../services/database/dataHandlers/communityTreeDataHandler.dart';
import '../services/database/dataHandlers/limitsDataHandler.dart';
import '../services/database/dataHandlers/notificationDataHandler.dart';
import '../services/database/dataHandlers/profileDataHandler.dart';
import '../services/database/dataHandlers/transactionsDataHandler.dart';
import '../services/database/dataProviders/limits_data_provider.dart';
import '../services/database/dataProviders/transactions_data_provider.dart';
import '../services/database/dataProviders/user_data_provider.dart';
import '../services/database/firestoreBase.dart';
import '../services/database/hiveDatabase.dart';
import '../services/error/error.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerSingleton(NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => ErrorHandlingService());
  locator.registerLazySingleton(() => HiveDatabaseService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => CommunityTreeDataHandler());
  locator.registerLazySingleton(() => LimitsDataHandler());
  locator.registerLazySingleton(() => NotificationDataHandler());
  locator.registerLazySingleton(() => ProfileDataHandler());
  locator.registerLazySingleton(() => TransactionsDataHandler());
  locator.registerLazySingleton(() => UserDataProvider());
  locator.registerLazySingleton(() => TransactionsDataProvider());
  locator.registerLazySingleton(() => LimitsDataProvider());
}
