import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'profileDetailsViewModel.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ProfileDetailsViewModel>.reactive(
      viewModelBuilder: () => ProfileDetailsViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(model.title),
          ),
        );
      },
    );
  }
}
