import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template_app/common/custom_picker.dart';
import 'package:flutter_template_app/common/custom_text_field.dart';
import 'package:flutter_template_app/util/toast_message.dart';
import 'package:flutter_template_app/common/loading_overlay.dart';
import 'package:flutter_template_app/common/primary_button.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/provider/account_setup_provider.dart';
import 'package:flutter_template_app/routes.dart';
import 'package:flutter_template_app/util/date_formatter.dart';

class AccountSetupScreen extends StatefulWidget {
  AccountSetupScreen({Key? key}) : super(key: key);

  @override
  _AccountSetupScreenState createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  TextEditingController? _firstNameEditingController;
  TextEditingController? _middleNameEditingController;
  TextEditingController? _lastNameEditingController;
  TextEditingController? _placeEditingController;

  FocusNode? _firstNameFocusNode;
  FocusNode? _middleNameFocusNode;
  FocusNode? _lastNameFocusNode;
  FocusNode? _placeFocusNode;

  DateTime? _dateOfBirthday;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    _firstNameEditingController = TextEditingController();
    _middleNameEditingController = TextEditingController();
    _lastNameEditingController = TextEditingController();
    _placeEditingController = TextEditingController();

    _firstNameFocusNode = FocusNode();
    _middleNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _placeFocusNode = FocusNode();

    Provider.of<AccountSetupProvider>(context, listen: false).reset();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameEditingController!.dispose();
    _middleNameEditingController!.dispose();
    _lastNameEditingController!.dispose();
    _placeEditingController!.dispose();

    _firstNameFocusNode!.dispose();
    _middleNameFocusNode!.dispose();
    _lastNameFocusNode!.dispose();
    _placeFocusNode!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var accountSetupProvider = Provider.of<AccountSetupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.Screen_Title_Complete_Setup)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _key,
              autovalidateMode: accountSetupProvider.autoValidate!
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  buildPersonalDetailsSection(context),
                  Divider(color: Theme.of(context).dividerColor, thickness: 1),
                  buildBirthDetailsSection(context),
                  Divider(color: Theme.of(context).dividerColor, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: PrimaryButton(
                      buttonText: translate(Keys.Button_Save),
                      onTap: isDataValid(context) ? () => _onSignUpButtonPressed(context) : null,
                    ),
                  )
                ],
              ),
            ),
          ),
          accountSetupProvider.accountSetupResponse.status == Status.loading
              ? Positioned.fill(child: LoadingOverlay())
              : SizedBox()
        ],
      ),
    );
  }

  Widget buildPersonalDetailsSection(BuildContext context) {
    var accountSetupProvider = Provider.of<AccountSetupProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 46, 29, 20),
          child: Text(translate(Keys.Complete_Setup_Personal_Details),
              style: Theme.of(context).textTheme.headline3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            textHint: translate(Keys.Text_Field_Hint_First_Name),
            controller: _firstNameEditingController,
            focusNode: _firstNameFocusNode,
            keyboardType: TextInputType.name,
            changeCallback: (val) {
              setState(() {});
            },
            action: TextInputAction.next,
            validator: accountSetupProvider.validateFirstName,
            fieldSubmitted: () => _middleNameFocusNode!.requestFocus(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CustomTextField(
            textHint: translate(Keys.Text_Field_Hint_Middle_Name),
            controller: _middleNameEditingController,
            focusNode: _middleNameFocusNode,
            keyboardType: TextInputType.name,
            changeCallback: (val) {
              setState(() {});
            },
            action: TextInputAction.next,
            fieldSubmitted: () => _lastNameFocusNode!.requestFocus(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: CustomTextField(
            textHint: translate(Keys.Text_Field_Hint_Last_Name),
            controller: _lastNameEditingController,
            focusNode: _lastNameFocusNode,
            keyboardType: TextInputType.name,
            changeCallback: (val) {
              setState(() {});
            },
            action: TextInputAction.next,
            validator: accountSetupProvider.validateLastName,
            fieldSubmitted: () => _placeFocusNode!.requestFocus(),
          ),
        ),
      ],
    );
  }

  Widget buildBirthDetailsSection(BuildContext context) {
    var accountSetupProvider = Provider.of<AccountSetupProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 46, 29, 20),
          child: Text(
            translate(Keys.Complete_Setup_Birth_Details),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomPicker<DateTime>(
            textHint: translate(Keys.Text_Field_Hint_Date_Of_Birth),
            icon: Icons.calendar_today_rounded,
            errorMessage: Keys.Date_Of_Birth_Error_Message,
            displayedValue: DateFormatter.parseDate(_dateOfBirthday),
            currentValue: _dateOfBirthday,
            autoValidate: accountSetupProvider.autoValidate,
            changeCallback: () async {
              FocusScope.of(context).unfocus();
              var dateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1940),
                  lastDate: DateTime.now());

              if (dateTime != null) {
                setState(() {
                  _dateOfBirthday = dateTime;
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: CustomTextField(
              textHint: translate(Keys.Text_Field_Hint_Place_Of_Birth),
              controller: _placeEditingController,
              focusNode: _placeFocusNode,
              keyboardType: TextInputType.text,
              changeCallback: (val) {
                setState(() {});
              },
              action: TextInputAction.done,
              fieldSubmitted: isDataValid(context) ? () => _onSignUpButtonPressed(context) : null),
        ),
      ],
    );
  }

  bool isDataValid(BuildContext context) {
    return Provider.of<AccountSetupProvider>(context).isDataValid(
        _firstNameEditingController!.text, _lastNameEditingController!.text, _dateOfBirthday);
  }

  Future<void> _onSignUpButtonPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final accountSetupProvider = Provider.of<AccountSetupProvider>(context, listen: false);

    if (_key.currentState!.validate()) {
      await accountSetupProvider.completeSetup(
          _firstNameEditingController!.text,
          _middleNameEditingController!.text,
          _lastNameEditingController!.text,
          _dateOfBirthday,
          _placeEditingController!.text);

      if (accountSetupProvider.accountSetupResponse.status.isCompleted) {
        await Navigator.of(context).pushReplacementNamed(dashboardScreenRoute);
      } else {
        _firstNameEditingController!.clear();
        _middleNameEditingController!.clear();
        _lastNameEditingController!.clear();
        _placeEditingController!.clear();
        _dateOfBirthday = null;

        ToastMessage.showError(accountSetupProvider.accountSetupResponse.message!);
      }
    } else {
      accountSetupProvider.autoValidate = true;
    }
  }
}
