import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
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
                            fontSize: 45,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Sign up to get Started",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 20,
                    ),

                    Container(
                      width: width * 0.9,
                      child: InputField(
                        prefixWidget: Icon(
                          Icons.person,
                          color: primaryColor,
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: width * 0.9,
                      child: InputField(
                        prefixWidget: Icon(
                          Icons.email,
                          color: primaryColor,
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: width * 0.9,
                      child: InputField(
                        prefixWidget: Icon(
                          Icons.contact_phone,
                          color: primaryColor,
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
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: width * 0.9,
                      child: InputField(
                        prefixWidget: Icon(
                          Icons.lock,
                          color: primaryColor,
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
                      height: 20,
                    ),
                    Container(
                      width: width * 0.9,
                      child: InputField(
                        controller: model.referralCodeController,
                        prefixWidget: Icon(
                          Icons.info,
                          color: primaryColor,
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
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: model.userAcceptedTermsAndConditions,
                              activeColor: primaryColor,
                              onChanged: (bool? value) {
                                model.changeInCheckBox();
                              }),
                          Text(
                            'I Accept all the ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: height / 48,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              'Terms and Conditions',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: height / 48,
                                decoration: TextDecoration.underline,
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
                      height: height / 40,
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
                      decoration: BoxDecoration(
                        color: primaryColor,
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already a Presto Member?",
                          style: TextStyle(
                            fontSize: height / 48,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: model.navigateToLogin,
                          child: Text(
                            " Log In ",
                            style: TextStyle(
                              fontSize: height / 48,
                              color: neonGreen,
                              decoration: TextDecoration.underline,
                              decorationColor: neonGreen,
                            ),
                          ),
                        ),
                        Text(
                          "Now",
                          style: TextStyle(
                            fontSize: height / 48,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
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
