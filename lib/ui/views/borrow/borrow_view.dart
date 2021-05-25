import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:stacked/stacked.dart';

import '../../shared/colors.dart';
import '../../widgets/busyButton.dart';
import '../../widgets/inputTextField.dart';
import 'borrow_viewModel.dart';

class BorrowView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const BorrowView({Key? key, required this.slideChangeView}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<BorrowViewModel>.reactive(
      viewModelBuilder: () => BorrowViewModel(),
      disposeViewModel: false,
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.onModelReady(slideChangeView),
      builder: (context, model, child) {
        return KeyboardDismisser(
          child: GestureDetector(
            onHorizontalDragEnd: (dragEndDetails) {
              print(dragEndDetails.velocity);
              print(dragEndDetails.primaryVelocity);
              if (!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative) {
                model.callback(false);
              } else {
                model.callback(true);
              }
              print('end');
            },
            child: Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height / 8,
                      ),
                      Container(
                        width: width / 1.5,
                        child: InputField(
                          controller: model.upi_id,
                          hintText: 'Enter UPI ID',
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                        height: height / 10,
                      ),
                      Container(
                        width: width / 1.5,
                        child: InputField(
                          controller: model.amount,
                          hintText: 'Enter Amount',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: height / 10,
                      ),
                      BusyButton(
                        height: width / 5.5,
                        width: width / 5.5,
                        title: 'PAY',
                        color: Colors.white,
                        decoration: BoxDecoration(
                          color: primarySwatch[800],
                          shape: BoxShape.circle,
                        ),
                        onPressed: () {
                          model.initiatePayment();
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
