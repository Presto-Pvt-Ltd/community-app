import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:stacked/stacked.dart';
import 'lend_viewModel.dart';

class LendView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const LendView({Key? key, required this.slideChangeView}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<LendViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(slideChangeView),
      viewModelBuilder: () => LendViewModel(),
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
            child: SafeArea(
              child: Scaffold(
                body: model.dataReady || !model.isBusy
                    ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 25,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'All Notifications',
                          style:
                          TextStyle(color: Colors.black, fontSize: height/22),
                        ),
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      Container(),
                      // notificationListCard( , height, width),
                    ],
                  ),
                )
                     : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ));
      },
    );
  }
}
