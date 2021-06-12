import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/shared/colors.dart';
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
          child: Scaffold(
            body: model.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: height / 4.25),
                          child: Container(
                            //height: MediaQuery.of(context).size.height/4,
                            width: width,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(width / 15),
                                  bottomRight: Radius.circular(width / 15)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: height / 30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 75,
                                          left: width / 30,
                                          bottom: height / 150),
                                      child: Container(
                                        //height: MediaQuery.of(context).size.height/17,
                                        width: width / 1.7,
                                        child: Text(
                                          model.personalData.name,
                                          style: TextStyle(
                                              fontSize: height / 30,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: height / 150,
                                        left: width / 30,
                                      ),
                                      child: Text(
                                        model.personalData.email,
                                        style: TextStyle(
                                            fontSize: height / 45,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                              top: height / 130,
                                              left: width / 20,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.power_settings_new,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                ///Sign Out
                                                model.signOut();
                                              },
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: height / 130,
                                            left: width / 20,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.share,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                              String text =
                                                  await model.getShareText();
                                              Share.share(
                                                text +
                                                    "\nPlease enter this referral code ${locator<UserDataProvider>().platformData!.referralCode}",
                                                subject:
                                                    "Download New Presto Mobile App Now!!",
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: height * 0.09,
                                    bottom: height / 25,
                                    left: width * 0.05,
                                    right: width * 0.06,
                                  ),
                                  child: Text(
                                    "Presto",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: height * 0.04,
                                    ),
                                  ),
                                  // child: CircleAvatar(
                                  //   radius: width / 6.5,
                                  //   backgroundColor: Colors.white,
                                  //   child: Image.asset(
                                  //     'assets/images/PrestoLogo.png',
                                  //   ),

                                  // ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 15,
                        ),
                        Column(
                          children: <Widget>[
                            ListToken(
                              name: 'Contact Number',
                              icon: Icons.phone,
                              trailName: model.personalData.contact,
                            ),
                            ListToken(
                              name: 'Community Name',
                              icon: Icons.people,
                              trailName: model.platformData.community,
                            ),
                            ListToken(
                              name: 'Total Amount Borrowed',
                              icon: Icons.attach_money,
                              trailName: '₹' +
                                  model.transactionData.totalBorrowed
                                      .toString(),
                            ),
                            ListToken(
                              name: 'Total Amount Lent',
                              icon: Icons.monetization_on,
                              trailName: '₹' +
                                  model.transactionData.totalLent.toString(),
                            ),
                            ListToken(
                              name: 'Most Used Mode',
                              icon: Icons.chrome_reader_mode,
                              trailName: 'Paytm',
                            ),
                            ListToken(
                              name: 'Community Code',
                              icon: Icons.info,
                              trailName: model.platformData.referralCode,
                            ),
                            ListToken(
                              name: 'Creditworthy score',
                              icon: Icons.credit_card_rounded,
                              trailName: ((model
                                              .platformRatings.communityScore +
                                          model.platformRatings.personalScore) *
                                      0.5)
                                  .toStringAsPrecision(3),
                            ),
                            ListToken(
                              name: 'Presto Coins',
                              icon: Icons.money,
                              trailName:
                                  model.platformRatings.prestoCoins.toString(),
                            ),
                            SizedBox(
                              height: height / 18,
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(width / 15),
                            ),
                          ),
                          height: height * 0.085,
                          width: width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Mujhe dabaya gaya hai");

                                  ///Add a Navigator method
                                  model.goToMyReferees();
                                },
                                child: Center(
                                  child: Text(
                                    "Referees",
                                    style: TextStyle(
                                      fontSize: height / 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                              ),
                              GestureDetector(
                                onTap: () {
                                  //model.popUpForRedeemButton();
                                },
                                child: Center(
                                  child: Text(
                                    "Redeem Presto Coins",
                                    style: TextStyle(
                                      fontSize: height / 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        GestureDetector(
                          onTap: model.goToContactUs,
                          child: Text(
                            "Contact Us",
                            style: TextStyle(
                              fontSize: height / 47,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 18,
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
