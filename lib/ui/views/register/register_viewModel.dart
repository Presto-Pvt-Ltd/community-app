import 'package:firebase_auth/firebase_auth.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends FormViewModel {
  final log = getLogger("RegisterViewModel");
  bool userAcceptedTermsAndConditions = false;
  int validatedFieldsCount = 0;
  bool isRegistrationAsCommunityManager = false;
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  @override
  void setFormStatus() {}

  void onModelReady(bool typeOfRegistration) {
    isRegistrationAsCommunityManager = typeOfRegistration;
    notifyListeners();
  }

  void navigateToLogin() {
    _navigationService.replaceWith(Routes.loginView);
  }

  void changeInCheckBox() {
    userAcceptedTermsAndConditions = !userAcceptedTermsAndConditions;
    notifyListeners();
  }

  /// Email text field arguments
  String? email;
  final Key emailFieldKey = Key("email");
  bool emailValidated = false;
  Future<String?> emailValidator(String? email) async {
    this.email = email;
    if (RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
      caseSensitive: false,
      multiLine: false,
    ).hasMatch(email!.trim())) {
      print("Validation Success");
      return null;
    }
    return "Please enter valid email";
  }

  void onEmailValidationSuccess() {
    emailValidated = true;
    log.v("Ready to go with email");
    notifyListeners();
  }

  void onEmailValidationFailure() {
    emailValidated = false;
    log.v("Not ready to go with email");
    notifyListeners();
  }

  /// Password text field arguments
  String? password;
  final Key passwordFieldKey = Key("password");
  bool passwordValidated = false;
  Future<String?> passwordValidator(String? password) async {
    this.password = password;
    if (password == null || password.trim().length < 6)
      return "Please enter valid password";
    return null;
  }

  void onPasswordValidationSuccess() {
    this.passwordValidated = true;
    log.v("Ready to go with password");
    notifyListeners();
  }

  void onPasswordValidationFailure() {
    this.passwordValidated = false;
    log.v("Not ready to go with password");
    notifyListeners();
  }

  /// Name text field arguments
  String? name;
  final Key nameFieldKey = Key("name");
  bool nameValidated = false;
  Future<String?> nameValidator(String? name) async {
    this.name = name;
    if (name == null || name == "" || name.trim() == "")
      return "Please enter valid name";
    return null;
  }

  void onNameValidationSuccess() {
    this.nameValidated = true;
    log.v("Ready to go with name");
    notifyListeners();
  }

  void onNameValidationFailure() {
    this.nameValidated = false;
    log.v("Not ready to go with name");
    notifyListeners();
  }

  /// Contact text field arguments
  String? contact;
  final Key contactFieldKey = Key("contact");
  bool contactValidated = false;
  Future<String?> contactValidator(String? contact) async {
    this.contact = contact;
    if (contact == null || contact.trim().length != 10)
      return "Please enter valid contact";
    return null;
  }

  void onContactValidationSuccess() {
    this.contactValidated = true;
    log.v("Ready to go with contact");
    notifyListeners();
  }

  void onContactValidationFailure() {
    this.contactValidated = false;
    log.v("Not ready to go with contact");
    notifyListeners();
  }

  /// Password text field arguments
  String? referralCodeOrCommunityName;
  final Key referralCodeOrCommunityNameFieldKey =
      Key("referralCodeOrCommunityName");
  bool referralCodeOrCommunityNameValidated = false;
  Future<String?> referralCodeOrCommunityNameValidator(
      String? referralCodeOrCommunityName) async {
    this.referralCodeOrCommunityName = referralCodeOrCommunityName;

    /// check database here for existing referral codes
    if (referralCodeOrCommunityName == null ||
        referralCodeOrCommunityName.trim().length < 6)
      return "Please enter valid referralCodeOrCommunityName";
    return null;
  }

  void onReferralCodeOrCommunityNameValidationSuccess() {
    this.referralCodeOrCommunityNameValidated = true;
    log.v("Ready to go with referralCodeOrCommunityName");
    notifyListeners();
  }

  void onReferralCodeOrCommunityNameValidationFailure() {
    this.referralCodeOrCommunityNameValidated = false;
    log.v("Not ready to go with referralCodeOrCommunityName");
    notifyListeners();
  }

  Future<void> proceedRegistration() async {
    setBusy(true);
    if (nameValidated &&
        emailValidated &&
        contactValidated &&
        passwordValidated &&
        referralCodeOrCommunityNameValidated &&
        userAcceptedTermsAndConditions) {
      log.v("Proceeding for registration");
      log.v("Attempting Registration for :");
      log.v(name);
      log.v(email);
      log.v(contact);
      log.v(password);
      log.v(referralCodeOrCommunityName);
      await _authenticationService
          .registerNewUser(
        email!.trim(),
        password!.trim(),
      )
          .then((user) {
        log.v("Registration attempted");
        if (user == null) {
          log.e("Error in registration");
          return;
        } else {
          log.v("Going for");
          _navigationService.navigateTo(
            Routes.phoneVerificationView,
            arguments: PhoneVerificationViewArguments(
              phoneNumber: '+91' + contact!.trim(),
            ),
          );
        }
        setBusy(false);
      });

      // _navigationService.navigateTo(
      //   Routes.phoneVerificationView,
      //   arguments: PhoneVerificationViewArguments(
      //     phoneNumber: '+91' + contact.text.trim(),
      //   ),
      // );
    } else {
      setBusy(false);
      print(
          "$nameValidated $emailValidated $contactValidated $passwordValidated $referralCodeOrCommunityNameValidated $userAcceptedTermsAndConditions");
      _errorHandlingService.handleError(
        error: "Please fill details appropriately.",
      );
    }
  }
}
