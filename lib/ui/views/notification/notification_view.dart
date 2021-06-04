import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:stacked/stacked.dart';
import '../../../models/enums.dart';
import '../../../models/enums.dart';
import 'notification_viewModel.dart';

class NotificationView extends StatelessWidget {
  final CustomNotification notification;
  const NotificationView({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<PaymentMethods> paymentMethods = notification.paymentMethods;
    String paymentMethodsString = '';
    for(int i=0; i < paymentMethods.length; i++){
      paymentMethodsString = paymentMethodsToString(paymentMethods[i]);
    }
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      onModelReady: (model) => model.onModelReady(notification),
      disposeViewModel: false,
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
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
                    child: Image.asset('assets/images/PrestoLogo.png')
                  ),
                  SizedBox(
                    width: width / 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Creditworthy Score: 5.0',
                        style: TextStyle(
                          fontSize: height / 45,
                        ),
                      ),
                      Text(
                        'Mode of payment: $paymentMethodsString',
                        style: TextStyle(
                          fontSize: height / 45,
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
                  color: primaryColor,
                  thickness: height / 100,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width / 20, top: width / 19),
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
                children: [
                  GestureDetector(
                    child: Container(
                      width: width / 2,
                      height: height / 15,
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white, fontSize: height / 45),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: width / 2,
                      height: height / 15,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          'No',
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
