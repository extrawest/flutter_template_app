import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/repository/auth_repository.dart';
import 'package:flutter_template_app/service/service_locator.dart';
import 'package:flutter_template_app/service/validation_service.dart';
import 'package:flutter_template_app/util/secure_storage_utils.dart';

/// [AuthProvider] including functionality for sign in, sign up and forgot password screens.
class AuthProvider extends ChangeNotifier {

  bool? _autoValidate;
  final AuthRepository _authRepository;
  late ValidationService _validationService;

  late NetworkResponse<String> emailSentResponse;
  late NetworkResponse<String> signInResponse;
  late NetworkResponse<String> signUpResponse;

  AuthProvider({required AuthRepository authRepository}) : _authRepository = authRepository {
    _validationService = serviceLocator.get<ValidationService>();
  }

  bool isDataValid() {
    return true;
  }

  void reset(){
    _autoValidate = false;
    emailSentResponse = NetworkResponse<String>.none();
    signInResponse = NetworkResponse<String>.none();
    signUpResponse = NetworkResponse<String>.none();
  }


  String? validateEmail(String? email) {
    return _validationService.validEmail(email ?? '');
  }

  String? validatePassword(String? password) {
    return _validationService.validPassword(password ?? '');
  }

  String? validateConfirmPassword(String password, String passwordAgain) {
    return _validationService.validConfirmPassword(password, passwordAgain);
  }

  Future<void> forgotPassword(String email) async {
    emailSentResponse = NetworkResponse<String>.loading('Authorization in progress..');
    notifyListeners();
    try {
      var response = await _authRepository.forgotPassword(email: email);
      if (response.statusCode == 200) {
        emailSentResponse = NetworkResponse.completed(jsonDecode(response.body)['message']);
      } else {
        emailSentResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      emailSentResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }}



  Future<void> signIn(String email, String password) async {
    signInResponse = NetworkResponse<String>.loading('Authorization in progress..');
    notifyListeners();
    try {
      var response = await _authRepository.signIn(email: email, password: password);
      if (response.statusCode == 200) {
        signInResponse = NetworkResponse.completed(jsonDecode(response.body)['token']);
        await SecureStorageUtils.writeAuthToken(signInResponse.data);
      } else {
        signInResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      signInResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    signUpResponse = NetworkResponse<String>.loading('Authorization in progress..');
    notifyListeners();
    try {
      var response = await _authRepository.signUp(email: email, password: password);
      if (response.statusCode == 200) {
        signUpResponse = NetworkResponse.completed(jsonDecode(response.body)['token']);
        await SecureStorageUtils.writeAuthToken(signUpResponse.data);
      } else {
        signUpResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      signUpResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  bool? get autoValidate => _autoValidate;

  set autoValidate(bool? value) {
    _autoValidate = value;
    notifyListeners();
  }

}