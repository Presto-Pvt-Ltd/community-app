import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:presto/ui/widgets/inputTextField.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
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
        return KeyboardDismisser(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "New to Presto?",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: model.navigateToRegister,
                          child: Text(
                            " Register ",
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
                    InputField(
                      prefixWidget: Icon(
                        Icons.email_outlined,
                        color: inputFieldIconLight,
                      ),
                      controller: model.email,
                      validator: model.emailValidator,
                      fieldKey: model.emailFieldKey,
                      hintText: "abc@xyz.com",
                      helperText: "Enter your email here",
                      validationSuccessCallBack: model.onEmailValidationSuccess,
                      validationFailureCallBack: model.onEmailValidationFailure,
                    ),
                    InputField(
                      prefixWidget: Icon(
                        Icons.lock_outline,
                        color: inputFieldIconLight,
                      ),
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
                      height: height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () {
                        locator<NavigationService>()
                            .navigateTo(Routes.forgetPasswordView);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 17,
                              color: textGreyShade,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    BusyButton(
                      height: height / 14,
                      width: width * 0.4,
                      textColor: Colors.white,
                      decoration: BoxDecoration(
                        color: authButtonColorLight,
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
                      height: height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Or build your own community! ",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Become a",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => model.navigateToRegister(
                            isRegistrationAsCommunityManager: true,
                          ),
                          child: Text(
                            " Community Manager ",
                            style: TextStyle(
                              fontSize: 17,
                              color: textHighlightLight,
                            ),
                          ),
                        ),
                        Text(
                          "Now.",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
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
