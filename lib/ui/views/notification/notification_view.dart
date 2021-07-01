import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/models/notification/notification_data_model.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
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
    print(
      width * 0.4,
    );
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      onModelReady: (model) => model.onModelReady(
        notification,
        deleteNotificationCallBack,
      ),
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) => Scaffold(
        body: model.isBusy
            ? Center(
                child: loader,
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: horizontal_padding * 1.5,
                    right: horizontal_padding * 1.5,
                    top: vertical_padding * 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 200,
                          minHeight: 120,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 160,
                                maxHeight: 160,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/PrestoLogo.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 170,
                              ),
                              child: Container(
                                width: width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    RichText(
                                      softWrap: true,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: (default_headers +
                                                  default_big_font_size) /
                                              2,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "Creditworthy Score: ",
                                          ),
                                          TextSpan(
                                            text: notification.borrowerRating
                                                .toStringAsPrecision(3),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Text(
                        'Amount Requested : \u20B9${notification.amount}',
                        style: TextStyle(
                          fontSize: (default_headers + banner_font_size) / 2,
                          fontWeight: FontWeight.bold,
                          color: authButtonColorLight,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'A fellow \n${locator<UserDataProvider>().platformData!.community}\'ian is \ncalling...',
                          softWrap: true,
                          style: TextStyle(
                            fontSize: default_headers,
                            fontWeight: FontWeight.w600,
                            color: authButtonColorLight,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.23,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Center(
                              child: Text(
                                'Decline',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: (default_big_font_size +
                                          default_headers) /
                                      2,
                                ),
                              ),
                            ),
                          ),
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
                            },
                            child: Container(
                              width: width / 3.5,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: (default_big_font_size +
                                            default_headers) /
                                        2,
                                  ),
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
      ),
    );
  }
}
