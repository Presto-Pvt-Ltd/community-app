import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/database/dataProviders/limits_data_provider.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/widgets/ListToken.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'profile_viewModel.dart';

class ProfileView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const ProfileView({Key? key, required this.slideChangeView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(slideChangeView),
      viewModelBuilder: () => ProfileViewModel(),
      disposeViewModel: false,
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        print("-----------------------------------\n\n");
        print(!model.gotData || model.isBusy);
        print(model.gotData);
        print(model.isBusy);
        print("\n\n-----------------------------------");
        return GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            print(dragEndDetails.velocity);
            print(dragEndDetails.primaryVelocity);
            if (!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative &&
                dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300) {
              model.callback(false);
            } else if (dragEndDetails.velocity.pixelsPerSecond.dx.abs() > 300 &&
                dragEndDetails.velocity.pixelsPerSecond.dx.isNegative) {
              model.callback(true);
            }
            print('end');
          },
          child: model.isBusy
              ? Center(
                  child: loader,
                )
              : ListView(
                  padding: const EdgeInsets.only(
                    left: horizontal_padding,
                    right: horizontal_padding,
                    top: vertical_padding,
                  ),
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 200,
                        maxHeight:
                            width / MediaQuery.of(context).size.aspectRatio,
                        maxWidth: width * 0.9,
                      ),
                      child: Container(
                        height: height * 0.3,
                        width: width - 2 * horizontal_padding,
                        decoration: BoxDecoration(
                          color: primaryLightSwatch[900],
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: <Widget>[
                            //     SizedBox(
                            //       height: height / 30,
                            //     ),
                            //     Padding(
                            //       padding: EdgeInsets.only(
                            //           top: height / 75,
                            //           left: width / 30,
                            //           bottom: height / 150),
                            //       child: Container(
                            //         //height: MediaQuery.of(context).size.height/17,
                            //         width: width / 1.7,
                            //         child: Text(
                            //           model.personalData.name,
                            //           style: TextStyle(
                            //               fontSize: height / 30,
                            //               color: Colors.white),
                            //         ),
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: EdgeInsets.only(
                            //         top: height / 150,
                            //         left: width / 30,
                            //       ),
                            //       child: Text(
                            //         model.personalData.email,
                            //         style: TextStyle(
                            //             fontSize: height / 45,
                            //             color: Colors.white),
                            //       ),
                            //     ),
                            //     Row(
                            //       children: [
                            //         Padding(
                            //             padding: EdgeInsets.only(
                            //               top: height / 130,
                            //               left: width / 20,
                            //             ),
                            //             child: IconButton(
                            //               icon: Icon(
                            //                 Icons.power_settings_new,
                            //                 color: Colors.white,
                            //               ),
                            //               onPressed: () {
                            //                 ///Sign Out
                            //                 model.signOut();
                            //               },
                            //             )),
                            //         Padding(
                            //           padding: EdgeInsets.only(
                            //             top: height / 130,
                            //             left: width / 20,
                            //           ),
                            //           child: IconButton(
                            //             icon: Icon(
                            //               Icons.share,
                            //               color: Colors.white,
                            //             ),
                            //             onPressed: () async {
                            //               String text =
                            //                   await model.getShareText();
                            //               Share.share(
                            //                 text +
                            //                     "\nPlease enter this referral code ${locator<UserDataProvider>().platformData!.referralCode}",
                            //                 subject:
                            //                     "Download New Presto Mobile App Now!!",
                            //               );
                            //             },
                            //           ),
                            //         ),
                            //       ],
                            //     )
                            //   ],
                            // ),
                            Text(
                              "Presto",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: height * 0.04,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 15,
                    ),
                    // Column(
                    //   children: <Widget>[
                    //     ListToken(
                    //       name: 'Contact Number',
                    //       icon: Icons.phone,
                    //       trailName: model.personalData.contact,
                    //     ),
                    //     ListToken(
                    //       name: 'Community Name',
                    //       icon: Icons.people,
                    //       trailName: model.platformData.community,
                    //     ),
                    //     ListToken(
                    //       name: 'Total Amount Borrowed',
                    //       icon: Icons.attach_money,
                    //       trailName: '₹' +
                    //           model.transactionData.totalBorrowed.toString(),
                    //     ),
                    //     ListToken(
                    //       name: 'Total Amount Lent',
                    //       icon: Icons.monetization_on,
                    //       trailName: '₹' +
                    //           model.transactionData.totalLent.toString(),
                    //     ),
                    //     ListToken(
                    //       name: 'Most Used Mode',
                    //       icon: Icons.chrome_reader_mode,
                    //       trailName: 'Paytm',
                    //     ),
                    //     ListToken(
                    //       name: 'Community Code',
                    //       icon: Icons.info,
                    //       trailName: model.platformData.referralCode,
                    //     ),
                    //     ListToken(
                    //       name: 'Creditworthy score',
                    //       icon: Icons.credit_card_rounded,
                    //       trailName: ((model.platformRatings.communityScore +
                    //                   model.platformRatings.personalScore) *
                    //               0.5)
                    //           .toStringAsPrecision(3),
                    //     ),
                    //     ListToken(
                    //       name: 'Presto Coins',
                    //       icon: Icons.money,
                    //       trailName:
                    //           model.platformRatings.prestoCoins.toString(),
                    //     ),
                    //     SizedBox(
                    //       height: height / 18,
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            String text = await model.getShareText();
                            Share.share(
                              text +
                                  "\nPlease enter this referral code ${locator<UserDataProvider>().platformData!.referralCode}",
                              subject: "Download New Presto Mobile App Now!!",
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryLightSwatch[900],
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            height: height * 0.08,
                            width: width * 0.37,
                            child: Center(
                              child: Text(
                                "Invite (${(locator<LimitsDataProvider>().referralLimit?.refereeLimit ?? 15) - (locator<UserDataProvider>().platformData?.referredTo.length ?? 0)})",
                                style: TextStyle(
                                  fontSize: (default_big_font_size +
                                          default_normal_font_size) /
                                      2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            model.redeemCode(height, width);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryLightSwatch[900],
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            height: height * 0.08,
                            width: width * 0.37,
                            child: Center(
                              child: Text(
                                "Redeem",
                                style: TextStyle(
                                  fontSize: (default_big_font_size +
                                          default_normal_font_size) /
                                      2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
