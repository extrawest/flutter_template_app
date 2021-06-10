import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_template_app/common/primary_button.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/routes.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 64, bottom: 32),
              child: Text(translate(Keys.Screen_Title_Welcome),
                  style: Theme.of(context).textTheme.headline1),
            ),
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32),
              child: Text(
                  translate(Keys.Mock_Medium_Fish_Text),
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 32, left: 32, right: 32, top: 32),
              child: PrimaryButton(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(signUpScreenRoute);
                  },
                  buttonText: translate(Keys.Button_Continue)),
            ),
          ],
        ),
      ),
    );
  }
}
