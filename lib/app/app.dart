import 'package:presto/services/authentication.dart';
import 'package:presto/services/error/error.dart';
import 'package:presto/ui/views/dummyView/dummy_view.dart';
import 'package:presto/ui/views/home/home_view.dart';
import 'package:presto/ui/views/login/login_view.dart';
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
  ],
  dependencies: [
    /// Stacked Services
    Singleton(classType: NavigationService),
    LazySingleton(classType: DialogService),

    /// Custom Micro-Services
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: ErrorHandlingService),
  ],
  logger: StackedLogger(),
)
class App {}