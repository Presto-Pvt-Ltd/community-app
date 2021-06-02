import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:presto/ui/widgets/inputTextField.dart';
import 'package:stacked/stacked.dart';
import 'login_viewModel.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          body: KeyboardDismisser(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: height / 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Welcome Back",
                                style: TextStyle(
                                  fontSize: height / 17,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: height / 3.7,
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Login to continue",
                                style: TextStyle(
                                  fontSize: height / 45,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 35,
                          ),
                          InputField(
                            controller: model.email,
                            validator: model.emailValidator,
                            fieldKey: model.emailFieldKey,
                            hintText: "abc@xyz.com",
                            helperText: "Enter your email here",
                            validationSuccessCallBack:
                                model.onEmailValidationSuccess,
                            validationFailureCallBack:
                                model.onEmailValidationFailure,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InputField(
                            controller: model.password,
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
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              //Add Forgot Password Page
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "Forget Password?",
                                  style: TextStyle(
                                    fontSize: height / 48,
                                    color: neonGreen,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 6.6,
                          ),
                          BusyButton(
                            height: height / 13,
                            width: width * 0.5,
                            textColor: Colors.white,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            title: "Log In",
                            busy: model.isBusy,
                            onPressed: () {
                              print("initiating login Process");
                              model.proceedLogin();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "New to Presto?",
                                style: TextStyle(
                                  fontSize: height / 48,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: model.navigateToRegister,
                                child: Text(
                                  " Sign Up ",
                                  style: TextStyle(
                                    fontSize: height / 48,
                                    color: neonGreen,
                                    decoration: TextDecoration.underline,
                                    decorationColor: neonGreen,
                                  ),
                                ),
                              ),
                              Text(
                                "Now.",
                                style: TextStyle(
                                  fontSize: height / 48,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            children: <Widget>[
                              Text(
                                "Or build your own community! ",
                                style: TextStyle(
                                  fontSize: height / 48,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Become a",
                                style: TextStyle(
                                  fontSize: height / 48,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => model.navigateToRegister(
                                  isRegistrationAsCommunityManager: true,
                                ),
                                child: Text(
                                  " Community Manager ",
                                  style: TextStyle(
                                    fontSize: height / 48,
                                    color: neonGreen,
                                    decoration: TextDecoration.underline,
                                    decorationColor: neonGreen,
                                  ),
                                ),
                              ),
                              Text(
                                "Now.",
                                style: TextStyle(
                                  fontSize: height / 48,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
