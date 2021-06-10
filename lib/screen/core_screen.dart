import 'package:flutter/material.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/screen/side_menu.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CoreScreen extends StatelessWidget {
  const CoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(selectedItem: SideMenuItem.CORE),
      appBar: AppBar(title: Text(translate(Keys.Screen_Title_Core))),
      body: Center(
        child: Text(translate(Keys.Not_Ready_Yet)),
      ),
    );
  }
}
