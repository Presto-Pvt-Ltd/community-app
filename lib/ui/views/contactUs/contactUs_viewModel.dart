import 'package:flutter/material.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/ui/widgets/dialogBox.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:stacked_services/stacked_services.dart';

class ContactUsViewModel extends BaseViewModel {
  final log = getLogger("Contact Us");

  final TextEditingController message = TextEditingController();

  void sendMessage() async {
    try {
      setBusy(true);
      final Email email = Email(
        body: message.text,
        subject: 'Presto customer message',
        recipients: [
          'kushgupta410@gmail.com',
          'jainshubham1007@gmail.com',
          'reshubolla@gmail.com',
          'sushrutpatwardhan@gmail.com',
        ],
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
      setBusy(false);
      showCustomDialog(
        title: "Sent",
        description:
            "Your message has been recieved by Presto. Please wait for follow up",
      );
      locator<NavigationService>().back();
    } catch (e) {
      setBusy(false);
      showCustomDialog(
        title: "Error",
        description:
            "There was some error in sending the message. Please try again later.",
      );
    }
  }
}
