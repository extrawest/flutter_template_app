import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template_app/util/toast_message.dart';
import 'package:flutter_template_app/common/loading_overlay.dart';
import 'package:flutter_template_app/common/primary_button.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/provider/onboarding_provider.dart';
import 'package:flutter_template_app/routes.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    Provider.of<OnboardingProvider>(context, listen: false).reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var onboardingProvider = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 64, bottom: 32),
                  child: Text(translate(Keys.Screen_Title_Disclaimer),
                      style: Theme.of(context).textTheme.headline1),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    child: RichText(
                      text: TextSpan(
                          text: '1. ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: translate(Keys.Mock_Fish_Text_Paragraph_1),
                                style: Theme.of(context).textTheme.bodyText1),
                            TextSpan(
                                text: '\n\n2. ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: translate(Keys.Mock_Fish_Text_Paragraph_2),
                                style: Theme.of(context).textTheme.bodyText1),
                            TextSpan(
                                text: '\n\n3. ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: translate(Keys.Mock_Fish_Text_Paragraph_3),
                                style: Theme.of(context).textTheme.bodyText1),
                          ]),
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 32, left: 32, right: 32, top: 32),
                  child: PrimaryButton(
                      onTap: () async {
                        await onboardingProvider.accept();
                        if (onboardingProvider.acceptDisclaimerResponse.status ==
                            Status.completed) {
                          await Navigator.of(context).pushReplacementNamed(accountSetupScreenRoute);
                        } else {
                          ToastMessage.showError(
                              onboardingProvider.acceptDisclaimerResponse.message!);
                        }
                      },
                      buttonText: translate(Keys.Button_Accept)),
                ),
              ],
            ),
          ),
          onboardingProvider.acceptDisclaimerResponse.status == Status.loading
              ? Positioned.fill(child: LoadingOverlay())
              : SizedBox()
        ],
      ),
    );
  }
}
