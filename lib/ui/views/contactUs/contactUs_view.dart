import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:stacked/stacked.dart';

import 'contactUs_viewModel.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ContactUsViewModel>.reactive(
      viewModelBuilder: () => ContactUsViewModel(),
      builder: (context, model, child) {
        return Material(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Let us know what's in your mind.",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: height * 0.6,
                  width: width * 0.9,
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: model.message,
                    decoration:
                        InputDecoration(hintText: "Enter your message here."),
                  ),
                ),
                Container(
                  height: height * 0.07,
                  width: width * 0.3,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BusyButton(
                    textColor: Colors.white,
                    buttonColor: primaryLightSwatch[900],
                    title: "Send",
                    busy: model.isBusy,
                    onPressed: model.sendMessage,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
