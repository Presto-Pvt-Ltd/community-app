import 'package:flutter/material.dart';
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
      builder: (context, model, child){
        return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: height / 12,
                  ),
                  Text(
                    'Reset Your Password',
                    style: TextStyle(
                      fontSize: height / 20,
                      color: primaryColor
                    ),
                  ),
                  SizedBox(
                    height: height / 12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width / 20, right: width / 20),
                    child: Text(
                      'You will get the password reset link on your registered email',
                      style: TextStyle(
                        fontSize: height / 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 35,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width / 25, right: width / 25),
                    child: InputField(
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
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  BusyButton(
                    title: 'Get Link!',
                    height: height / 13,
                    width: width * 0.5,
                    textColor: Colors.white,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    onPressed: (){
                      print('Pressed Get Link!');
                      model.onPressingGetLink();
                    },
                  )
                ],
              ),
            )
        );
      },
    );
  }
}
