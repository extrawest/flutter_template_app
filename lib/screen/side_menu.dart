import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/routes.dart';
import 'package:flutter_template_app/util/secure_storage_utils.dart';

enum SideMenuItem { DASHBOARD, CORE, PREMIUM, MY_ACCOUNT, SUPPORT, TERMS_OF_USE, PRIVACY_POLICY }

class SideMenu extends StatelessWidget {
  final SideMenuItem selectedItem;

  const SideMenu({Key? key, required this.selectedItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildDashboardWidget(context),
              buildCoreWidget(context),
              buildPremiumWidget(context),
              buildMyAccountWidget(context),
              buildSupportWidget(context),
              buildTermsOfUseWidget(context),
              buildPrivacyPolicyWidget(context),
              buildLogOutWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDashboardWidget(BuildContext context) {
    return _buildItem(
        context,
        translate(Keys.Screen_Title_Dashboard),
        SideMenuItem.DASHBOARD,
        () =>
            Navigator.of(context).pushNamedAndRemoveUntil(dashboardScreenRoute, (route) => false));
  }

  Widget buildCoreWidget(BuildContext context) {
    return _buildItem(context, translate(Keys.Screen_Title_Core), SideMenuItem.CORE,
        () => Navigator.of(context).pushNamedAndRemoveUntil(coreScreenRoute, (route) => false));
  }

  Widget buildPremiumWidget(BuildContext context) {
    return _buildItem(context, translate(Keys.Screen_Title_Premium), SideMenuItem.PREMIUM,
        () => Navigator.of(context).pushNamedAndRemoveUntil(purchaseScreenRoute, (route) => false));
  }

  Widget buildMyAccountWidget(BuildContext context) {
    return _buildItem(
        context,
        translate(Keys.Screen_Title_My_Account),
        SideMenuItem.MY_ACCOUNT,
        () =>
            Navigator.of(context).pushNamedAndRemoveUntil(myAccountScreenRoute, (route) => false));
  }

  Widget buildSupportWidget(BuildContext context) {
    return _buildItem(context, translate(Keys.Screen_Title_Support), SideMenuItem.SUPPORT,
        () => Navigator.of(context).pushNamedAndRemoveUntil(supportScreenRoute, (route) => false));
  }

  Widget buildTermsOfUseWidget(BuildContext context) {
    return _buildItem(
        context,
        translate(Keys.Screen_Title_Terms_Of_Use),
        SideMenuItem.TERMS_OF_USE,
        () =>
            Navigator.of(context).pushNamedAndRemoveUntil(termsOfUseScreenRoute, (route) => false));
  }

  Widget buildPrivacyPolicyWidget(BuildContext context) {
    return _buildItem(
      context,
      translate(Keys.Screen_Title_Privacy_Policy),
      SideMenuItem.PRIVACY_POLICY,
      () =>
          Navigator.of(context).pushNamedAndRemoveUntil(privacyPolicyScreenRoute, (route) => false),
    );
  }

  Widget buildLogOutWidget(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 26, horizontal: 36),
        child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(welcomeScreenRoute, (route) => false);
              SecureStorageUtils.deleteToken();
            },
            child: Text(translate(Keys.Sign_Out),
                style: TextStyle(color: Theme.of(context).hintColor))));
  }

  Widget _buildItem(BuildContext context, String text, SideMenuItem item, Function()? onTap) {
    return InkWell(
      onTap: this.selectedItem == item ? Navigator.of(context).pop : onTap,
      child: this.selectedItem == item
          ? _buildSelectedItem(text, context)
          : _buildUnselectedItem(text, context),
    );
  }

  Widget _buildSelectedItem(String text, BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
        child: Text(text, style: TextStyle(color: Theme.of(context).accentColor)));
  }

  Widget _buildUnselectedItem(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
      child: Text(text, style: TextStyle(color: Theme.of(context).hintColor)),
    );
  }
}
