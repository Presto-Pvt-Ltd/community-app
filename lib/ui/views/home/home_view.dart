import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/services/database/dataProviders/user_data_provider.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "RootScaffold");
  HomeView({Key? key, this.index = 1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        model.onModelReady(index);
      },
      builder: (context, model, child) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
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
                return "Amount Demanded";
              case 2:
                return "Transaction History";
              case 3:
                return "Notifications";
              default:
                return "";
            }
        }

        return Scaffold(
          key: scaffoldKey,
          drawerEnableOpenDragGesture: false,
          appBar: model.isBusy
              ? null
              : AppBar(
                centerTitle:  !model.isCM && model.currentIndex == 1 ? true : false,
                  elevation: 0.0,
                  backgroundColor: !model.isCM && model.currentIndex == 1
                      ? primaryLightColor
                      : Colors.white,
                  title: Text(
                    getTitleForIndex(model.currentIndex),
                    style: TextStyle(
                      fontSize: default_headers,
                      color: !model.isCM && model.currentIndex == 1
                          ? Colors.white
                          : authButtonColorLight,
                    ),
                  ),
                  actions: model.currentIndex == 0
                      ? <Widget>[
                          IconButton(
                            onPressed: () {
                              print("helloo mujhe dabaing");
                              scaffoldKey.currentState?.openEndDrawer();
                            },
                            icon: Icon(
                              Icons.account_circle_outlined,
                              color: authButtonColorLight,
                              size: actions_icon_size,
                            ),
                          ),
                        ]
                      : null,
                ),
          body: model.isBusy
              ? Center(
                  child: loader,
                )
              : RefreshIndicator(
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
          bottomNavigationBar: model.isBusy
              ? null
              : BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: model.currentIndex,
                  onTap: model.setIndex,
                  selectedItemColor: primaryLightColor,
                  items: model.isCM ? bottomListCM : bottomListRU,
                ),
          endDrawerEnableOpenDragGesture: false,
          endDrawer: model.isBusy
              ? null
              : model.currentIndex == 0
                  ? Container(
                      width: width * 0.5,
                      child: Drawer(
                        child: Container(
                          color: primaryLightColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: height * 0.1,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                  size: banner_font_size,
                                ),
                                title: Text(
                                  locator<UserDataProvider>()
                                      .personalData!
                                      .name,
                                  style: TextStyle(
                                    fontSize: default_normal_font_size,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "Profile",
                                  style: TextStyle(
                                    fontSize: default_normal_font_size,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  model.goToProfileDetails();
                                },
                              ),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "Invitees List",
                                  style: TextStyle(
                                    fontSize: default_normal_font_size,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  model.goToMyReferees();
                                },
                              ),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "Dark Mode",
                                  style: TextStyle(
                                    fontSize: default_normal_font_size,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "Contact Us",
                                  style: TextStyle(
                                    fontSize: default_normal_font_size,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  model.goToContactUs();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
        );
      },
    );
  }
}
