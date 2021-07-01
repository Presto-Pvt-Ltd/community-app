import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/views/referees/referees_viewModel.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:stacked/stacked.dart';

class RefereesView extends StatelessWidget {
  const RefereesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RefereesViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      viewModelBuilder: () => RefereesViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 60,
            centerTitle: true,
            title: Text(
              "Referees List",
              style: TextStyle(
                fontSize: default_headers,
                fontWeight: FontWeight.bold,
                color: authButtonColorLight,
              ),
            ),
            backgroundColor: appBarColorLight,
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
                    color: authButtonColorLight,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: backgroundColorLight,
          body: model.isBusy
              ? Center(
                  child: Container(
                    child: FadingText(
                      'Loading list...',
                      style: TextStyle(
                          fontSize: default_big_font_size,
                          color: authButtonColorLight),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height / 35,
                      ),

                      ///A bool to check if there are any referees
                      model.refereeList.length == 0
                          ? Center(
                              child: Text(
                                "You haven't referred us to anyone!! \nRefer Someone and view them here.",
                                style: TextStyle(
                                  fontSize: default_big_font_size,
                                  color: authButtonColorLight,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.refereeList.length,

                              ///Enter item count
                              //model.refereeListManager.refereeList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: horizontal_padding,
                                    right: horizontal_padding,
                                    bottom: vertical_padding,
                                  ),
                                  child: Card(
                                    elevation: 5.0,
                                    color: blue98,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: horizontal_padding,
                                        vertical: vertical_padding * 0.5,
                                      ),
                                      child: ExpansionTile(
                                        backgroundColor: blue98,
                                        collapsedBackgroundColor: blue98,
                                        title: Text(
                                          model.refereeList[index].name!,
                                          style: TextStyle(
                                            fontSize: default_big_font_size,
                                            color: Colors.black,
                                          ),
                                        ),
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: width / 20,
                                                ),
                                                child: Text(
                                                  "Email",
                                                  style: TextStyle(
                                                    fontSize:
                                                        (default_normal_font_size +
                                                                default_big_font_size) /
                                                            2,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: horizontal_padding,
                                                ),
                                                child: Text(
                                                  ///Displaying referee email
                                                  model.refereeList[index]
                                                      .email!,
                                                  style: TextStyle(
                                                    color: primaryLightColor,
                                                    fontSize:
                                                        (default_normal_font_size +
                                                                default_big_font_size) /
                                                            2,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: width / 20,
                                                ),
                                                child: Text(
                                                  "Contact",
                                                  style: TextStyle(
                                                    fontSize:
                                                        (default_normal_font_size +
                                                                default_big_font_size) /
                                                            2,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: horizontal_padding,
                                                ),
                                                child: Text(
                                                  ///Displaying Referee Contact
                                                  model.refereeList[index]
                                                      .contact!,
                                                  style: TextStyle(
                                                    color: primaryLightColor,
                                                    fontSize:
                                                        (default_normal_font_size +
                                                                default_big_font_size) /
                                                            2,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: width / 20,
                                                ),
                                                child: Text(
                                                  "Score",
                                                  style: TextStyle(
                                                    fontSize:
                                                        (default_normal_font_size +
                                                                default_big_font_size) /
                                                            2,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: horizontal_padding,
                                                ),
                                                child: Text(
                                                  ///Displaying Referee Contact
                                                  model
                                                      .refereeList[index].score!
                                                      .toStringAsPrecision(3),
                                                  style: TextStyle(
                                                    color: primaryLightColor,
                                                    fontSize:
                                                        (default_normal_font_size +
                                                                default_big_font_size) /
                                                            2,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: vertical_padding,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
