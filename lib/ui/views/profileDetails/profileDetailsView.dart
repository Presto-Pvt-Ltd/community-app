import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:stacked/stacked.dart';

import 'profileDetailsViewModel.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ProfileDetailsViewModel>.reactive(
      viewModelBuilder: () => ProfileDetailsViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: primaryLightColor,
            elevation: 0.0,
            // centerTitle: true,
            // title: Text(
            //   "Presto",
            //   style: TextStyle(
            //     fontSize: default_headers,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            leading: GestureDetector(
              onTap: () {
                model.pop();
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: actions_icon_size,
                  height: actions_icon_size * 0.7,
                  child: SvgPicture.asset(
                    "assets/icons/left-arrow.svg",
                    fit: BoxFit.fitHeight,
                    // color: authButtonColorLight,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          body: locator<UserDataProvider>().personalData == null
              ? Center(
                  child: loader,
                )
              : SingleChildScrollView(
                  child: Container(
                    color: backgroundColorLight,
                    height: height - MediaQuery.of(context).viewInsets.vertical,
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: 100,
                          ),
                          height: height * 0.15,
                          color: primaryLightColor,
                        ),
                        Positioned(
                          top: 20,
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/PrestoLogo.png',
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                        offset: Offset(0, 0),
                                        color: shadowLight,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  locator<UserDataProvider>()
                                      .personalData!
                                      .name,
                                  style: TextStyle(
                                    fontSize: (default_big_font_size +
                                            default_headers) /
                                        2,
                                    color: authButtonColorLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: horizontal_padding),
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "Email Id",
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                          color: authButtonColorLight,
                                        ),
                                      ),
                                      Text(
                                        locator<UserDataProvider>()
                                            .personalData!
                                            .email,
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                          color: primaryLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: horizontal_padding),
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "Phone Number",
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                          color: authButtonColorLight,
                                        ),
                                      ),
                                      Text(
                                        locator<UserDataProvider>()
                                            .personalData!
                                            .contact,
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                          color: primaryLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: horizontal_padding),
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "Credit Worthy Score",
                                        style: TextStyle(
                                          fontSize: default_big_font_size,
                                          color: authButtonColorLight,
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
                                          fontSize: default_big_font_size,
                                          color: primaryLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.25,
                                ),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: BusyButton(
                                    title: "Log Out",
                                    onPressed: model.signOut,
                                    busy: model.isBusy,
                                    // onPressed: () => print("Helllo dababay a mujhe"),
                                    fontSize: default_big_font_size,
                                    textColor: busyButtonTextColorLight,
                                    buttonColor: primaryLightColor,
                                    width: 140,
                                    height: 60,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
