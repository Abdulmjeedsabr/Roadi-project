import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_roadi_app/helper/get_di.dart';
import 'package:last_roadi_app/views/auth/sign_in_screen.dart';
import 'package:last_roadi_app/views/auth/sign_up_screen.dart';
import 'package:last_roadi_app/views/groups/groups_screen.dart';
import 'package:last_roadi_app/views/onboarding/onboaring_screen.dart';
import 'package:last_roadi_app/views/profile/change_password_screen.dart';
import 'package:last_roadi_app/views/profile/help_support_screen.dart';
import 'package:last_roadi_app/views/profile/settings_screen.dart';
import 'package:last_roadi_app/views/profile/update_user_info_screen.dart';
import 'package:last_roadi_app/views/splash/splash_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String settings = '/settings';

  static const String editProfile = '/edit-profile';
  static const String onBoarding = '/on-boarding';
  static const String login = '/sign-in';
  static const String register = '/sign-up';
  static const String changePassword = '/change-password';
  static const String helpSupport = '/help-support';

  static String getInitialRoute({String? username}) =>
      '$initial?username=$username';

  static String getEditProfileRoute() => '$editProfile';
  static String getSplashRoute() => '$splash';
  static String getSettingsRoute() => '$settings';
  static String getChangePasswordRoute() => '$changePassword';
  static String getHelpSupportRoute() => '$helpSupport';
  static String getOnBoardingRoute() => '$onBoarding';
  static String getLoginRoute() => '$login';
  static String getRegisterRoute() => '$register';

  static List<GetPage> routes = [
    GetPage(
        name: splash,
        page: () {
          return SplashScreen();
        }),
    GetPage(name: onBoarding, page: () => OnBoardingScreen()),
    GetPage(
      name: helpSupport,
      page: () => HelpSupportScreen(),
    ),
    GetPage(name: editProfile, page: () => UpdateUserInfoScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: initial, page: () => GroupsScreen()),
    GetPage(name: settings, page: () => SettingsScreen()),
    GetPage(name: changePassword, page: () => ChangePasswordScreen()),
    
  ];

  static getRoute(Widget navigateTo) {
    return navigateTo;
  }
}
