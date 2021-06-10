import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_template_app/common/custom_text_field.dart';
import 'package:flutter_template_app/util/toast_message.dart';
import 'package:flutter_template_app/common/loading_overlay.dart';
import 'package:flutter_template_app/common/primary_button.dart';
import 'package:flutter_template_app/localization/keys.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/provider/auth_provider.dart';
import 'package:flutter_template_app/routes.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  FocusNode? _passwordFocusNode;
  FocusNode? _emailFocusNode;

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).reset();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    _passwordFocusNode!.dispose();
    _emailFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 64, bottom: 32),
                  child: Text(translate(Keys.Screen_Title_Sign_In),
                      style: Theme.of(context).textTheme.headline1),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: buildSignInForm(context),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: _buildBottomSection(context),
                )
              ],
            ),
          ),
          authProvider.signInResponse.status == Status.loading
              ? Positioned.fill(child: LoadingOverlay())
              : SizedBox()
        ],
      ),
    );
  }

  Widget buildSignInForm(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Form(
      key: _key,
      autovalidateMode:
          authProvider.autoValidate! ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
                focusNode: _emailFocusNode,
                controller: _emailController,
                changeCallback: (val) {
                  setState(() {});
                },
                textHint: translate(Keys.Text_Field_Hint_Email),
                action: TextInputAction.next,
                validator: authProvider.validateEmail,
                fieldSubmitted: () => _passwordFocusNode!.requestFocus(),
                keyboardType: TextInputType.emailAddress),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: CustomTextField(
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                changeCallback: (val) {
                  setState(() {});
                },
                validator: authProvider.validatePassword,
                textHint: translate(Keys.Text_Field_Hint_Password),
                action: TextInputAction.done,
                obscure: true,
                fieldSubmitted: isDataValid(context)
                    ? () {
                        _onSignInButtonPressed(context);
                      }
                    : null,
                keyboardType: TextInputType.text),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PrimaryButton(
                onTap: isDataValid(context)
                    ? () {
                        _onSignInButtonPressed(context);
                      }
                    : null,
                buttonText: translate(Keys.Button_Go)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(signUpScreenRoute),
            child: Text(translate(Keys.Screen_Title_Sign_Up))),
        Container(width: 120, child: Divider(thickness: 2)),
        TextButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(forgotPasswordScreenRoute),
            child: Text(translate(Keys.Screen_Title_Forgot_Password))),
      ],
    );
  }

  Future<void> _onSignInButtonPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_key.currentState!.validate()) {
      await authProvider.signIn(
        _emailController!.text,
        _passwordController!.text,
      );

      if (authProvider.signInResponse.status == Status.completed) {
        await Navigator.of(context).pushReplacementNamed(dashboardScreenRoute);
      } else if (authProvider.signInResponse.status == Status.error) {
        _emailController!.clear();
        _passwordController!.clear();

        ToastMessage.showError(authProvider.signInResponse.message!);
      }
    } else {
      authProvider.autoValidate = true;
    }
  }

  bool isDataValid(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return !authProvider.autoValidate! ||
        authProvider.validateEmail(_emailController!.text) == null &&
            authProvider.validatePassword(_passwordController!.text) == null;
  }
}
