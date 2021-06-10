import 'package:flutter/material.dart';
import 'package:flutter_template_app/common/primary_button.dart';
import 'package:flutter_template_app/common/secondary_button.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/provider/purchase_provider.dart';
import 'package:flutter_template_app/screen/side_menu.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(selectedItem: SideMenuItem.PREMIUM),
      appBar: AppBar(title: Text(translate(Keys.Screen_Title_Premium))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 42, 16, 16),
                  child: Text(
                    translate(Keys.Mock_Short_Fish_Text),
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Text(translate(Keys.Mock_Fish_Text_Paragraph_1), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Text(translate(Keys.Mock_Fish_Text_Paragraph_2), textAlign: TextAlign.center),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PrimaryButton(
                    onTap: () {},
                    buttonText: '\$18.99',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SecondaryButton(
                    buttonText: Keys.Restore_Purchase,
                    callback: () {
                      context.read<PurchaseProvider>().restorePurchases();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
