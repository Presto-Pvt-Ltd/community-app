// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/dummyView/dummy_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/phoneVerification/phoneVerification_view.dart';
import '../ui/views/register/register_view.dart';
import '../ui/views/startup/startup_view.dart';

class Routes {
  static const String startUpView = '/';
  static const String dummyView = '/dummy-view';
  static const String loginView = '/login-view';
  static const String homeView = '/home-view';
  static const String registerView = '/register-view';
  static const String phoneVerificationView = '/phone-verification-view';
  static const all = <String>{
    startUpView,
    dummyView,
    loginView,
    homeView,
    registerView,
    phoneVerificationView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.dummyView, page: DummyView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.registerView, page: RegisterView),
    RouteDef(Routes.phoneVerificationView, page: PhoneVerificationView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    DummyView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DummyView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginView(),
        settings: data,
      );
    },
    HomeView: (data) {
      var args = data.getArgs<HomeViewArguments>(
        orElse: () => HomeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(
          key: args.key,
          index: args.index,
        ),
        settings: data,
      );
    },
    RegisterView: (data) {
      var args = data.getArgs<RegisterViewArguments>(
        orElse: () => RegisterViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => RegisterView(
          key: args.key,
          isRegistrationAsCommunityManager:
              args.isRegistrationAsCommunityManager,
        ),
        settings: data,
      );
    },
    PhoneVerificationView: (data) {
      var args = data.getArgs<PhoneVerificationViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PhoneVerificationView(
          key: args.key,
          phoneNumber: args.phoneNumber,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// HomeView arguments holder class
class HomeViewArguments {
  final Key? key;
  final int index;
  HomeViewArguments({this.key, this.index = 1});
}

/// RegisterView arguments holder class
class RegisterViewArguments {
  final Key? key;
  final bool isRegistrationAsCommunityManager;
  RegisterViewArguments(
      {this.key, this.isRegistrationAsCommunityManager = false});
}

/// PhoneVerificationView arguments holder class
class PhoneVerificationViewArguments {
  final Key? key;
  final String phoneNumber;
  PhoneVerificationViewArguments({this.key, required this.phoneNumber});
}
