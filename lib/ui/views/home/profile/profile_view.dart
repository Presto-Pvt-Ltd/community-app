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
        late String nameForCard;
        if (locator<UserDataProvider>().personalData != null) {
          int index =
              locator<UserDataProvider>().personalData!.name.indexOf(" ");
          if (index + 3 !=
              locator<UserDataProvider>().personalData!.name.length) {
            index += 2;
            nameForCard = locator<UserDataProvider>()
                .personalData!
                .name
                .substring(0, index);
          } else {
            nameForCard = locator<UserDataProvider>().personalData!.name;
          }
          print(nameForCard);
        }
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
              : Container(
                  color: backgroundColorLight,
                  child: ListView(
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
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              height: height * 0.3,
                              width: width - 2 * horizontal_padding,
                              decoration: BoxDecoration(
                                color: primaryLightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: horizontal_padding,
                                vertical: vertical_padding,
                              ),
                            ),
                            Positioned(
                              top: vertical_padding * 3,
                              width: width - (horizontal_padding * 3),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: horizontal_padding,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "Presto",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: busyButtonTextColorLight,
                                        fontSize: default_headers,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          locator<UserDataProvider>()
                                              .platformData!
                                              .community,
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontSize: default_normal_font_size,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          "#" +
                                              locator<UserDataProvider>()
                                                  .platformData!
                                                  .referralCode,
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontWeight: FontWeight.w100,
                                            fontSize: default_normal_font_size,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -vertical_padding,
                              right: 0,
                              child: Container(
                                child: Text(
                                  nameForCard,
                                  style: TextStyle(
                                    fontSize: banner_font_size * 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: profileCardBackgroundTextColor,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: vertical_padding * 2,
                              width: width - (horizontal_padding * 3),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: horizontal_padding,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locator<UserDataProvider>()
                                              .personalData!
                                              .name,
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontSize: default_normal_font_size,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          ((locator<UserDataProvider>()
                                                          .platformRatingsData!
                                                          .communityScore +
                                                      locator<UserDataProvider>()
                                                          .platformRatingsData!
                                                          .personalScore) /
                                                  2)
                                              .toStringAsPrecision(3),
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontSize: (default_big_font_size +
                                                    default_headers) /
                                                2,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          "Credit Score",
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontWeight: FontWeight.w100,
                                            fontSize: default_small_font_size,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          locator<UserDataProvider>()
                                              .platformRatingsData!
                                              .prestoCoins
                                              .toInt()
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontSize: (default_big_font_size +
                                                    default_headers) /
                                                2,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          "Presto Coins",
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontWeight: FontWeight.w100,
                                            fontSize: default_small_font_size,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 15,
                      ),
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
                              width: width * 0.39,
                              child: Center(
                                child: Text(
                                  "Invite (${(locator<LimitsDataProvider>().referralLimit?.refereeLimit ?? 15) - (locator<UserDataProvider>().platformData?.referredTo.length ?? 0)})",
                                  style: TextStyle(
                                    fontSize: (default_big_font_size +
                                            default_normal_font_size) /
                                        2,
                                    color: busyButtonTextColorLight,
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
                              width: width * 0.39,
                              child: Center(
                                child: Text(
                                  "Redeem",
                                  style: TextStyle(
                                    fontSize: (default_big_font_size +
                                            default_normal_font_size) /
                                        2,
                                    color: busyButtonTextColorLight,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
