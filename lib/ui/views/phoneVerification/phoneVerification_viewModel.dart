import 'package:firebase_auth/firebase_auth.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:timer_count_down/timer_controller.dart';

class PhoneVerificationViewModel extends BaseViewModel {
  final log = getLogger("PhoneVerificationViewModel");
  CountdownController counterController = CountdownController();
  late String phoneNumber;
  late String verificationId;
  PhoneAuthCredential? _phoneAuthCredential;
  int? resendToken;
  bool otpSent = false;
  String? otp;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final UserDataProvider _userDataProvider = locator<UserDataProvider>();

  void onModelReady(String phoneNumber) {
    _userDataProvider.loadData(
      uid: _authenticationService.uid!,
      typeOfDocument: ProfileDocument.userPersonalData,
    );
    _userDataProvider.loadData(
      uid: _authenticationService.uid!,
      typeOfDocument: ProfileDocument.userNotificationToken,
    );
    _userDataProvider.loadData(
      uid: _authenticationService.uid!,
      typeOfDocument: ProfileDocument.userPlatformData,
    );
    _userDataProvider.loadData(
      uid: _authenticationService.uid!,
      typeOfDocument: ProfileDocument.userPlatformRatings,
    );
    _userDataProvider.loadData(
      uid: _authenticationService.uid!,
      typeOfDocument: ProfileDocument.userTransactionsData,
    );

    log.d("Setting Phone Number : $phoneNumber");
    this.phoneNumber = phoneNumber;
    Future.delayed(Duration(microseconds: 0), () {
      setBusy(true);
      counterController.pause();
      notifyListeners();
    });
    verifyPhoneNumber();
  }

  void verifyPhoneNumber() {
    try {
      Future.delayed(Duration(microseconds: 0), () {
        log.d("Attempting phone verification");
        otpSent = false;
        otp = null;
        counterController.restart();
        counterController.pause();
        // _authenticationService.linkWithPhoneDirect(phoneNumber);
        _authenticationService.auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          forceResendingToken: resendToken,
        );
        notifyListeners();
      });
    } catch (e) {
      log.e("Some error occurred while attempting phone verification");
      _errorHandlingService.handleError(error: e.toString());
    }
  }

  void verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    _phoneAuthCredential = phoneAuthCredential;
    linkPhone();
    log.d("Verification Successful with auto retrieve !!");
  }

  void verificationFailed(FirebaseAuthException exception) {
    log.e("Verification failed !!");
    _errorHandlingService.handleError(error: exception.message);
  }

  void codeSent(String code, int? forceResendToken) {
    setBusy(false);
    resendToken = forceResendToken;
    verificationId = code;
    otpSent = true;
    counterController.resume();
    log.d("OTP Sent \n Verification Id: $code");
    notifyListeners();
  }

  void codeAutoRetrievalTimeout(String code) {
    verificationId = code;
    log.d("Code Auto Retrieval Time-out \n Verification Id: $code");
  }

  Future<void> verifyOtp() async {
    try {
      setBusy(true);
      log.d("Attempting manual otp verification : code: $otp");
      _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp!,
      );
      linkPhone();
    } catch (e) {
      setBusy(false);
      print("Some error here");
      _errorHandlingService.handleError(error: e.toString());
    }
  }

  Future<void> linkPhone() async {
    await _authenticationService
        .linkPhoneNumberWithEmail(_phoneAuthCredential!)
        .then((user) {
      log.d(
          "Phone and email linking process returned : ${user == null ? "failure" : "success"} ");
      if (user == null) {
        setBusy(false);
        log.d("Invalid Otp was Entered");
      } else {
        locator<ProfileDataHandler>().updateProfileData(
          data: _userDataProvider.personalData!.toJson(),
          typeOfDocument: ProfileDocument.userPersonalData,
          userId: user.uid,
          toLocalDatabase: false,
        );
        locator<ProfileDataHandler>().updateProfileData(
          data: _userDataProvider.platformData!.toJson(),
          typeOfDocument: ProfileDocument.userPlatformData,
          userId: user.uid,
          toLocalDatabase: false,
        );
        locator<ProfileDataHandler>().updateProfileData(
          data: _userDataProvider.platformRatingsData!.toJson(),
          typeOfDocument: ProfileDocument.userPlatformRatings,
          userId: user.uid,
          toLocalDatabase: false,
        );
        locator<ProfileDataHandler>().updateProfileData(
          data: _userDataProvider.transactionData!.toJson(),
          typeOfDocument: ProfileDocument.userTransactionsData,
          userId: user.uid,
          toLocalDatabase: false,
        );
        locator<ProfileDataHandler>().updateProfileData(
          data: _userDataProvider.token!.toJson(),
          typeOfDocument: ProfileDocument.userNotificationToken,
          userId: user.uid,
          toLocalDatabase: false,
        );
        _navigationService.clearStackAndShow(Routes.homeView);
      }
    });
  }

  void onOtpFieldChange(String code) {
    otp = code;
  }

  void onOtpFieldComplete(String code) {
    print("otp completed");
    verifyOtp();
  }
}
