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
import 'package:flutter_template_app/provider/user_data_provider.dart';
import 'package:flutter_template_app/screen/side_menu.dart';
import 'package:flutter_template_app/util/date_formatter.dart';

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  TextEditingController? _emailEditingController;
  TextEditingController? _firstNameEditingController;
  TextEditingController? _middleNameEditingController;
  TextEditingController? _lastNameEditingController;
  TextEditingController? _placeEditingController;

  TextEditingController? _passwordEditingController;
  TextEditingController? _confirmPasswordEditingController;

  FocusNode? _emailFocusNode;
  FocusNode? _firstNameFocusNode;
  FocusNode? _middleNameFocusNode;
  FocusNode? _lastNameFocusNode;
  FocusNode? _placeFocusNode;

  FocusNode? _passwordFocusNode;
  FocusNode? _confirmPasswordFocusNode;

  DateTime? _dateOfBirthday;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    Provider.of<UserDataProvider>(context, listen: false).reset();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initializeData(context);
    });

    _passwordEditingController = TextEditingController();
    _confirmPasswordEditingController = TextEditingController();

    _emailFocusNode = FocusNode();
    _firstNameFocusNode = FocusNode();
    _middleNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _placeFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    super.initState();
  }

  Future<void> initializeData(BuildContext context) async {
    var userdataProvider = Provider.of<UserDataProvider>(context, listen: false);

    await userdataProvider.loadUserData();

    if (userdataProvider.loadUserDataResponse.status == Status.completed) {
      final userData = userdataProvider.loadUserDataResponse.data!;
      _emailEditingController = TextEditingController.fromValue(
        TextEditingValue(
            composing: TextRange.collapsed(userData.email!.length), text: userData.email!),
      );
      _firstNameEditingController = TextEditingController.fromValue(
        TextEditingValue(
            composing: TextRange.collapsed(userData.firstName!.length), text: userData.firstName!),
      );
      _middleNameEditingController = TextEditingController.fromValue(
        TextEditingValue(
            composing: TextRange.collapsed(userData.middleName!.length),
            text: userData.middleName!),
      );
      _lastNameEditingController = TextEditingController.fromValue(
        TextEditingValue(
            composing: TextRange.collapsed(userData.lastName!.length), text: userData.lastName!),
      );
      _placeEditingController = TextEditingController.fromValue(
        TextEditingValue(
            composing: TextRange.collapsed(userData.placeOfBirth!.length),
            text: userData.placeOfBirth!),
      );
      _dateOfBirthday = userData.dateOfBirth;
    } else {
      _emailEditingController = TextEditingController();
      _firstNameEditingController = TextEditingController();
      _middleNameEditingController = TextEditingController();
      _lastNameEditingController = TextEditingController();
      _placeEditingController = TextEditingController();

      ToastMessage.showError(userdataProvider.loadUserDataResponse.message!);
    }
  }

  @override
  void dispose() {
    _emailFocusNode!.dispose();
    _firstNameFocusNode!.dispose();
    _middleNameFocusNode!.dispose();
    _lastNameFocusNode!.dispose();
    _placeFocusNode!.dispose();
    _passwordFocusNode!.dispose();
    _confirmPasswordFocusNode!.dispose();

    _emailEditingController!.dispose();
    _firstNameEditingController!.dispose();
    _middleNameEditingController!.dispose();
    _lastNameEditingController!.dispose();
    _placeEditingController!.dispose();
    _passwordEditingController!.dispose();
    _confirmPasswordEditingController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDataProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
      drawer: SideMenu(selectedItem: SideMenuItem.MY_ACCOUNT),
      appBar: AppBar(title: Text(translate(Keys.Screen_Title_My_Account))),
      body: userDataProvider.loadUserDataResponse.status == Status.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    var userDataProvider = Provider.of<UserDataProvider>(context, listen: false);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _key,
            autovalidateMode: userDataProvider.autoValidate!
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                buildPersonalDetailsSection(context),
                Divider(color: Theme.of(context).dividerColor, thickness: 1),
                buildBirthDetailsSection(context),
                Divider(color: Theme.of(context).dividerColor, thickness: 1),
                buildChangePasswordSection(context),
                Divider(color: Theme.of(context).dividerColor, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                    buttonText: translate(Keys.Button_Save),
                    onTap:
                        isDataValid(context) ? () => _onUpdateUserDataButtonPressed(context) : null,
                  ),
                )
              ],
            ),
          ),
        ),
        userDataProvider.saveUserDataResponse.status == Status.loading ||
                userDataProvider.changePasswordResponse.status == Status.loading
            ? Positioned.fill(child: LoadingOverlay())
            : SizedBox()
      ],
    );
  }

  Widget buildPersonalDetailsSection(BuildContext context) {
    var userDataProvider = Provider.of<UserDataProvider>(context, listen: false);

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
            textHint: translate(Keys.Text_Field_Hint_Email),
            controller: _emailEditingController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            changeCallback: (val) {
              setState(() {});
            },
            action: TextInputAction.next,
            validator: userDataProvider.validateEmail,
            fieldSubmitted: () => _firstNameFocusNode!.requestFocus(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CustomTextField(
            textHint: translate(Keys.Text_Field_Hint_First_Name),
            controller: _firstNameEditingController,
            focusNode: _firstNameFocusNode,
            keyboardType: TextInputType.name,
            changeCallback: (val) {
              setState(() {});
            },
            action: TextInputAction.next,
            validator: userDataProvider.validateFirstName,
            fieldSubmitted: () => _middleNameFocusNode!.requestFocus(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
            validator: userDataProvider.validateLastName,
            fieldSubmitted: () => _placeFocusNode!.requestFocus(),
          ),
        ),
      ],
    );
  }

  Widget buildBirthDetailsSection(BuildContext context) {
    var accountSetupProvider = Provider.of<UserDataProvider>(context, listen: false);

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
              fieldSubmitted:
                  isDataValid(context) ? () => _onUpdateUserDataButtonPressed(context) : null),
        ),
      ],
    );
  }

  Widget buildChangePasswordSection(BuildContext context) {
    var accountSetupProvider = Provider.of<UserDataProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 46, 29, 20),
          child: Text('Change Password', style: Theme.of(context).textTheme.headline3),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: CustomTextField(
            focusNode: _passwordFocusNode,
            controller: _passwordEditingController,
            textHint: 'Password',
            obscure: true,
            changeCallback: (val) {
              setState(() {});
            },
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              } else {
                return accountSetupProvider.validatePassword(value);
              }
            },
            action: TextInputAction.next,
            fieldSubmitted: _confirmPasswordFocusNode!.requestFocus,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: CustomTextField(
              focusNode: _confirmPasswordFocusNode,
              controller: _confirmPasswordEditingController,
              textHint: 'Confirm password',
              changeCallback: (val) {
                setState(() {});
              },
              validator: (value) {
                if (value!.isEmpty && _passwordEditingController!.text.isEmpty) {
                  return null;
                } else {
                  return accountSetupProvider.validateConfirmPassword(
                      _passwordEditingController!.text, value);
                }
              },
              obscure: true,
              action: TextInputAction.done,
              fieldSubmitted: isDataValid(context)
                  ? () {
                      _onUpdateUserDataButtonPressed(context);
                    }
                  : null,
              keyboardType: TextInputType.text),
        ),
      ],
    );
  }

  bool isDataValid(BuildContext context) {
    return Provider.of<UserDataProvider>(context, listen: false).isDataValid(
        firstName: _firstNameEditingController!.text,
        lastName: _lastNameEditingController!.text,
        dateOfBirthday: _dateOfBirthday,
        email: _emailEditingController!.text,
        password: _passwordEditingController!.text,
        confirmPassword: _confirmPasswordEditingController!.text);
  }

  Future<void> _onUpdateUserDataButtonPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);

    if (_key.currentState!.validate()) {
      if (_passwordEditingController!.text.isNotEmpty) {
        await userDataProvider.changePassword(_passwordEditingController!.text);

        if (userDataProvider.changePasswordResponse.status.isCompleted) {
          ToastMessage.showSuccess(userDataProvider.changePasswordResponse.data!);
        } else {
          ToastMessage.showError(userDataProvider.changePasswordResponse.message!);
        }
      } else {
        await userDataProvider.saveUserData(
            firstName: _firstNameEditingController!.text,
            lastName: _lastNameEditingController!.text,
            middleName: _middleNameEditingController!.text,
            place: _placeEditingController!.text,
            dateOfBirthday: _dateOfBirthday,
            email: _emailEditingController!.text);

        if (userDataProvider.saveUserDataResponse.status == Status.completed) {
          ToastMessage.showSuccess(userDataProvider.saveUserDataResponse.data!);
        } else {
          ToastMessage.showError(userDataProvider.saveUserDataResponse.message!);
        }
      }
    } else {
      userDataProvider.autoValidate = true;
    }
  }
}
