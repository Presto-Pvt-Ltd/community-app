import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'notifications_viewModel.dart';

class NotificationsView extends StatelessWidget {
  final void Function(bool) slideChangeView;
  const NotificationsView({Key? key, required this.slideChangeView}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<NotificationsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(slideChangeView),
      viewModelBuilder: () => NotificationsViewModel(),
      disposeViewModel: false,
      // Indicate that we only want to initialise a specialty viewModel once
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        return GestureDetector(
          onHorizontalDragEnd: (dragEndDetails){
            print(dragEndDetails.velocity);
            print(dragEndDetails.primaryVelocity);
            if(!dragEndDetails.velocity.pixelsPerSecond.dx.isNegative){
              model.callback(false);
            }else{
              model.callback(true);
            }
            print('end');
          },
          child: Scaffold(
            body: Center(
              child: Text(model.title),
            ),
          ),
        );
      },
    );
  }
}
