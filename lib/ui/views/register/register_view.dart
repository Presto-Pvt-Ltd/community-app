import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/ui/shared/colors.dart';
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
            backgroundColor: Colors.white,
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
                              fontSize: 44,
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
                              fontSize: 17,
                            ),
                          ),
                          GestureDetector(
                            onTap: model.navigateToLogin,
                            child: Text(
                              " Sign in",
                              style: TextStyle(
                                fontSize: 17,
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
                          hintText: "abc xyz",
                          helperText: "Enter your name here",
                          validationSuccessCallBack:
                              model.onNameValidationSuccess,
                          validationFailureCallBack:
                              model.onNameValidationFailure,
                        ),
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
                          hintText: "abc@xyz.com",
                          helperText: "Enter your email here",
                          validationSuccessCallBack:
                              model.onEmailValidationSuccess,
                          validationFailureCallBack:
                              model.onEmailValidationFailure,
                        ),
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
                          hintText: "10 digit mobile Number",
                          helperText: "Enter your mobile number here",
                          validationSuccessCallBack:
                              model.onContactValidationSuccess,
                          validationFailureCallBack:
                              model.onContactValidationFailure,
                          keyboardType: TextInputType.number,
                        ),
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
                              : "ABC12390",
                          helperText: model.isRegistrationAsCommunityManager
                              ? "Enter your community name"
                              : "Enter your Referral Code",
                        ),
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
                                fontSize: 17,
                              ),
                            ),
                            InkWell(
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: textHighlightLight,
                                  fontSize: 17,
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
                        textColor: Colors.white,
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
