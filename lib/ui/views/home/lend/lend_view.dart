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
          child: Scaffold(
            body: model.dataReady || !model.isBusy ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: width/5.5,
                      child: Text('Local Icon',
                          style:
                          TextStyle(color: Colors.white, fontSize: 25.0)),
                    ),
                    SizedBox(
                      width: width/50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Creditworthy Score: 5.0',
                          style: TextStyle(
                            fontSize: height/45,
                          ),
                        ),
                        Text(
                          'Mode of payment: PayTM',
                          style: TextStyle(
                            fontSize: height/45,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: height / 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width/25),
                  child: Text(
                    //'Amount Requested : ${widget.notification.amount}',
                    'Amount Requested : 20',
                    style:
                    TextStyle(fontSize: height/20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: width / 2,
                  child: Divider(
                    color: primaryColor,
                    thickness: height/100,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width/20, top: width/19),
                  child: Container(
                    width: width / 2,
                    child: Text(
                      'A fellow RVCE\'ian is calling...',
                      style: TextStyle(
                        fontSize: height/27,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 4,
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: width / 2,
                        height: height / 15,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            'Yes',
                            style:
                            TextStyle(color: Colors.white, fontSize: height/45),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        width: width / 2,
                        height: height / 15,
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            'No',
                            style:
                            TextStyle(color: Colors.white, fontSize: height/45),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )   : Center(
                  child: CircularProgressIndicator(),
                ),
          )
        );
      },
    );
  }
}
