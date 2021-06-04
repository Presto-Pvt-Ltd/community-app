import 'package:flutter/material.dart';
import 'package:presto/models/transactions/custom_transaction_data_model.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/views/transaction/transaction_viewModel.dart';
import 'package:presto/ui/widgets/ListToken.dart';
import 'package:presto/ui/widgets/busyButton.dart';
import 'package:stacked/stacked.dart';

class TransactionView extends StatelessWidget {
  final CustomTransaction customTransaction;
  const TransactionView({
    Key? key,
    required this.customTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TransactionViewModel>.reactive(
      viewModelBuilder: () => TransactionViewModel(),
      disposeViewModel: false,
      onModelReady: (model) => model.onModelReady(customTransaction),
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        return SafeArea(
            child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 25,
              ),
              Center(
                child: Text(
                  '₹ 500',
                  style: TextStyle(fontSize: height / 15, color: primaryColor),
                ),
              ),
              SizedBox(
                height: height / 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Current Status:',
                    style: TextStyle(
                      fontSize: height / 30,
                    ),
                  ),
                  Text(
                    'In Progress',
                    style: TextStyle(
                      fontSize: height / 30,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height / 15,
              ),
              ListToken(
                  icon: Icons.date_range,
                  name: 'Date of Transaction:',
                  trailName: '05-01-2020'),
              Tooltip(
                message: 'Paytm, GPay, PayPal, PhonePay, AmazonPay',
                child: ListToken(
                    icon: Icons.chrome_reader_mode,
                    name: 'Modes of Payment',
                    trailName: 'Paytm, G...'),
              ),
              ListToken(
                icon: Icons.rate_review,
                name: 'Interest Rate',
                trailName: '0%',
              ),
              ListToken(
                icon: Icons.credit_card_rounded,
                name: 'Creditworthy Score',
                trailName: '5',
              ),
              SizedBox(
                height: height / 10,
              ),
              BusyButton(
                height: height / 10,
                width: width / 3,
                title: 'Payback',
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(width / 15))),
                textColor: Colors.white,
              )
            ],
          ),
        ));
      },
    );
  }
}
