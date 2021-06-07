import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/amountButton.dart';
import 'package:presto/ui/widgets/busyButton.dart';
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
              body: model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            height: height / 3.7,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(width / 15),
                                    bottomLeft: Radius.circular(width / 15))),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: height / 20,
                                ),
                                Text(
                                  'Amount Demanded',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 25),
                                ),
                                SizedBox(
                                  height: height / 22,
                                ),
                                Text(
                                  "₹ ${model.amount.toInt().toString()}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height / 15),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 25,
                          ),
                          Text(
                            'Present Amount',
                            style: TextStyle(
                                color: Colors.black, fontSize: height / 35),
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
                            style: TextStyle(
                                fontSize: height / 35, color: Colors.black),
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
                                    activeTrackColor: primaryColor,
                                    inactiveTrackColor: Color(0xFF8D8E98),
                                    overlayColor: Color(0x29EB1555),
                                    thumbColor: primaryColor,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: height / 45),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: height / 40),
                                  ),
                                  child: Slider(
                                    value: model.amount,
                                    max: model.transactionLimits != null
                                        ? model
                                            .transactionLimits!.borrowUpperLimit
                                            .toDouble()
                                        : 1000.0,
                                    min: model.transactionLimits != null
                                        ? model
                                            .transactionLimits!.borrowLowerLimit
                                            .toDouble()
                                        : 0.0,
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
                                    fontSize: height / 25,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 20,
                          ),
                          BusyButton(
                            busy: model.inProcess,
                            textColor: Colors.white,
                            height: height / 10,
                            width: width / 3,
                            title: "Get Paid!",
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width / 15.0)),
                            ),
                            // onPressed: () => showModalBottomSheet(
                            //     context: context,
                            //     isScrollControlled: true,
                            //     backgroundColor: Colors.transparent,
                            //     builder: (context) => paymentSheet(height,width)
                            // )
                            //busy: model.isBusy || model.borrowingLimits == null,
                            onPressed: () {
                              model.amount = 100;
                              model.initiateBorrowRequest();
                            },
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
