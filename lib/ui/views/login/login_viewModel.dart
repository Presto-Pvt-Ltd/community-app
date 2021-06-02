import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger("LoginViewModel");
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  String finalEmail = '';
  String finalPassword = '';

  void navigateToRegister({bool isRegistrationAsCommunityManager = false}) {
    log.v(
        "Going to registration page for : ${isRegistrationAsCommunityManager ? "Community Manager" : "Regular User"}");
    _navigationService.replaceWith(
      Routes.registerView,
      arguments: RegisterViewArguments(
        isRegistrationAsCommunityManager: isRegistrationAsCommunityManager,
      ),
    );
  }

  final TextEditingController email = TextEditingController();
  final Key emailFieldKey = Key("email");
  bool emailValidated = false;
  Future<String?> emailValidator(String? email) async {
    if (RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
      caseSensitive: false,
      multiLine: false,
    ).hasMatch(email!.trim())) {
      print("Validation Success");
      finalEmail = email;
      return null;
    }
    return "Please enter valid email";
  }

  void onEmailValidationSuccess() {
    log.v("Email Verification Success");
    emailValidated = true;
    print("Ready to go with email");
  }

  void onEmailValidationFailure() {
    log.v("Email Verification Failure");
    emailValidated = false;
    print("Not ready to go with email");
  }

  final TextEditingController password = TextEditingController();
  final Key passwordFieldKey = Key("password");
  bool passwordValidated = false;
  Future<String?> passwordValidator(String? password) async {
    if (password == null || password.trim().length < 6)
      return "Please enter valid password";
    finalPassword = password;
    return null;
  }

  void onPasswordValidationSuccess() {
    passwordValidated = true;
    log.v("Ready to go with password");
  }

  void onPasswordValidationFailure() {
    passwordValidated = false;
    log.v("Not ready to go with password");
  }

  Future<void> proceedLogin() async {
    try {
      setBusy(true);
      if (emailValidated && passwordValidated) {
        log.v("Proceeding for registration");
        log.v("Attempting Registration for :");
        log.v('Email-' + finalEmail);
        log.v('pass-' + finalPassword);
        await _authenticationService
            .signInViaEmailAndPassword(
          finalEmail,
          finalPassword,
        )
            .then((user) {
          log.v("Sign-in attempted");
          if (user == null) {
            log.e("Error in Sign-in");
            setBusy(false);
            return;
          } else {
            log.v("Going for");
            locator<HiveDatabaseService>().openBox(uid: user.uid);
            _navigationService.clearStackAndShow(
              Routes.homeView,
              arguments: HomeViewArguments(index: 2),
            );
          }
          setBusy(false);
        });
      } else {
        setBusy(false);
        print("$emailValidated  $passwordValidated");
        log.e("There was error here");
        _errorHandlingService.handleError(
          error: "Please fill details appropriately.",
        );
      }
    } catch (e) {
      setBusy(false);
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
    }
  }

  void onModelReady() {
    log.v("Current Route: ${_navigationService.currentRoute}");
  }

  @override
  void setFormStatus() {}
}
