import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template_app/common/custom_text_field.dart';
import 'package:flutter_template_app/util/toast_message.dart';
import 'package:flutter_template_app/common/loading_overlay.dart';
import 'package:flutter_template_app/common/primary_button.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/provider/support_provider.dart';
import 'package:flutter_template_app/screen/side_menu.dart';

class SupportScreen extends StatefulWidget {
  SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _subjectController;
  late TextEditingController _messageController;

  late FocusNode _subjectFocusNode;
  late FocusNode _messageFocusNode;

  @override
  void initState() {
    Provider.of<SupportProvider>(context, listen: false).reset();

    _subjectController = TextEditingController();
    _messageController = TextEditingController();
    _subjectFocusNode = FocusNode();
    _messageFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _subjectFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var supportProvider = Provider.of<SupportProvider>(context);

    return Scaffold(
      drawer: SideMenu(selectedItem: SideMenuItem.SUPPORT),
      appBar: AppBar(title: Text(translate(Keys.Screen_Title_Support))),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: supportProvider.autoValidate!
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(22, 42, 22, 22),
                      child: Text(translate(Keys.Support_Experiencing_An_Issue),
                          style: Theme.of(context).textTheme.headline5)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(22, 0, 22, 20),
                    child: CustomTextField(
                        focusNode: _subjectFocusNode,
                        controller: _subjectController,
                        textHint: translate(Keys.Support_Subject),
                        changeCallback: (val) {
                          setState(() {});
                        },
                        validator: supportProvider.validateSubject,
                        action: TextInputAction.next,
                        fieldSubmitted: () => _messageFocusNode.requestFocus(),
                        keyboardType: TextInputType.text),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(22, 0, 22, 20),
                    child: CustomTextField(
                        focusNode: _messageFocusNode,
                        controller: _messageController,
                        textHint: translate(Keys.Support_Message),
                        changeCallback: (val) {
                          setState(() {});
                        },
                        validator: supportProvider.validateMessage,
                        action: TextInputAction.newline,
                        minLines: 6,
                        maxLines: 18,
                        keyboardType: TextInputType.multiline),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20, left: 20, bottom: 30),
                    child: PrimaryButton(
                      onTap: isDataValid(context) ? () => _onSendButtonPressed(context) : null,
                      buttonText: translate(Keys.Button_Send),
                    ),
                  ),
                ],
              ),
            ),
          ),
          supportProvider.emailSendResponse.status == Status.loading
              ? Positioned.fill(child: LoadingOverlay())
              : SizedBox()
        ],
      ),
    );
  }

  bool isDataValid(BuildContext context) {
    return Provider.of<SupportProvider>(context, listen: false)
        .isDataValid(_messageController.text, _subjectController.text);
  }

  void _onSendButtonPressed(BuildContext context) async {
    var supportProvider = Provider.of<SupportProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      await supportProvider.sendMessageToSupport(
        _subjectController.text,
        _messageController.text,
      );

      if (supportProvider.emailSendResponse.status == Status.completed) {
        _subjectController.clear();
        _messageController.clear();

        supportProvider.autoValidate = false;

        ToastMessage.showSuccess(supportProvider.emailSendResponse.data!);
      } else {
        ToastMessage.showError(supportProvider.emailSendResponse.message!);
      }
    } else {
      supportProvider.autoValidate = true;
    }
  }
}
