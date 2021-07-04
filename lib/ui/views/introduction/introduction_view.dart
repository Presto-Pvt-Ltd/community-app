import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' as math;
import 'introduction_viewModel.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({
    Key? key,
    this.isFromDrawer = false,
  }) : super(key: key);
  final bool isFromDrawer;
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> listOfPages = [
      PageViewModel(
        title: "Get Started",
        body:
            "We are committed to build strong communities on mutual trust and support.",
        image: const Center(child: Icon(Icons.android)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.orange),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),
      PageViewModel(
        title: "Forget Credit Cards",
        body:
            "A highly innovative invite-only community-based P2P Lending platform serving all your credit needs with the click of a button.",
        image: const Center(child: Icon(Icons.android)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.orange),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),
      PageViewModel(
        title: "Innovative Credit Profiling",
        body:
            "Coming with an intelligent credit profiling algorithm to connect with the most creditworthy members of your community.",
        image: const Center(child: Icon(Icons.android)),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.orange),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),
    ];
    return ViewModelBuilder<IntroductionViewModel>.reactive(
      viewModelBuilder: () => IntroductionViewModel(),
      builder: (context, model, child) {
        return IntroductionScreen(
          color: authButtonColorLight,
          pages: listOfPages,
          onDone: () => model.gotToHomePage(isFromDrawer),
          next: Transform.rotate(
            angle: math.pi,
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
          done: const Text(
            "Done",
            style: TextStyle(
              fontSize: default_normal_font_size,
              fontWeight: FontWeight.w600,
              color: authButtonColorLight,
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        );
      },
    );
  }
}
