import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
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
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 60,
            centerTitle: true,
            title: Text(
              "Contact Us",
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
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontal_padding,
              vertical: vertical_padding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.6,
                  color: blue98,
                  child: TextFormField(
                    minLines: 30,
                    maxLines: 50,
                    controller: model.message,
                    decoration: InputDecoration(
                      hintText: "We would like to hear from you...",
                    ),
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
                    textColor: busyButtonTextColorLight,
                    buttonColor: primaryLightSwatch[900],
                    title: "Send",
                    busy: model.isBusy,
                    fontSize: default_normal_font_size,
                    onPressed: model.sendMessage,
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
