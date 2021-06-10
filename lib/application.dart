import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/network/api_service.dart';
import 'package:flutter_template_app/network/api_service_mock.dart';
import 'package:flutter_template_app/provider/account_setup_provider.dart';
import 'package:flutter_template_app/provider/auth_provider.dart';
import 'package:flutter_template_app/provider/onboarding_provider.dart';
import 'package:flutter_template_app/provider/purchase_provider.dart';
import 'package:flutter_template_app/provider/splash_screen_provider.dart';
import 'package:flutter_template_app/provider/support_provider.dart';
import 'package:flutter_template_app/provider/theme_provider.dart';
import 'package:flutter_template_app/provider/user_data_provider.dart';
import 'package:flutter_template_app/repository/auth_repository.dart';
import 'package:flutter_template_app/routes.dart';
import 'package:flutter_template_app/service/service_locator.dart';

class Application extends StatefulWidget {
  Application({Key? key}) : super(key: key);

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late ApiService _apiService;
  late AuthRepository _authRepository;

  @override
  void initState() {
    setUpServiceLocator();
    // fixme: Use ApiServiceImpl() for real backend integration
    _apiService = ApiServiceMock();
    _authRepository = AuthRepository(apiService: _apiService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (context) => OnboardingProvider(authRepository: _authRepository),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthProvider(authRepository: _authRepository),
          ),
          ChangeNotifierProvider(
            create: (context) => UserDataProvider(authRepository: _authRepository),
          ),
          ChangeNotifierProvider(
            create: (context) => AccountSetupProvider(authRepository: _authRepository),
          ),
          ChangeNotifierProvider(
            create: (context) => SplashScreenProvider(authRepository: _authRepository),
          ),
          ChangeNotifierProvider(create: (context) => SupportProvider(_apiService)),
          ChangeNotifierProvider(create: (context) => PurchaseProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              title: translate(Keys.App_Title_Prod),
              theme: Provider.of<ThemeProvider>(context).getThemeData,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                localizationDelegate
              ],
              supportedLocales: localizationDelegate.supportedLocales,
              locale: localizationDelegate.currentLocale,
              routes: applicationRoutes,
              initialRoute: splashScreenRoute,
            );
          },
        ),
      ),
    );
  }
}
