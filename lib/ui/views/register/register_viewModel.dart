import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/models/enums.dart';
import 'package:presto/models/limits/referral_limit_model.dart';
import 'package:presto/models/user/notification_data_model.dart';
import 'package:presto/models/user/personal_data_model.dart';
import 'package:presto/models/user/platform_data_model.dart';
import 'package:presto/models/user/platform_ratings_data.dart';
import 'package:presto/models/user/transaction_data_model.dart';
import 'package:presto/services/authentication.dart';
import 'package:presto/services/database/dataHandlers/limitsDataHandler.dart';
import 'package:presto/services/database/dataHandlers/profileDataHandler.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/services/database/firestoreBase.dart';
import 'package:presto/services/database/hiveDatabase.dart';
import 'package:presto/services/error/error.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
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
    if (name == null || name == "" || name.trim() == "" || name.length < 3)
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
      if (referralCodeOrCommunityName != null &&
          referralCodeOrCommunityName.trim().length > 5) {
        if (isRegistrationAsCommunityManager) {
          /// Check whether given community name is unique
          log.d("Going for validation");
          final QuerySnapshot querySnapshot =
              await locator<FirestoreService>().checkForCollectionExistence(
            community: referralCodeOrCommunityName.trim(),
          );
          log.w(querySnapshot.docs.toList().toString());
          if (querySnapshot.docs.isEmpty) {
            log.w("Valid Community");
            return null;
          } else {
            log.w("Invalid Community");
            return "Entered Community Name is either taken or not valid";
          }
        } else {
          /// Checks whether referral code is valid
          var personalData = await locator<ProfileDataHandler>().getProfileData(
            userId: referralCodeOrCommunityName.trim(),
            typeOfData: ProfileDocument.userPlatformData,
            fromLocalDatabase: false,
          );
          if (personalData != <String, dynamic>{}) {
            log.w(personalData);
            PlatformData parentPlatformData =
                PlatformData.fromJson(personalData);
            var limitsMap = await locator<LimitsDataHandler>().getLimitsData(
              typeOfLimit: LimitDocument.referralLimits,
              fromLocalDatabase: false,
            );
            log.w(limitsMap);
            ReferralLimit referralLimit = ReferralLimit.fromJson(limitsMap);
            if (parentPlatformData.referredTo.length ==
                referralLimit.refereeLimit) {
              log.w("Invalid Community Code referee exceeded");
              return "Referee limit of entered referral code has been exceeded";
            } else {
              log.w("Valid Community Code");
              parentCommunity = parentPlatformData.community;
              return null;
            }
          } else {
            log.w("Invalid Community Code no user");

            return "Please enter valid Referral Code";
          }
        }
      } else {
        return "Please enter valid Referral Code";
      }
    } catch (e) {
      setBusy(false);
      log.e("There was error here in validating code");
      return "Error";
    }
  }

  String? deviceId;
  bool gotDeviceId = false;

  void getDeviceId() async {
    try {
      print("Getting Device Id");
      deviceId = await PlatformDeviceId.getDeviceId;
      gotDeviceId = true;
      print("Got Device Id");
    } catch (e) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: e);
    }
  }

  void termsAndConditions() {
    showDialog(
      barrierDismissible: false,
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return AlertDialog(
          scrollable: true,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          title: Text(
            titleForTC,
            style: TextStyle(
              fontSize: default_big_font_size,
            ),
          ),
          content: Text(
            descriptionForTC,
            style: TextStyle(
              fontSize: default_normal_font_size,
            ),
          ),
          actions: [
            Container(
              height: height * 0.05,
              width: width * 0.22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              child: MaterialButton(
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: primaryLightColor,
                    fontSize: default_normal_font_size,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void proceedRegistration() async {
    try {
      setBusy(true);
      referralCodeOrCommunityName = referralCodeController.text.trim();
      if (referralCodeOrCommunityName == null) {
        setBusy(false);
        log.e("There was error here");
        _errorHandlingService.handleError(
            error: "Please Enter valid values in input fields");
        return;
      }
      log.w("Checking referralCode");
      var value = await referralCodeOrCommunityNameValidator(
        referralCodeOrCommunityName,
      );
      if (value == null) {
        log.wtf(value);
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
                );
                locator<UserDataProvider>().personalData = personalData;
                PlatformData platformData = PlatformData(
                  disabled: false,
                  community: isRegistrationAsCommunityManager
                      ? referralCodeOrCommunityName!
                      : parentCommunity!,
                  referralCode: referralCode,
                  referredBy: isRegistrationAsCommunityManager
                      ? "CM"
                      : referralCodeOrCommunityName!,
                  referredTo: <String>[],
                  isCommunityManager: isRegistrationAsCommunityManager,
                );
                locator<UserDataProvider>().platformData = platformData;
                PlatformRatings platformRatings = PlatformRatings(
                  communityScore: 0.0,
                  personalScore: 2.0,
                  prestoCoins: 0,
                );
                locator<UserDataProvider>().platformRatingsData =
                    platformRatings;
                TransactionData transactionData = TransactionData(
                  paymentMethodsUsed: <String, dynamic>{
                    PaymentMethodsMap[PaymentMethods.amazonPay]!: 0,
                    PaymentMethodsMap[PaymentMethods.creditCard]!: 0,
                    PaymentMethodsMap[PaymentMethods.debitCard]!: 0,
                    PaymentMethodsMap[PaymentMethods.googlePay]!: 0,
                    PaymentMethodsMap[PaymentMethods.payTm]!: 0,
                    PaymentMethodsMap[PaymentMethods.paypal]!: 0,
                    PaymentMethodsMap[PaymentMethods.phonePay]!: 0,
                    PaymentMethodsMap[PaymentMethods.upi]!: 0,
                  },
                  transactionIds: <String>[],
                  totalBorrowed: 0,
                  totalLent: 0,
                  activeTransactions: <String>[],
                  borrowingRequestInProcess: false,
                );
                locator<UserDataProvider>().transactionData = transactionData;
                FirebaseMessaging.instance.getToken().then((newToken) {
                  NotificationToken token =
                      NotificationToken(notificationToken: newToken!);
                  locator<UserDataProvider>().token = token;
                  setBusy(false);

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
          log.e("There was error here");
          _errorHandlingService.handleError(
            error: "Please fill details appropriately.",
          );
        }
      }
      setBusy(false);
      log.e("There was error here");
      if (isRegistrationAsCommunityManager && value != null) {
        _errorHandlingService.handleError(
          error: "Entered Community Name is either taken or invalid",
        );
      } else if (!isRegistrationAsCommunityManager && value != null) {
        _errorHandlingService.handleError(
          error: "Please enter valid Referral Code",
        );
      }
    } catch (e) {
      setBusy(false);
      log.e("There was error here");
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

  String titleForTC = 'Terms And Conditions';
  String descriptionForTC =
      "Disclaimer\n This Privacy Policy is governed by and is compliant with the Information Technology (Reasonable security practices and procedures and sensitive personal data or information) Rules 2011, which is designed to protect personal information of the end-user(s) of the services; and other applicable rules and regulations related to privacy.\n This Privacy Policy sets forth the modes of collection, utilisation and disclosure of your information gathered on the application. This Privacy Policy applies only to confidential information collected on the application. This Privacy Policy does not apply to information collected by Presto in other ways, including information collected offline or through social networking platforms. \n By clicking on ‘i accept’ or ‘i agree’, or continuing to use the services, or by installation or access to the application, you agree to the terms of this Privacy Policy. If you do not agree to this Privacy Policy, you may not avail the services. We are committed to protect your privacy and have made this privacy policy to describe the procedures we adhere to for collecting, using, and disclosing the personal information. We recommend you read this privacy policy carefully so that you understand our approach towards the use of your personal information.\n"
      "Definitions\nAPPLICATION/APP: ‘Application/App’ shall refer to the Presto platform, i.e. the mobile application or the algorithm created, developed, designed and made available by Presto.\n APPLICATION SERVICES: ‘Application Services’ shall include the mobile application offered by Presto, services offered through the mobile application and emails sent by Kreon.\nPLATFORM: ‘Platform’ shall mean the Application and the Website.\nSERVICES: ‘Services’ shall mean any service offered or rendered by Kreon Finance or its affiliates.\nTHIRD-PARTY PLATFORMS: ‘Third-Party Platforms’ shall mean social networking platforms offered by third-party service providers, such as Google, Facebook, LinkedIn and other similar entities.\nUSER ACCOUNT: ‘User Account’ shall mean the registered Application account of the User with Presto for use of the Application and services offered by Presto\nWEBSITE: ‘Website’ shall refer to www.stucred.com or such other website Kreon notifies for the purposes of these terms.\nYOU/YOUR/USER: ‘You/Your/User’ shall mean any person who accesses, downloads, installs, utilizes, operates or views the Application or Services offered by Presto.\n"
      "Scope\nThis Privacy Policy applies to the User data collected by Presto, including your name, e-mail address, biometric information, gender, date of birth, mobile number, passwords, photograph video recordings as a part of the User on-boarding process, mobile phone information including contact numbers, SMS, call logs and browsing history, location, data and login-in credentials of Third Party Platforms.\n "
      "Collection Of Data\nThe Personal Information shall be collected through the mobile application form (‘Mobile Application Form’) available on the Application or through Third Party Platforms or the User device.\nAs part of the Services, you authorize us to import your details and Personal Information dispersed over Third Party Platforms.\nWe also collect from your mobile device a unique ID (where your device is an iPhone, we also collect the Apple-recommended CFUUID (the Core Foundation Universally Unique Identifier)) and you consent to the same by installation or use of the application.\nYou understand and acknowledge that the Company reserves the right to track your location (‘Track’) during the provision of the Services, and also in the event that you stop, cease, discontinue to use or avail the Services, through the deletion or uninstallation of the Mobile App or otherwise, till the event that your obligations to pay the Outstanding Amount(s) to Presto, exist. Deletion, uninstallation, and/or discontinuation of our Services, shall not release you from the responsibility, obligation and liability to repay the Outstanding Amount(s).\n"
      "User Data\n1. We shall use the User data in the following cases:\nA: To provide you with the Services and to assist you in the event you need additional support;\nB: To access your credit worthiness and intent to pay;\nC: To maintain and manage your User Account;\nD: To assist you with technical difficulties that may arise in relation to your use and access of the Application;\nE: To manage our relationship with you;\nF: For Analytics;\nG: To comply with our legal or statutory obligations;\nH: To contact you about important announcements and other important information about your User Account, the Application and the Services;\nI: In order to define your profile.\nJ: To establish your identity & information for the concerned party who has agreed to lend/borrow to/from you on the Presto Platform\nK: To establish your identity & information in your community in case you fail to pay back the borrowed amount in time.\nUser generated content is not confidential or proprietary. You grant, and warrant that you have the right to grant us a non-exclusive, non-revocable, worldwide, transferable, royalty-free, perpetual right to use your User generated content in any manner or media now or later developed, for any purpose, commercial, advertising, or otherwise, including the right to translate, display, reproduce, modify, create derivative works, sublicense, distribute, assign and commercialize without any payment due to you.\n"
      "Email/SMS Communications\nIf you opted-in to receive information about our application, service, updates and offers, we will use your name and email address to send the above information to you. If you no longer wish to receive these communications, you can unsubscribe by emailing at prestoprivatelimited@gmail.com. Please note that we may send you transactional and relationship messages, even if you have unsubscribed from our marketing communications. For instance, if our service is going to be temporarily suspended for maintenance, we may send you an email to update you of the temporary suspension.\nWe will also send you SMS communication when a member of your community has placed a request to borrow money on the Presto platform. If you no longer wish to receive these communications, please toggle off the ‘Lender’ option on your profile page inside the application.\n"
      "Data retention\nIf you wish to close your User Account altogether, please let us know by submitting a request to prestoprivatelimited@gmail.com. We may retain information about you in our databases for as long as your account is active or as needed to provide you services and in accordance with applicable laws. Our retention and use of your information will be as necessary to comply with our legal obligations, resolve disputes, and enforce our agreements.\nThe retention period may extend beyond the end of your relationship with us, but it will be only as long as it is necessary for us to have sufficient information to respond to any issues that may arise later or for our commercial records. We may disclose Personal Information if required to do so by law or in good faith that such disclosure is reasonably necessary to respond to court orders or other legal processes.\nWe may also retain the user information to provide you paramount services if you reopen your account. Please note, however, that there might be latency in deleting Personal Information from our servers and backed-up versions might exist even after deletion.\n"
      "SECURITY\nWe value your Personal Information, and protect it on the Platform against loss, misuse or alteration by taking extensive security measures. In order to protect your Personal Information, we have implemented stringent security measures to protect the loss, misuse and alteration of the information under our control. Once your information is in our possession, we adhere to strict security guidelines, protecting it against unauthorized access.\nAll Personal Information is stored on a secure cloud setup and all communication as well as handling of personal or sensitive user data happens via secure communication channels using modern cryptography (for example HTTPS). The Personal Information is stored on Google cloud. There is restricted access to any such information.\nAlthough we provide appropriate firewalls and protections, we cannot warrant the security of any Personal Information transmitted as our systems are not hack proof. Data pilferage due to unauthorized hacking, virus attacks, technical issues is possible and we take no liabilities or responsibilities for it.\nYou are responsible for all actions that take place under your User Account. If you choose to share your User Account details and password or any Personal Information with third parties, you are solely responsible for the same. In the event of any misuse of your User Account by any third party, in any manner, you may lose substantial control over your Personal Information and may be subject to legally binding actions.\nAccess to information\nWe will respond to your request about access to the information we collect about you within the time frame required by applicable law. The following persons may have access to the user data:\na) Administrators: We shall provide access to your Personal information to our authorized administrators for business purposes, who shall be under confidentiality obligations towards the same.\nb) Affiliates: Affiliates: We may provide Personal Information we collect to our affiliates.\nc) Business Partners: We may use certain trusted third-party companies and individuals to help us provide, analyze, and improve the Services including but not limited to data storage, maintenance services, database management, credit bureaus, rating agencies, web analytics, payment processing, and improvement of the Platform’s features. These third parties may have access to your information only for purposes of performing these tasks on our behalf and under obligations similar to those in this Privacy Policy. We may disclose your Personal Information to partners who perform business functions or hosting services on our behalf and who may be located outside India\nd) Service Providers: We may share your Personal Information with the service providers, who are working with us in connection with the operation of the Services or the Platform, so long as such service providers are subject to confidentiality restrictions consistent with this Privacy Policy.\ne) Joint Marketing Arrangements: Where permitted by law, we may share your Personal Information with joint marketers with whom we have a marketing arrangement, we would require all such joint marketers to have written contracts with us that specify the appropriate use of your Personal Information, require them to safeguard your Personal Information, and prohibit them from making unauthorized or unlawful use of your Personal Information.\nf) Persons Who Acquire Our Assets or Business: If we choose to sell or transfer any of our business or assets, certain Personal Information may be a part of that sale or transfer\ng) Legal and Regulatory Authorities: We may be required to disclose your Personal Information due to legal or regulatory requirements. In such instances, we reserve the right to disclose your Personal Information as required in order to comply with our legal obligations, including but not limited to complying with court orders, warrants, or discovery requests. We may also disclose your Personal Information:\n"
      "1. To law enforcement officers or others;\n2. To credit information companies;\n3. To comply with a judicial proceeding, court order, or legal process served on us or the Platform;\n4. To enforce or apply this Privacy Policy or the terms of Service or our other policies or Agreements;\n5. For an insolvency proceeding involving all or part of the business or asset to which the information pertains;\n6. Respond to claims that any Personal Information violates the rights of third-parties;\n7. Or to protect the rights, property, or personal safety of the Company, or the general public.\nH) Lenders on the Platform: We may share your data and information to the lenders on the platform who have agreed to service your borrowing request to enable the transaction and establish identity in case of a default.\nI) Borrowers on the Platform: We may share your data and information to the borrowers on the platform who have borrowed from you for the purpose of effective collections of the borrowed amount.\nJ) Other members of your Community on the Platform: We may share your data and information to other members of your community on the platform in an event of a non-payment of the borrowed amount in the set timeline.\nYou agree and acknowledge that we may not inform you prior to or after disclosures made according to this section.\nNotwithstanding anything mentioned hereinabove, the Company shall not be responsible for the actions or omissions of the service providers or parties with whom the Personal Information is shared, nor shall the Company be responsible and/or liable for any additional information you may choose to provide directly to any service provider or any third party.\nWe may share your information to other third parties, in which case we will protect your information by aggregation or de-identification of the information, so that it cannot reasonably be used to identify you.\nIn situations other than as set out above, you will receive prior written notice when information about you might be shared with third parties and you will have an opportunity to choose whether or not to grant them access to the information\n"
      "Cookies\nWe may set ‘cookies’ to track your use of the Platform. Cookies are small encrypted files that a site or its service provider transfers to your device’s drive that enables the sites or service provider’s systems to recognize your device and capture and remember certain information. By using the Application, you consent to our use of cookies.\n"
      "Ancillary services\nWe may provide you with certain ancillary services such as chat rooms, blogs and reviews for the Services. Subject to any applicable laws, any communication shared by you via the Application or through any other medium, reviews or otherwise to us (including without limitation contents, images, audio, financial information, feedback etc. collectively ‘Feedback’) is on a non-confidential basis, and we are under no obligation to refrain from reproducing, publishing or otherwise using it in any way or for any purpose.\nYou shall be responsible for the content and information contained in any Feedback shared by you through the Platform or otherwise to us, including without limitation for its truthfulness and accuracy. Sharing your Feedback with us, constitutes an assignment to us of all worldwide rights, titles and interests in all copyrights and other intellectual property rights in the Feedback and you authorize us to use the Feedback for any purpose, which we may deem fit.\n"
      "Limitation of liability\nYou agree to indemnify us, our subsidiaries, affiliates, officers, agents, co-branders or other partners, and employees and hold us harmless from and against any claims and demand, including reasonable attorneys’ fees, made by any third party arising out of or relating to: (i) Personal Information and contents that you submit or share through the Platform; (ii) your violation of this Privacy Policy, (iii) or your violation of rights of another Customer(s)\nYou expressly understand and agree that Presto shall not be liable for any direct, indirect, incidental, special, consequential or exemplary damages, including but not limited to, damages for loss of profits, goodwill, use, data, information, details or other intangible losses (even if we have been advised of the possibility of such damages), resulting from: (i) the use or the inability to use the Services; (ii) unauthorized access to or alteration of your Personal Information.\n"
      "Changes to this policy\nWe may make changes to this Privacy Policy. In the event that changes are made to this Privacy Policy, we will notify you by revising the date at the top of the policy. If we make material changes, we will do so in accordance with applicable legal requirements, and we will post a notice on the application alerting you to the material changes prior to such changes becoming effective. We encourage you to periodically review this page for the latest information on our privacy practices.\n"
      "Miscellaneous\nThis Agreement shall be construed and governed by the laws of India and courts of law at Chennai shall have exclusive jurisdiction over such disputes without regard to principles of conflict of laws.\nIn case you need to access, review, and/or make changes to the Personal Information, you shall have to login to your User Account and change the requisite details. You shall keep your Personal Information updated to help us better serve you.\nOur Application may include links to other websites or online services, whose privacy practices may differ from those of us. If you submit information to any of those websites or online services, your information is governed by their privacy policy. We encourage you to carefully read the privacy policy of any such website you visit.\nWhen you use our application, we use action tags (also called pixel tags, clear GIF, or beacons) to identify the content that you visit and how you use such content. Action tags may collect and transmit this data in a manner that identifies you if you have registered with our application or are logged into our application. We also use action tags in our emails, to determine whether an email was opened or whether it was forwarded to someone else.\nYou are responsible for maintaining the secrecy and accuracy of your password, email address, and other account information at all times. We recommend a strong password that you do not use with other services. We are not responsible for personal data transmitted to a third party as a result of an incorrect email address.\n"
      "Contact us\nTo keep your personal data accurate, current, and complete, please contact us regarding changes on prestoprivatelimited@gmail.com. We will take reasonable steps to update or correct personal data in our possession that you have previously submitted using our services. You may also contact us on the above email address if you have any questions regarding our Privacy Policy.";
}
