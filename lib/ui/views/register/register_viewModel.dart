import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/models/enums.dart';
import 'package:presto/models/user/notification_data_model.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/services/error/error.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:platform_device_id/platform_device_id.dart';

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
    getDeviceId();
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
  String? parentCommunity;
  final TextEditingController referralCodeController = TextEditingController();
  final Key referralCodeOrCommunityNameFieldKey =
      Key("referralCodeOrCommunityName");
  bool referralCodeOrCommunityNameValidated = false;
  Future<String?> referralCodeOrCommunityNameValidator(
      String? referralCodeOrCommunityName) async {
    try {
      this.referralCodeOrCommunityName = referralCodeOrCommunityName;

      /// check database here for existing referral codes
      if (referralCodeOrCommunityName != null ||
          referralCodeOrCommunityName!.trim().length < 6) {
        if (isRegistrationAsCommunityManager) {
          log.d("Going for validation");

          final QuerySnapshot querySnapshot =
              await locator<FirestoreService>().checkForCollectionExistence(
            community: referralCodeOrCommunityName.trim(),
          );
          if (querySnapshot.docs.isEmpty) {
            return null;
          } else {
            return "Entered Community Name is either taken or not valid";
          }
        } else {
          final DocumentSnapshot documentSnapshot =
              await locator<FirestoreService>().checkForUserDocumentExistence(
                  docId: referralCodeOrCommunityName.trim());
          if (documentSnapshot.exists) {
            Map<String, dynamic> parent =
                await locator<ProfileDataHandler>().getProfileData(
              typeOfData: ProfileDocument.userPersonalData,
              userId: referralCodeOrCommunityName.trim(),
              fromLocalDatabase: false,
            );
            parentCommunity = PersonalData.fromJson(parent).community;
          } else
            return "Please enter valid Referral Code";
        }
      }
    } catch (e) {
      setBusy(false);
      _errorHandlingService.handleError(error: e);
    }
  }

  // void onReferralCodeOrCommunityNameValidationSuccess() {
  //   this.referralCodeOrCommunityNameValidated = true;
  //   log.v("Ready to go with referralCodeOrCommunityName");
  //   notifyListeners();
  // }
  //
  // void onReferralCodeOrCommunityNameValidationFailure() {
  //   this.referralCodeOrCommunityNameValidated = false;
  //   log.v("Not ready to go with referralCodeOrCommunityName");
  //   notifyListeners();
  // }

  String? deviceId;
  bool gotDeviceId = false;

  Future<void> getDeviceId() async {
    try {
      print("Getting Device Id");
      deviceId = await PlatformDeviceId.getDeviceId;
      gotDeviceId = true;
      print("Got Device Id");
    } catch (e) {
      _errorHandlingService.handleError(error: e);
    }
  }

  Future<void> proceedRegistration() async {
    try {
      setBusy(true);
      referralCodeOrCommunityName = referralCodeController.text.trim();
      log.wtf(referralCodeController.text);
      if (referralCodeOrCommunityName == null) {
        setBusy(false);
        _errorHandlingService.handleError(
            error: "Please Enter valid values in input fields");
        return;
      }
      referralCodeOrCommunityNameValidator(referralCodeOrCommunityName)
          .then((value) async {
        if (value == null) {
          if (nameValidated &&
              emailValidated &&
              contactValidated &&
              passwordValidated &&
              userAcceptedTermsAndConditions &&
              gotDeviceId) {
            log.v("Proceeding for registration");
            log.v("Attempting Registration for :");
            log.v(name);
            log.v(email);
            log.v(contact);
            log.v(password);
            log.v(referralCodeOrCommunityName);
            log.v(deviceId);
            await _authenticationService
                .registerNewUser(
              email!.trim(),
              password!.trim(),
            )
                .then((user) {
              log.v("Registration attempted");
              if (user == null) {
                setBusy(false);
                log.e("Error in registration");
                throw Exception("Error");
              } else {
                log.v("Going for");
                assert(isRegistrationAsCommunityManager
                    ? (referralCodeOrCommunityName != null)
                    : (parentCommunity != null));
                String referralCode =
                    name!.substring(0, 3) + Random().nextInt(999999).toString();
                user.updateProfile(displayName: referralCode);
                locator<HiveDatabaseService>()
                    .openBox(uid: user.uid)
                    .then((value) {
                  /// Add the dummy data here in local storage here
                  /// depending on new user sign up register as community manager
                  /// Or regular user
                  PersonalData personalData = PersonalData(
                    name: name!,
                    email: email!,
                    contact: contact!,
                    password: password!,
                    deviceId: deviceId!,
                    referralId: referralCodeOrCommunityName!,
                    community: isRegistrationAsCommunityManager
                        ? referralCodeOrCommunityName!
                        : parentCommunity!,
                  );
                  locator<ProfileDataHandler>().updateProfileData(
                    data: personalData.toJson(),
                    typeOfDocument: ProfileDocument.userPersonalData,
                    userId: user.uid,
                    toLocalDatabase: true,
                  );
                  PlatformData platformData = PlatformData(
                    referralCode: referralCode,
                    referredBy: isRegistrationAsCommunityManager
                        ? "CM"
                        : referralCodeOrCommunityName!,
                    referredTo: <String>[],
                    isCommunityManager: isRegistrationAsCommunityManager,
                  );
                  locator<ProfileDataHandler>().updateProfileData(
                    data: platformData.toJson(),
                    typeOfDocument: ProfileDocument.userPlatformData,
                    userId: user.uid,
                    toLocalDatabase: true,
                  );
                  PlatformRatings platformRatings = PlatformRatings(
                    communityScore: 0.0,
                    personalScore: 5,
                    prestoCoins: 0,
                  );
                  locator<ProfileDataHandler>().updateProfileData(
                    data: platformRatings.toJson(),
                    typeOfDocument: ProfileDocument.userPlatformRatings,
                    userId: user.uid,
                    toLocalDatabase: true,
                  );
                  TransactionData transactionData = TransactionData(
                    paymentMethodsUsed: <String, dynamic>{
                      paymentMethodsToString(PaymentMethods.creditCard): 0,
                      paymentMethodsToString(PaymentMethods.debitCard): 0,
                      paymentMethodsToString(PaymentMethods.googlePay): 0,
                      paymentMethodsToString(PaymentMethods.payTm): 0,
                      paymentMethodsToString(PaymentMethods.upi): 0,
                    },
                    transactionIds: <String>[],
                    totalBorrowed: 0,
                    totalLent: 0,
                    activeTransactions: <String>[],
                  );
                  locator<ProfileDataHandler>().updateProfileData(
                    data: transactionData.toJson(),
                    typeOfDocument: ProfileDocument.userTransactionsData,
                    userId: user.uid,
                    toLocalDatabase: true,
                  );
                  FirebaseMessaging.instance.getToken().then((newToken) {
                    NotificationToken token =
                        NotificationToken(notificationToken: newToken!);
                    setBusy(false);
                    locator<ProfileDataHandler>().updateProfileData(
                      data: token.toJson(),
                      typeOfDocument: ProfileDocument.userNotificationToken,
                      userId: user.uid,
                      toLocalDatabase: true,
                    );
                    _navigationService.navigateTo(
                      Routes.phoneVerificationView,
                      arguments: PhoneVerificationViewArguments(
                        phoneNumber: '+91' + contact!.trim(),
                      ),
                    );
                  });
                });
              }
            });
          } else {
            setBusy(false);
            print(
              "$nameValidated $emailValidated $contactValidated $passwordValidated $referralCodeOrCommunityNameValidated $userAcceptedTermsAndConditions",
            );
            _errorHandlingService.handleError(
              error: "Please fill details appropriately.",
            );
          }
        }
        setBusy(false);
        _errorHandlingService.handleError(
          error: isRegistrationAsCommunityManager
              ? "Entered Community Name is either taken or invalid"
              : "Please enter valid Referral Code",
        );
      });
    } catch (e) {
      setBusy(false);
      _errorHandlingService.handleError(error: e);
    }
    // if (nameValidated &&
    //     emailValidated &&
    //     contactValidated &&
    //     passwordValidated &&
    //     userAcceptedTermsAndConditions &&
    //     gotDeviceId) {
    //   log.v("Proceeding for registration");
    //   log.v("Attempting Registration for :");
    //   log.v(name);
    //   log.v(email);
    //   log.v(contact);
    //   log.v(password);
    //   log.v(referralCodeOrCommunityName);
    //   log.v(deviceId);
    //   await _authenticationService
    //       .registerNewUser(
    //     email!.trim(),
    //     password!.trim(),
    //   )
    //       .then((user) {
    //     log.v("Registration attempted");
    //     if (user == null) {
    //       setBusy(false);
    //       log.e("Error in registration");
    //       throw Exception("Error");
    //     } else {
    //       log.v("Going for");
    //       assert(isRegistrationAsCommunityManager
    //           ? (referralCodeOrCommunityName != null)
    //           : (parentCommunity != null));
    //       String referralCode =
    //           name!.substring(0, 3) + Random().nextInt(999999).toString();
    //       user.updateProfile(displayName: referralCode);
    //       locator<HiveDatabaseService>().openBox(uid: user.uid).then((value) {
    //         /// Add the dummy data here in local storage here
    //         /// depending on new user sign up register as community manager
    //         /// Or regular user
    //         PersonalData personalData = PersonalData(
    //           name: name!,
    //           email: email!,
    //           contact: contact!,
    //           password: password!,
    //           deviceId: deviceId!,
    //           referralId: referralCodeOrCommunityName!,
    //           community: isRegistrationAsCommunityManager
    //               ? referralCodeOrCommunityName!
    //               : parentCommunity!,
    //         );
    //         locator<ProfileDataHandler>().updateProfileData(
    //           data: personalData.toJson(),
    //           typeOfDocument: ProfileDocument.userPersonalData,
    //           userId: user.uid,
    //           toLocalDatabase: true,
    //         );
    //         PlatformData platformData = PlatformData(
    //           referralCode: referralCode,
    //           referredBy: isRegistrationAsCommunityManager
    //               ? "CM"
    //               : referralCodeOrCommunityName!,
    //           referredTo: <String>[],
    //           isCommunityManager: isRegistrationAsCommunityManager,
    //         );
    //         locator<ProfileDataHandler>().updateProfileData(
    //           data: platformData.toJson(),
    //           typeOfDocument: ProfileDocument.userPlatformData,
    //           userId: user.uid,
    //           toLocalDatabase: true,
    //         );
    //         PlatformRatings platformRatings = PlatformRatings(
    //           communityScore: 0.0,
    //           personalScore: 5,
    //           prestoCoins: 0,
    //         );
    //         locator<ProfileDataHandler>().updateProfileData(
    //           data: platformRatings.toJson(),
    //           typeOfDocument: ProfileDocument.userPlatformRatings,
    //           userId: user.uid,
    //           toLocalDatabase: true,
    //         );
    //         TransactionData transactionData = TransactionData(
    //           paymentMethodsUsed: <String, dynamic>{
    //             paymentMethodsToString(PaymentMethods.creditCard): 0,
    //             paymentMethodsToString(PaymentMethods.debitCard): 0,
    //             paymentMethodsToString(PaymentMethods.googlePay): 0,
    //             paymentMethodsToString(PaymentMethods.payTm): 0,
    //             paymentMethodsToString(PaymentMethods.upi): 0,
    //           },
    //           transactionIds: <String>[],
    //           totalBorrowed: 0,
    //           totalLent: 0,
    //           activeTransactions: <String>[],
    //         );
    //         locator<ProfileDataHandler>().updateProfileData(
    //           data: transactionData.toJson(),
    //           typeOfDocument: ProfileDocument.userTransactionsData,
    //           userId: user.uid,
    //           toLocalDatabase: true,
    //         );
    //         FirebaseMessaging.instance.getToken().then((newToken) {
    //           NotificationToken token =
    //               NotificationToken(notificationToken: newToken!);
    //           setBusy(false);
    //           locator<ProfileDataHandler>().updateProfileData(
    //             data: token.toJson(),
    //             typeOfDocument: ProfileDocument.userNotificationToken,
    //             userId: user.uid,
    //             toLocalDatabase: true,
    //           );
    //           _navigationService.navigateTo(
    //             Routes.phoneVerificationView,
    //             arguments: PhoneVerificationViewArguments(
    //               phoneNumber: '+91' + contact!.trim(),
    //             ),
    //           );
    //         });
    //       });
    //     }
    //   });
    // } else {
    //   setBusy(false);
    //   print(
    //     "$nameValidated $emailValidated $contactValidated $passwordValidated $referralCodeOrCommunityNameValidated $userAcceptedTermsAndConditions",
    //   );
    //   _errorHandlingService.handleError(
    //     error: "Please fill details appropriately.",
    //   );
    // }
  }
}
