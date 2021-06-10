import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/screen/side_menu.dart';

class TermsOfUseScreen extends StatefulWidget {
  TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  _TermsOfUseScreenState createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: SideMenu(selectedItem: SideMenuItem.TERMS_OF_USE),
      body: Builder(builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: kToolbarHeight + 16, bottom: 10),
                    child: Text(
                      translate(Keys.Screen_Title_Terms_Of_Use),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      translate(Keys.Agreement),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(22),
                    child: Text(
                      translate(Keys.Terms_Of_Use_Text),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 24,
                left: 8,
                child: ClipOval(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ))
          ],
        );
      }),
    );
  }
}
