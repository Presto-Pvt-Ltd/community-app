import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presto/ui/shared/circular_indicator.dart';
import 'package:presto/ui/shared/colors.dart';
import 'package:presto/ui/shared/ui_helpers.dart';
import 'package:presto/ui/views/home/profile/profile_view.dart';
import 'package:presto/ui/views/home/allTransactions/all_transactions_view.dart';
import 'package:stacked/stacked.dart';
import 'borrow/borrow_view.dart';
import 'home_viewModel.dart';
import 'lend/lend_view.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  int index;
  HomeView({Key? key, this.index = 1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        model.onModelReady(index);
      },
      builder: (context, model, child) {
        Widget getViewForIndexRU(int index) {
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
              return AllTransactionsView(
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

        Widget getViewForIndexCM(int index) {
          switch (index) {
            case 0:
              return ProfileView(
                slideChangeView: model.slideChangeViews,
              );

            case 1:
              return AllTransactionsView(
                slideChangeView: model.slideChangeViews,
              );
            case 2:
              return LendView(
                slideChangeView: model.slideChangeViews,
              );
            default:
              return BorrowView(
                slideChangeView: model.slideChangeViews,
              );
          }
        }

        List<BottomNavigationBarItem> bottomListRU = [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/home.svg",
              height: bottom_nav_icon_size_normal,
              width: bottom_nav_icon_size_normal,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/home_filled.svg",
              height: bottom_nav_icon_size_expanded,
              width: bottom_nav_icon_size_expanded,
              color: authButtonColorLight,
            ),
            label: "",

            // label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/dollar.svg",
              height: bottom_nav_icon_size_normal,
              width: bottom_nav_icon_size_normal,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/dollar_filled.svg",
              height: bottom_nav_icon_size_expanded,
              width: bottom_nav_icon_size_expanded,
              color: authButtonColorLight,
            ),
            label: "",
            // label: 'Borrow',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/history.svg",
              height: bottom_nav_icon_size_normal,
              width: bottom_nav_icon_size_normal,
            ),
            label: "",
            // label: 'Transactions',
            activeIcon: SvgPicture.asset(
              "assets/icons/history_filled.svg",
              height: bottom_nav_icon_size_expanded,
              width: bottom_nav_icon_size_expanded,
              color: authButtonColorLight,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/bell.svg",
              height: bottom_nav_icon_size_normal,
              width: bottom_nav_icon_size_normal,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/bell_filled.svg",
              height: bottom_nav_icon_size_expanded,
              width: bottom_nav_icon_size_expanded,
              color: authButtonColorLight,
            ),
            label: "",
            // label: 'Notifications',
          ),
        ];

        List<BottomNavigationBarItem> bottomListCM = [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            activeIcon: Icon(
              Icons.person,
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
            icon: SvgPicture.asset("assets/icons/bell.svg"),
            label: 'Notifications',
            activeIcon: SvgPicture.asset("assets/icons/bell_filled.svg"),
          ),
        ];

        String getTitleForIndex(int index) {
          if (model.isCM)
            switch (index) {
              case 0:
                return "Home";
              case 1:
                return "Transaction History";
              case 2:
                return "Notifications";
              default:
                return "";
            }
          else
            switch (index) {
              case 0:
                return "Home";
              case 1:
                return "";
              case 2:
                return "Transaction History";
              case 3:
                return "Notifications";
              default:
                return "";
            }
        }

        return model.isBusy
            ? Scaffold(
                body: Center(
                  child: loader,
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  title: Text(
                    getTitleForIndex(model.currentIndex),
                    style: TextStyle(
                      fontSize: default_headers,
                      color: authButtonColorLight,
                    ),
                  ),
                  actions: model.currentIndex == 0
                      ? <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.account_circle_outlined,
                              color: authButtonColorLight,
                              size: bottom_nav_icon_size_expanded,
                            ),
                          ),
                        ]
                      : null,
                ),
                body: RefreshIndicator(
                  onRefresh: model.refresh,
                  child: PageTransitionSwitcher(
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
                    child: model.isCM
                        ? getViewForIndexCM(model.currentIndex)
                        : getViewForIndexRU(model.currentIndex),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: model.currentIndex,
                  onTap: model.setIndex,
                  selectedItemColor: primaryLightColor,
                  items: model.isCM ? bottomListCM : bottomListRU,
                ),
              );
      },
    );
  }
}
