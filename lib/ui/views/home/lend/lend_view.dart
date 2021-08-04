import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/notificationCard.dart';
import 'package:stacked/stacked.dart';
import '../../../../app/app.router.dart';
import '../../../widgets/paymentSheet.dart';
import 'lend_viewModel.dart';

class LendView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const LendView({Key? key, required this.slideChangeView}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<LendViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(slideChangeView),
      viewModelBuilder: () => LendViewModel(),
      disposeViewModel: false,
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        return GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            print(dragEndDetails.velocity);
            print(dragEndDetails.primaryVelocity);
            if (!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative &&
                dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300) {
              model.callback(false);
            } else if (dragEndDetails.velocity.pixelsPerSecond.dx.isNegative &&
                dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300) {
              if (!locator<UserDataProvider>().platformData!.isCommunityManager)
                model.callback(true);
            }
            print('end');
          },
          child: model.dataReady || !model.isBusy
              ? Container(
                  color: backgroundColorLight,
                  child: Column(
                    children: [
                      model.notifications.length == 0
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'No new notifications',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: height * 0.022,
                                ),
                              ),
                            )
                          : Container(
                              height: height * 0.6,
                              child: ListView.builder(
                                itemCount: model.notifications.length,
                                itemBuilder: (context, index) {
                                  return notificationCard(
                                      // paymentOptions: model
                                      //     .notifications[index]
                                      //     .paymentMethods,
                                      amount: model.notifications[index].amount
                                          .toString(),
                                      score: model
                                          .notifications[index].borrowerRating
                                          .toStringAsPrecision(3),
                                      height: height,
                                      width: width,
                                      handShakeCallBack: () {
                                        // showModalBottomSheet(
                                        //   context: context,
                                        //   isScrollControlled: true,
                                        //   backgroundColor: Colors.transparent,
                                        //   builder: (context) => paymentSheet(
                                        //     customNotification:
                                        //         model.notifications[index],
                                        //     height: height,
                                        //     width: width,
                                        //     onCompleteCallBack:
                                        //         model.initiateTransaction,
                                        //     onCancel: model.cancel,
                                        //   ),
                                        // );
                                        model.initiateTransaction(
                                          model.notifications[index],
                                          [],
                                        );
                                        print("Trying handshake");
                                      },
                                      onTap: () {
                                        model.navigationService.navigateTo(
                                          Routes.notificationView,
                                          arguments: NotificationViewArguments(
                                              notification:
                                                  model.notifications[index],
                                              deleteNotificationCallBack:
                                                  model.deleteNotification),
                                        );
                                        print('Mujhe Dabaya Gaya Hai');
                                      });
                                },
                              ),
                            ),
                      // notificationListCard( , height, width),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
