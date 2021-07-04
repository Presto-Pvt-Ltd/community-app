import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/views/forgotPassword/forgotPassword_viewModel.dart';
import 'package:stacked/stacked.dart';

import '../../shared/colors.dart';
import '../../widgets/busyButton.dart';
import '../../widgets/inputTextField.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(),
      initialiseSpecialViewModelsOnce: true,
      disposeViewModel: false,
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 60,
            centerTitle: true,
            title: Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: default_headers,
                fontWeight: FontWeight.bold,
                color: authButtonColorLight,
              ),
            ),
            backgroundColor: appBarColorLight,
            leading: GestureDetector(
              onTap: () {
                model.pop();
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: actions_icon_size,
                  height: actions_icon_size * 0.7,
                  child: SvgPicture.asset(
                    "assets/icons/left-arrow.svg",
                    fit: BoxFit.fitHeight,
                    color: authButtonColorLight,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: backgroundColorLight,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontal_padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  child: Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: default_headers,
                      color: authButtonColorLight,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  'You will get the password reset link on your registered email',
                  style: TextStyle(
                    fontSize: default_big_font_size,
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                InputField(
                  controller: model.email,
                  validator: model.emailValidator,
                  fieldKey: model.emailFieldKey,
                  hintText: "abc@xyz.com",
                  helperText: "Enter your email here",
                  validationSuccessCallBack: model.onEmailValidationSuccess,
                  validationFailureCallBack: model.onEmailValidationFailure,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                BusyButton(
                  title: 'Get Link!',
                  height: 60,
                  width: width * 0.4,
                  busy: model.isBusy,
                  fontSize: default_big_font_size,
                  textColor: busyButtonTextColorLight,
                  decoration: BoxDecoration(
                    color: authButtonColorLight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    print('Pressed Get Link!');
                    model.onPressingGetLink();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
