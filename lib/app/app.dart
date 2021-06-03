import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/communityTreeDataHandler.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/notificationDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/services/error/error.dart';
import 'package:presto/services/razorpay.dart';
import 'package:presto/ui/views/dummyView/dummy_view.dart';
import 'package:presto/ui/views/home/home_view.dart';
import 'package:presto/ui/views/login/login_view.dart';
import 'package:presto/ui/views/no-internet/no-internet_view.dart';
import 'package:presto/ui/views/phoneVerification/phoneVerification_view.dart';
import 'package:presto/ui/views/register/register_view.dart';
import 'package:presto/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: DummyView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: PhoneVerificationView),
    MaterialRoute(page: NoInternetView),
  ],
  dependencies: [
    /// Stacked Services
    Singleton(classType: NavigationService),
    LazySingleton(classType: DialogService),

    /// Custom Micro-Services
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: ErrorHandlingService),
    LazySingleton(classType: HiveDatabaseService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: CommunityTreeDataHandler),
    LazySingleton(classType: LimitsDataHandler),
    LazySingleton(classType: NotificationDataHandler),
    LazySingleton(classType: ProfileDataHandler),
    LazySingleton(classType: TransactionsDataHandler),
    LazySingleton(classType: UserDataProvider),
    LazySingleton(classType: TransactionsDataProvider),
    LazySingleton(classType: LimitsDataProvider),
    LazySingleton(classType: RazorpayService),
  ],
  logger: StackedLogger(),
)
class App {}
