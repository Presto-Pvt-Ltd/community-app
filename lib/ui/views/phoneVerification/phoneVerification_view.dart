import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'phoneVerification_viewModel.dart';

class PhoneVerificationView extends StatelessWidget {
  final String phoneNumber;
  const PhoneVerificationView({Key? key, required this.phoneNumber})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<PhoneVerificationViewModel>.reactive(
      viewModelBuilder: () => PhoneVerificationViewModel(),
      onModelReady: (model) => model.onModelReady(phoneNumber),
      initialiseSpecialViewModelsOnce: true,
      fireOnModelReadyOnce: true,
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            return showDialog<bool>(
              barrierDismissible: false,
              context: StackedService.navigatorKey!.currentContext!,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Check!!",
                  ),
                  content: Text(
                    "Are you sure you don't want to continue?",
                  ),
                  actions: [
                    Container(
                      height: height * 0.05,
                      width: width * 0.22,
                      color: Colors.white24,
                      child: MaterialButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                    Container(
                      height: height * 0.05,
                      width: width * 0.22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: MaterialButton(
                        color: primaryColor,
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          model.deleteUser();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                );
              },
            ).then((value) {
              if (value == null) {
                return false;
              } else {
                return value;
              }
            });
          },
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height / 20,
                    ),
                    Text(
                      'Verification Code',
                      style: TextStyle(
                        fontSize: height / 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 7,
                    ),
                    Text(
                      'Please Enter the OTP sent',
                      style: TextStyle(
                        fontSize: height / 45,
                      ),
                    ),
                    Text(
                      'on your registered phone number',
                      style: TextStyle(
                        fontSize: height / 45,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 15,
                        left: MediaQuery.of(context).size.width / 15,
                        right: MediaQuery.of(context).size.width / 15,
                      ),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        showCursor: true,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        cursorColor: Colors.black,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          activeFillColor: primarySwatch[400],
                          selectedFillColor: primarySwatch[200],
                          inactiveColor: Colors.white,
                          activeColor: Colors.white,
                          selectedColor: primarySwatch[200],
                          inactiveFillColor: primarySwatch[400],
                          fieldHeight: height / 15,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        onChanged: model.onOtpFieldChange,
                        onCompleted: model.onOtpFieldComplete,
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          return true;
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    BusyButton(
                      width: width * 0.5,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      textColor: Colors.white,
                      title: "Verify",
                      height: height / 13,
                      busy: model.isBusy,
                      onPressed: () async {
                        //Manual otp send
                        model.verifyOtp();
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    Text(
                      'Resend the OTP after',
                      style: TextStyle(
                        fontSize: height / 45,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Countdown(
                            controller: model.counterController,
                            build: (BuildContext context, double count) {
                              return Text(
                                count.toInt().toString(),
                                style: TextStyle(
                                  fontSize: height / 45,
                                  color: model.otpSent
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              );
                            },
                            seconds: 120,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 50,
                        ),
                        GestureDetector(
                          onTap:
                              !model.otpSent ? null : model.verifyPhoneNumber,
                          child: Text(
                            'Resend Now!',
                            style: TextStyle(
                              fontSize: height / 45,
                              color: model.counterController.isCompleted == null
                                  ? Colors.grey
                                  : (model.counterController.isCompleted!
                                      ? Colors.grey
                                      : Colors.red),
                              decoration:
                                  model.counterController.isCompleted == null
                                      ? TextDecoration.underline
                                      : (model.counterController.isCompleted!
                                          ? TextDecoration.none
                                          : TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
