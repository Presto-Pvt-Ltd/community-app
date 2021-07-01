import 'package:flutter/cupertino.dart';
import 'package:presto/ui/widgets/dialogBox.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/authentication.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final log = getLogger("ForgotPasswordView");
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  String finalEmail = '';

  final TextEditingController email = TextEditingController();
  final Key emailFieldKey = Key("email");
  bool emailValidated = false;
  void pop() {
    locator<NavigationService>().back();
  }

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

  void onPressingGetLink() async {
    setBusy(true);
    bool result =
        await _authenticationService.sendResetPasswordLink(email: finalEmail);
    setBusy(false);
    if (result) {
      locator<NavigationService>().back();
      showCustomDialog(
        title: "Reset Link Sent.",
        description:
            "Password reset link has been sent to your email account. Please reset your password and try logging in.",
        buttonTitle: "OK",
      );
    }
  }

  void onModelReady() {
    log.v("Current Route: ${_navigationService.currentRoute}");
  }
}
