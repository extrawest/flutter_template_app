import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template_app/provider/splash_screen_provider.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var provider = Provider.of<SplashScreenProvider>(context, listen: false);

      final route = await provider.getScreenRouteBasedOnUserData();
      await Navigator.of(context).pushReplacementNamed(route);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
