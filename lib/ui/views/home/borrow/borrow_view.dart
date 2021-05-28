import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:presto/ui/widgets/inputTextField.dart';
import 'package:stacked/stacked.dart';

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
                child: !model.gotData || model.isBusy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              model.transactionLimits == null
                                  ? ""
                                  : model.transactionLimits!.borrowLowerLimit
                                      .toString(),
                            ),
                            Text(
                              model.transactionLimits == null
                                  ? ""
                                  : model.transactionLimits!.borrowUpperLimit
                                      .toString(),
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
