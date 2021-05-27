import 'package:presto/app/app.logger.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataHandlers/transactionsDataHandler.dart';
import 'package:presto/services/database/dataProviders/transactions_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/authentication.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final log = getLogger("HomeViewModel");
  late String uid;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ProfileDataHandler _profileDataHandler = locator<ProfileDataHandler>();
  final LimitsDataHandler _limitsDataHandler = locator<LimitsDataHandler>();
  final TransactionsDataHandler _transactionsDataHandler =
      locator<TransactionsDataHandler>();

  /// Data providers
  final UserDataProvider _userDataProvider = locator<UserDataProvider>();
  final TransactionsDataProvider _transactionsDataProvider =
      locator<TransactionsDataProvider>();

  late Stream<List<String>> _transactionIdListAsStream;

  Future<void> onModelReady(int index) async {
    /// Getting initial data:
    try {
      uid = _authenticationService.uid!;
      _transactionIdListAsStream = _userDataProvider.transactionIdAsStream;
      _transactionIdListAsStream.listen((gotIds) {
        if (gotIds.length != 0) {
          _transactionsDataProvider.loadData(transactionIds: gotIds);
        }
      });
      ProfileDocument.values.forEach((typeOfDocument) {
        _userDataProvider.loadData(uid: uid, typeOfDocument: typeOfDocument);
      });
    } catch (e) {
      _errorHandlingService.handleError(error: e);
    }

    Future.delayed(Duration(microseconds: 0), () {
      setIndex(index);
    });
  }

  void slideChangeViews(bool isReverse) {
    if (isReverse == false) {
      // ignore: unnecessary_statements
      currentIndex != 0 ? setIndex(currentIndex - 1) : null;
      notifyListeners();
    } else {
      // ignore: unnecessary_statements
      currentIndex != 3 ? setIndex(currentIndex + 1) : null;
      notifyListeners();
    }
  }

  void goToLoginScreen() {
    _authenticationService.auth.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
