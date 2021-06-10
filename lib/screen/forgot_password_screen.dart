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

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController? _emailController;
  FocusNode? _emailFocusNode;

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).reset();

    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _emailController!.dispose();
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
                  child: Text(translate(Keys.Screen_Title_Forgot_Password),
                      style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: buildForgotPasswordForm(context),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      translate(Keys.Forgot_Password_Reset_Message),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    )),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: _buildBottomSection(context),
                )
              ],
            ),
          ),
          authProvider.emailSentResponse.status.isLoading
              ? Positioned.fill(child: LoadingOverlay())
              : SizedBox()
        ],
      ),
    );
  }

  Widget buildForgotPasswordForm(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Form(
      key: _key,
      autovalidateMode:
          authProvider.autoValidate! ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: CustomTextField(
                focusNode: _emailFocusNode,
                controller: _emailController,
                changeCallback: (val) {
                  setState(() {});
                },
                textHint: 'Email',
                validator: authProvider.validateEmail,
                action: TextInputAction.done,
                fieldSubmitted:
                    isDataValid(context) ? () => _onForgotPasswordButtonPressed(context) : null,
                keyboardType: TextInputType.emailAddress),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PrimaryButton(
                onTap: isDataValid(context)
                    ? () {
                        _onForgotPasswordButtonPressed(context);
                      }
                    : null,
                buttonText: 'Go'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      children: [
        FlatButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(signInScreenRoute),
            child: Text('Sign In')),
        Container(width: 120, child: Divider(thickness: 2)),
        FlatButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed(signUpScreenRoute),
            child: Text('Sign Up')),
      ],
    );
  }

  void _onForgotPasswordButtonPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_key.currentState!.validate()) {
      await authProvider.forgotPassword(_emailController!.text);

      _emailController!.clear();
      authProvider.autoValidate = false;
      if (authProvider.emailSentResponse.status == Status.completed) {
        ToastMessage.showSuccess(authProvider.emailSentResponse.data!);
      } else {
        ToastMessage.showError(authProvider.emailSentResponse.message!);
      }
    } else {
      authProvider.autoValidate = true;
    }
  }

  bool isDataValid(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return !authProvider.autoValidate! ||
        authProvider.validateEmail(_emailController!.text) == null;
  }
}
