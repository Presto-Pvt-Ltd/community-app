import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'transactions_viewModel.dart';

class TransactionsView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const TransactionsView({Key? key, required this.slideChangeView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<TransactionsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(slideChangeView),
      viewModelBuilder: () => TransactionsViewModel(),
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
                : Center(
                    child: Column(
                      children: [
                        Text(model.transactions!.length.toString()),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
