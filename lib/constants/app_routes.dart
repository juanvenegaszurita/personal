// get
import 'package:get/get.dart';
// personal
import 'package:personal/ui/private/private.dart';
import 'package:personal/ui/ui.dart';
import 'package:personal/ui/auth/auth.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => SplashUI()),
    GetPage(name: '/signin', page: () => SignInUI()),
    GetPage(name: '/signup', page: () => SignUpUI()),
    GetPage(name: '/home', page: () => HomeUI()),
    GetPage(name: '/settings', page: () => SettingsUI()),
    GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
    GetPage(name: '/AccountsUI', page: () => AccountsUI()),
    GetPage(name: '/ChartUI', page: () => ChartUI()),
    GetPage(name: '/PasswordUI', page: () => PasswordUI()),
  ];
}
