import 'package:flutter/material.dart';
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
        return model.isBusy
            ? Scaffold(
                body: Center(
                  child: Container(
                    child: FadingText(
                      'Loading list...',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              )
            : SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05

                            ///Height according to Referees List
                            // model.refereeListManager.refereeList.length == 0
                            //     ? height / 3.0
                            //     : height / 20.0,
                            ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Referees List",
                            style: TextStyle(
                                color: Colors.black, fontSize: width / 10),
                          ),
                        ),
                        SizedBox(
                          height: height / 35,
                        ),

                        ///A bool to check if there are any referees
                        model.refereeList.length == 0
                            ? Center(
                                child: Text(
                                  "You haven't referred us to anyone!! \nRefer Someone and view them here.",
                                  style: TextStyle(
                                      fontSize: width / 20,
                                      color: Colors.black),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: model.refereeList.length,

                                ///Enter item count
                                //model.refereeListManager.refereeList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 5.0,
                                    child: Padding(
                                      padding: EdgeInsets.all(width / 45),
                                      child: ExpansionTile(
                                        title: Text(
                                          ///Display name of Referees
                                          model.refereeList[index].name!,
                                          style:
                                              TextStyle(fontSize: width / 25),
                                        ),
                                        children: [
                                          SizedBox(
                                            height: height / 60,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: width / 20),
                                                child: Text("Email"),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width / 20),
                                                child: Text(
                                                  ///Displaying referee email
                                                  model.refereeList[index]
                                                      .email!,
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
                                                    left: width / 20),
                                                child: Text("Contact"),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width / 20),
                                                child: Text(
                                                  ///Displaying Referee Contact
                                                  model.refereeList[index]
                                                      .contact!,
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
                                                    left: width / 20),
                                                child: Text("Referral Code"),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width / 20),
                                                child: Text(
                                                  model.refereeList[index]
                                                      .referralCode!,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
