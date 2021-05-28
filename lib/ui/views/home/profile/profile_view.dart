import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/ListToken.dart';
import 'package:stacked/stacked.dart';
import 'package:share/share.dart';
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
        return GestureDetector(
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
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
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
                                bottomLeft: Radius.circular(width/15),
                                bottomRight: Radius.circular(width/15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        top: height/75, left: width/30, bottom: height/150),
                                    child: Container(
                                      //height: MediaQuery.of(context).size.height/17,
                                      width: width / 1.7,
                                      child: Text(
                                        'Jos Butler',
                                        style: TextStyle(
                                            fontSize: height/30,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: height/150,
                                      left: width/30,
                                    ),
                                    child: Text(
                                      'josbutler@engcric.co.uk',
                                      style: TextStyle(
                                          fontSize: height/45,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                            top: height/130,
                                            left: width/20,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.power_settings_new,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              //Sign Out
                                              //model.signOut();
                                            },
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: height/130,
                                          left: width/20,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: Colors.white,
                                          ),
                                          onPressed: (){},
                                          // onPressed: () async {
                                          //   final RenderObject? box =
                                          //   context.findRenderObject();
                                          //   String text =
                                          //   await model.getShareText();
                                          //   Share.share(
                                          //       text +
                                          //           "\nPlease enter this referral code ${model.user.referralCode}",
                                          //       subject:
                                          //       "Download New Presto Mobile App Now!!",
                                          //       sharePositionOrigin:
                                          //       box.localToGlobal(
                                          //           Offset.zero) &
                                          //       box.size);
                                          //   },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: height/25,
                                    bottom: height/25,
                                    left: height/75,
                                    right: height/75),
                                child: CircleAvatar(
                                  radius: width/6.5,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                      'assets/images/PrestoLogo.png'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height/15,
                      ),
                      Column(
                        children: <Widget>[
                          ListToken(
                            name: 'Contact Number',
                            icon: Icons.phone,
                            trailName: '1223455679'
                          ),
                          ListToken(
                            name: 'Community Name',
                            icon: Icons.people,
                            trailName: 'RVCEians United',
                          ),
                          ListToken(
                            name: 'Total Amount Borrowed',
                            icon: Icons.attach_money,
                            trailName:
                            '₹ 0',
                          ),
                          ListToken(
                            name: 'Total Amount Lent',
                            icon: Icons.monetization_on,
                            trailName: '₹ 0',
                          ),
                          ListToken(
                            name: 'Most Used Mode',
                            icon: Icons.chrome_reader_mode,
                            trailName: 'Paytm',
                          ),
                          ListToken(
                            name: 'Community Code',
                            icon: Icons.info,
                            trailName: 'kuch bhi dedo'
                          ),
                          ListToken(
                            name: 'Creditworthy score',
                            icon: Icons.credit_card_rounded,
                            trailName: '0',
                          ),
                          ListToken(
                            name: 'Presto Coins',
                            icon: Icons.money,
                            trailName: '0',
                          ),
                          SizedBox(
                            height: height / 18,
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(width/15))),
                        height: height / 10,
                        width: width / 1.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                //model.navigateToRefereesListView();
                              },
                              child: Center(
                                child: Text(
                                  "Referees",
                                  style: TextStyle(
                                    fontSize: height/50,
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
                                    fontSize: height/50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 18,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ),
        );
      },
    );
  }
}
