import 'package:flutter/material.dart';
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
            if (!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative) {
              model.callback(false);
            } else {
              model.callback(true);
            }
            print('end');
          },
          child: Scaffold(
            body: (!model.gotData || model.isBusy)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                      children: [
                        Text(model.personalData.name),
                        Text(model.platformData.referralCode),
                        Text(model.platformRatings.personalScore.toString()),
                        Text(model.transactionData.totalBorrowed.toString()),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
