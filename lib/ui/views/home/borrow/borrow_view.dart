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
                : ListView(
                    children: [
                      Container(
                        width: width,
                        height: height * 0.2,
                        decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(width / 15),
                                bottomLeft: Radius.circular(width / 15))),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: height / 22,
                            ),
                            Text(
                              "₹ ${model.amount.toInt().toString()}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: height / 15),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 25,
                      ),
                      Text(
                        'Present Amount',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: default_big_font_size,
                        ),
                      ),
                      SizedBox(height: height / 40),
                      Padding(
                        padding: EdgeInsets.only(
                          right: width / 8.7,
                          left: width / 8.7,
                        ),
                        child: Row(
                          children: <Widget>[
                            AmountButton(
                                text: "+50",
                                onTap: () => model.increaseAmount(50)
                                // onTap: () => model.increaseAmount(50.0),
                                ),
                            AmountButton(
                              text: "+100",
                              onTap: () => model.increaseAmount(100),
                              // onTap: () => model.increaseAmount(100.0),
                            ),
                            AmountButton(
                              text: "+150",
                              onTap: () => model.increaseAmount(150),
                              // onTap: () => model.increaseAmount(150.0),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: width / 8.7, left: width / 8.7),
                        child: Row(
                          children: <Widget>[
                            AmountButton(
                              text: "-50",
                              onTap: () => model.decreaseAmount(50),
                              // onTap: () => model.decreaseAmount(50.0),
                            ),
                            AmountButton(
                              text: "-100",
                              onTap: () => model.decreaseAmount(100),
                              // onTap: () => model.decreaseAmount(100.0),
                            ),
                            AmountButton(
                              text: "-150",
                              onTap: () => model.decreaseAmount(150),
                              // onTap: () => model.decreaseAmount(150.0),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
                      Text(
                        'Set Amount Manually',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: default_big_font_size,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height / 30,
                          right: width / 80.7,
                          left: width / 80.7,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: primaryLightColor,
                                inactiveTrackColor: Color(0xFF8D8E98),
                                overlayColor: Color(0x29EB1555),
                                thumbColor: primaryLightColor,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: height / 45),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: height / 40),
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
                                    1,
                                onChanged: (double newValue) {
                                  print("Changing the value");
                                  model.setAmount(newValue);
                                },
                              ),
                            ),
                            Text(
                              "₹ ${model.amount.toInt().toString()}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: banner_font_size * 0.75,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 20,
                      ),
                      Container(
                        width: width,
                        alignment: Alignment.center,
                        child: BusyButton(
                          busy: model.inProcess,
                          fontSize: (default_normal_font_size + default_big_font_size)/2,
                          textColor: Colors.white,
                          height: height * 0.1,
                          width: width * 0.3,
                          title: "Get Paid!",
                          decoration: BoxDecoration(
                            color: primaryLightColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(width / 15.0),
                            ),
                          ),
                          onPressed: () {
                            model.checkCurrentStatus(
                              height: height,
                              width: width,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
