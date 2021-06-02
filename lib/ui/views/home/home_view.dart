import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/views/home/profile/profile_view.dart';
import 'package:presto/ui/views/home/transactions/transactions_view.dart';
import 'package:stacked/stacked.dart';
import 'borrow/borrow_view.dart';
import 'home_viewModel.dart';
import 'lend/lend_view.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  int index;
  HomeView({Key? key, this.index = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        model.onModelReady(index);
      },
      builder: (context, model, child) {
        Widget getViewForIndex(int index) {
          switch (index) {
            case 0:
              return ProfileView(
                slideChangeView: model.slideChangeViews,
              );
            case 1:
              return BorrowView(
                slideChangeView: model.slideChangeViews,
              );
            case 2:
              return TransactionsView(
                slideChangeView: model.slideChangeViews,
              );
            case 3:
              return LendView(
                slideChangeView: model.slideChangeViews,
              );
            default:
              return BorrowView(
                slideChangeView: model.slideChangeViews,
              );
          }
        }

        return Scaffold(
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 1000),
            reverse: model.reverse,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
              );
            },
            child: getViewForIndex(model.currentIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: model.currentIndex,
            onTap: model.setIndex,
            selectedItemColor: primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                activeIcon: Icon(
                  Icons.person,
                  size: 40.0,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Borrow',
                activeIcon: Icon(
                  Icons.home,
                  size: 40.0,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on),
                label: 'Transactions',
                activeIcon: Icon(
                  Icons.monetization_on,
                  size: 40.0,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
                activeIcon: Icon(
                  Icons.notifications,
                  size: 40.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
