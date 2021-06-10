import 'package:flutter/material.dart';
import 'package:flutter_template_app/screen/account_setup_screen.dart';
import 'package:flutter_template_app/screen/core_screen.dart';
import 'package:flutter_template_app/screen/dashboard_screen.dart';
import 'package:flutter_template_app/screen/forgot_password_screen.dart';
import 'package:flutter_template_app/screen/my_account_screen.dart';
import 'package:flutter_template_app/screen/onboarding_screen.dart';
import 'package:flutter_template_app/screen/privacy_policy_screen.dart';
import 'package:flutter_template_app/screen/purchase_screen.dart';
import 'package:flutter_template_app/screen/sign_in_screen.dart';
import 'package:flutter_template_app/screen/sign_up_screen.dart';
import 'package:flutter_template_app/screen/splash_screen.dart';
import 'package:flutter_template_app/screen/support_screen.dart';
import 'package:flutter_template_app/screen/terms_of_use_screen.dart';
import 'package:flutter_template_app/screen/welcome_screen.dart';

const String splashScreenRoute = '/splash_screen';
const String welcomeScreenRoute = '/welcome';
const String premiumScreenRoute = '/premium';
const String accountSetupScreenRoute = '/account_setup';
const String coreScreenRoute = '/core';
const String dashboardScreenRoute = '/dashboard';
const String forgotPasswordScreenRoute = '/forgot_password';
const String myAccountScreenRoute = '/my_account';
const String onboardingScreenRoute = '/onboarding';
const String privacyPolicyScreenRoute = '/privacy_policy';
const String purchaseScreenRoute = '/purchase';
const String signInScreenRoute = '/sign_in';
const String signUpScreenRoute = '/sign_up';
const String supportScreenRoute = '/support';
const String termsOfUseScreenRoute = '/terms_of_use';

/// For passing argument between screens can be used arguments:
///
/// ```
///   splashScreenRoute: (context) {
///     StringScreenArgument args = ModalRoute.of(context).settings.arguments;
///     return SplashScreen(value: args.value);
///   },
/// ```
/// To use in need to be called:
///
/// ```
/// Navigator.pushReplacementNamed(context, splashScreenRoute,
///         arguments: StringScreenArgument(value: 'Some text'));
/// ```
///

Map<String, WidgetBuilder> applicationRoutes = <String, WidgetBuilder>{
  splashScreenRoute: (context) => SplashScreen(),
  welcomeScreenRoute: (context) => WelcomeScreen(),
  accountSetupScreenRoute: (context) => AccountSetupScreen(),
  coreScreenRoute: (context) => CoreScreen(),
  dashboardScreenRoute: (context) => DashboardScreen(),
  forgotPasswordScreenRoute: (context) => ForgotPasswordScreen(),
  myAccountScreenRoute: (context) => MyAccountScreen(),
  onboardingScreenRoute: (context) => OnboardingScreen(),
  privacyPolicyScreenRoute: (context) => PrivacyPolicyScreen(),
  purchaseScreenRoute: (context) => PurchaseScreen(),
  signInScreenRoute: (context) => SignInScreen(),
  signUpScreenRoute: (context) => SignUpScreen(),
  supportScreenRoute: (context) => SupportScreen(),
  termsOfUseScreenRoute: (context) => TermsOfUseScreen()
};
