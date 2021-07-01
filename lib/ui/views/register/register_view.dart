import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:presto/ui/widgets/inputTextField.dart';
import 'package:stacked/stacked.dart';

import 'register_viewModel.dart';

class RegisterView extends StatelessWidget {
  final bool isRegistrationAsCommunityManager;
  RegisterView({
    Key? key,
    this.isRegistrationAsCommunityManager = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(),
      onModelReady: (model) =>
          model.onModelReady(isRegistrationAsCommunityManager),
      builder: (context, model, child) {
        return KeyboardDismisser(
          child: Scaffold(
            backgroundColor:backgroundColorLight,
            body: Container(
              height: height - MediaQuery.of(context).viewInsets.vertical,
              width: width,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height / 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: banner_font_size,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an Account?",
                            style: TextStyle(
                              fontSize: default_normal_font_size,
                            ),
                          ),
                          GestureDetector(
                            onTap: model.navigateToLogin,
                            child: Text(
                              " Sign in",
                              style: TextStyle(
                                fontSize: default_normal_font_size,
                                color: textHighlightLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),

                      Container(
                        width: width * 0.9,
                        child: InputField(
                          prefixWidget: Icon(
                            Icons.person_outline,
                            color: inputFieldIconLight,
                          ),
                          validator: model.nameValidator,
                          fieldKey: model.nameFieldKey,
                          hintText: "Name",
                          helperText: "Enter your name here",
                          validationSuccessCallBack:
                              model.onNameValidationSuccess,
                          validationFailureCallBack:
                              model.onNameValidationFailure,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        width: width * 0.9,
                        child: InputField(
                          prefixWidget: Icon(
                            Icons.email_outlined,
                            color: inputFieldIconLight,
                          ),
                          validator: model.emailValidator,
                          fieldKey: model.emailFieldKey,
                          hintText: "Mail",
                          helperText: "Enter your email here",
                          validationSuccessCallBack:
                              model.onEmailValidationSuccess,
                          validationFailureCallBack:
                              model.onEmailValidationFailure,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        width: width * 0.9,
                        child: InputField(
                          prefixWidget: Icon(
                            Icons.phone_outlined,
                            color: inputFieldIconLight,
                          ),
                          validator: model.contactValidator,
                          fieldKey: model.contactFieldKey,
                          hintText: "Phone Number",
                          helperText: "Enter your mobile number here",
                          validationSuccessCallBack:
                              model.onContactValidationSuccess,
                          validationFailureCallBack:
                              model.onContactValidationFailure,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        width: width * 0.9,
                        child: InputField(
                          prefixWidget: Icon(
                            Icons.lock_outline,
                            color: inputFieldIconLight,
                          ),
                          validator: model.passwordValidator,
                          fieldKey: model.passwordFieldKey,
                          hintText: "Password",
                          helperText: "Enter your password here",
                          shouldObscure: true,
                          validationSuccessCallBack:
                              model.onPasswordValidationSuccess,
                          validationFailureCallBack:
                              model.onPasswordValidationFailure,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        width: width * 0.9,
                        child: InputField(
                          controller: model.referralCodeController,
                          prefixWidget: Icon(
                            Icons.info_outline,
                            color: inputFieldIconLight,
                          ),
                          fieldKey: model.referralCodeOrCommunityNameFieldKey,
                          hintText: model.isRegistrationAsCommunityManager
                              ? "New Community"
                              : "Referral Code",
                          helperText: model.isRegistrationAsCommunityManager
                              ? "Enter your community name"
                              : "Enter your Referral Code",
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        width: width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: model.userAcceptedTermsAndConditions,
                                activeColor: inputFieldIconLight,
                                onChanged: (bool? value) {
                                  model.changeInCheckBox();
                                }),
                            Text(
                              'I Accept all the ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: default_normal_font_size,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: textHighlightLight,
                                  fontSize: default_normal_font_size,
                                ),
                              ),
                              onTap: () {
                                // model.termsAndConditions();
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),

                      // BusyButton(
                      //     title: 'Sign Up as Community Manager',
                      //     onPressed:(){
                      //       print('Signing Up as Community Manager');
                      //     }
                      // ),
                      BusyButton(
                        height: height / 13,
                        width: width * 0.5,
                        fontSize:
                            (default_normal_font_size + default_big_font_size) /
                                2,
                        textColor: busyButtonTextColorLight,
                        decoration: BoxDecoration(
                          color: authButtonColorLight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        title: "Sign Up",
                        busy: model.isBusy,
                        onPressed: () {
                          print("initiating signUP");
                          model.proceedRegistration();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
