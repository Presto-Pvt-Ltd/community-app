import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.router.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
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
            backgroundColor: backgroundColorLight,
            body: Container(
              height: height - MediaQuery.of(context).viewInsets.vertical,
              width: width,
              alignment: Alignment.center,
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
                          fontSize: banner_font_size,
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
                            fontSize: default_normal_font_size,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: model.navigateToRegister,
                          child: Text(
                            " Register ",
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
                    InputField(
                      prefixWidget: Icon(
                        Icons.email_outlined,
                        color: inputFieldIconLight,
                      ),
                      controller: model.email,
                      validator: model.emailValidator,
                      fieldKey: model.emailFieldKey,
                      hintText: "Mail",
                      helperText: "Enter your email here",
                      validationSuccessCallBack: model.onEmailValidationSuccess,
                      validationFailureCallBack: model.onEmailValidationFailure,
                    ),
                    SizedBox(
                      height: height * 0.03,
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
                              fontSize: default_normal_font_size,
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
                      textColor: busyButtonTextColorLight,
                       fontSize: (default_normal_font_size + default_big_font_size)/2,
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
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Text(
                          "Or build your own community! ",
                          style: TextStyle(
                            fontSize: default_normal_font_size,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Become a",
                          style: TextStyle(
                            fontSize: default_normal_font_size,
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
                              fontSize: default_normal_font_size,
                              color: textHighlightLight,
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
