import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/widgets/amountButton.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:stacked/stacked.dart';
import 'borrow_viewModel.dart';

class BorrowView extends StatelessWidget {
  final void Function(bool) slideChangeView;

  const BorrowView({
    Key? key,
    required this.slideChangeView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<BorrowViewModel>.reactive(
      viewModelBuilder: () => BorrowViewModel(),
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.onModelReady(slideChangeView),
      builder: (context, model, child) {
        return KeyboardDismisser(
          child: GestureDetector(
            onHorizontalDragEnd: (dragEndDetails) {
              print(dragEndDetails.velocity);
              print(dragEndDetails.primaryVelocity);
              if (!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative &&
                  dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300) {
                model.callback(false);
              } else if (dragEndDetails
                      .velocity.pixelsPerSecond.dx.isNegative &&
                  dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300) {
                model.callback(true);
              }
              print('end');
            },
            child: model.isBusy
                ? Center(
                    child: loader,
                  )
                : Container(
                    color: backgroundColorLight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Borrow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: authButtonColorLight,
                            fontSize: default_headers,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: vertical_padding * 2,
                        ),
                        Text(
                          'Amount Requested',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: authButtonColorLight,
                            fontSize:
                                (default_big_font_size + default_headers) / 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: vertical_padding * 2,
                        ),
                        Text(
                          "₹ ${model.amount.toInt().toString()}",
                          style: TextStyle(
                            color: authButtonColorLight,
                            fontSize: (default_normal_font_size +
                                    default_big_font_size) /
                                2,
                          ),
                        ),
                        Container(
                          width: width * 0.6,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: primaryLightColor,
                              inactiveTrackColor: Color(0xFF8D8E98),
                              overlayColor: Color(0x29EB1555),
                              thumbColor: primaryLightColor,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 10,
                              ),
                            ),
                            child: Slider(
                              divisions: model.transactionLimits != null
                                  ? ((model.transactionLimits!
                                                  .borrowUpperLimit -
                                              model.transactionLimits!
                                                  .borrowLowerLimit) /
                                          10)
                                      .floor()
                                  : 90,
                              value: model.amount,
                              max: model.transactionLimits?.borrowUpperLimit
                                      .toDouble() ??
                                  1000,
                              min: model.transactionLimits?.borrowLowerLimit
                                      .toDouble() ??
                                  10,
                              onChanged: (double newValue) {
                                print("Changing the value");
                                model.setAmount(newValue);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: vertical_padding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AmountButton(
                              text: "\u20B9 50",
                              onTap: () => model.increaseAmount(50),
                              buttonColor: blue98,
                              // onTap: () => model.increaseAmount(50.0),
                            ),
                            AmountButton(
                              text: "\u20B9 100",
                              onTap: () => model.increaseAmount(100),
                              buttonColor: blue98,
                              // onTap: () => model.increaseAmount(100.0),
                            ),
                            AmountButton(
                              text: "\u20B9 150",
                              onTap: () => model.increaseAmount(150),
                              buttonColor: blue98,
                              // onTap: () => model.increaseAmount(150.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: vertical_padding * 6,
                        ),
                        BusyButton(
                          busy: model.inProcess,
                          fontSize: (default_normal_font_size +
                                  default_big_font_size) /
                              2,
                          textColor: busyButtonTextColorLight,
                          height: 50,
                          title: "Borrow money",
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          buttonColor: primaryLightColor,
                          onPressed: () {
                            model.checkCurrentStatus(
                              height: height,
                              width: width,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
