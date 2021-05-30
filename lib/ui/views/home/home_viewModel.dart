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
  late String referralCode;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final NavigationService _navigationService = locator<NavigationService>();

  /// Data providers
  final UserDataProvider _userDataProvider = locator<UserDataProvider>();
  final TransactionsDataProvider _transactionsDataProvider =
      locator<TransactionsDataProvider>();

  late Stream<List<String>> _transactionIdListAsStream;

  Future<void> onModelReady(int index) async {
    /// Getting initial data:
    Future.delayed(Duration(seconds: 0), () {
      setIndex(index);
      try {
        referralCode = _authenticationService.referralCode!;

        /// Trying to load data
        _userDataProvider
            .loadData(
          referralCode: referralCode,
          typeOfDocument: ProfileDocument.userPersonalData,
        )
            .then((value) {
          log.wtf(value);
          if (value) {
            _userDataProvider
                .loadData(
                    referralCode: referralCode,
                    typeOfDocument: ProfileDocument.userNotificationToken)
                .then((value) {
              if (value) {
                _userDataProvider
                    .loadData(
                        referralCode: referralCode,
                        typeOfDocument: ProfileDocument.userTransactionsData)
                    .then((value) {
                  if (value) {
                    _userDataProvider
                        .loadData(
                            referralCode: referralCode,
                            typeOfDocument: ProfileDocument.userPlatformData)
                        .then((value) {
                      if (value) {
                        _userDataProvider.loadData(
                            referralCode: referralCode,
                            typeOfDocument:
                                ProfileDocument.userPlatformRatings);
                        _transactionIdListAsStream =
                            _userDataProvider.transactionIdAsStream;
                        _transactionIdListAsStream.listen((gotIds) {
                          if (gotIds.length != 0) {
                            _transactionsDataProvider.loadData(
                              transactionIds: gotIds,
                            );
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      } catch (e) {
        log.e("There was error here");
        _errorHandlingService.handleError(error: e);
      }
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
