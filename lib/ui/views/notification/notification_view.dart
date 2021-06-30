import 'package:flutter/material.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:stacked/stacked.dart';
import '../../../models/enums.dart';
import '../../widgets/paymentSheet.dart';
import 'notification_viewModel.dart';

class NotificationView extends StatelessWidget {
  final CustomNotification notification;
  final deleteNotificationCallBack;
  const NotificationView({
    Key? key,
    required this.notification,
    required this.deleteNotificationCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<PaymentMethods> paymentMethods = notification.paymentMethods;
    String paymentMethodsString = '';
    paymentMethods.forEach((element) {
      paymentMethodsString += PaymentMethodsMap[element]!;
    });
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      onModelReady: (model) => model.onModelReady(
        notification,
        deleteNotificationCallBack,
      ),
      disposeViewModel: false,
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: model.isBusy
              ? Center(
                  child: loader,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: width / 6.5,
                            child: Image.asset('assets/images/PrestoLogo.png')),
                        SizedBox(
                          width: width / 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Creditworthy Score: ${notification.borrowerRating.toStringAsPrecision(3)}',
                              style: TextStyle(
                                fontSize: height / 45,
                              ),
                            ),
                            Container(
                              height: height / 10,
                              width: width / 2,
                              child: Text(
                                'Mode of payment: $paymentMethodsString',
                                style: TextStyle(
                                  fontSize: height / 45,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: height / 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width / 25),
                      child: Text(
                        //'Amount Requested : ${widget.notification.amount}',
                        'Amount Requested : ${notification.amount}',
                        style: TextStyle(
                            fontSize: height / 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: width / 2,
                      child: Divider(
                        color: primaryLightColor,
                        thickness: height / 100,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: width / 20, top: width / 19),
                      child: Container(
                        width: width / 2,
                        child: Text(
                          'A fellow RVCE\'ian is calling...',
                          style: TextStyle(
                            fontSize: height / 27,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => paymentSheet(
                                height: height,
                                width: width,
                                onCompleteCallBack: model.initiateTransaction,
                                onCancel: model.cancel,
                              ),
                            );
                            print(
                                "Notification yes card button dabaya gaya hai");
                          },
                          child: Container(
                            width: width / 3.5,
                            height: height / 12,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(width / 15))),
                            child: Center(
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                    color: Colors.white, fontSize: height / 45),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            width: width / 3.5,
                            height: height / 12,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(width / 15))),
                            child: Center(
                              child: Text(
                                'Decline',
                                style: TextStyle(
                                    color: Colors.white, fontSize: height / 45),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
