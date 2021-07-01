import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'no-internet_viewModel.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<NoInternetViewModel>.reactive(
      viewModelBuilder: () => NoInternetViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            title: Text("Error"),
          ),
          body: Center(
            child: Text(
              "Please Check Your Internet Connectivity !!",
              softWrap: true,
            ),
          ),
        );
      },
    );
  }
}
