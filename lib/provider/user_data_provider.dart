import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_template_app/model/user_model.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/repository/auth_repository.dart';
import 'package:flutter_template_app/service/service_locator.dart';
import 'package:flutter_template_app/service/validation_service.dart';

class UserDataProvider extends ChangeNotifier {
  bool? _autoValidate;
  late ValidationService _validationService;
  late NetworkResponse<UserModel> loadUserDataResponse;
  late NetworkResponse<String> changePasswordResponse;
  late NetworkResponse<String> saveUserDataResponse;

  final AuthRepository _authRepository;

  UserDataProvider({required AuthRepository authRepository}) : _authRepository = authRepository {
    _validationService = serviceLocator.get<ValidationService>();
  }

  void reset() {
    _autoValidate = false;
    loadUserDataResponse = NetworkResponse<UserModel>.loading('Initial loading...');
    changePasswordResponse = NetworkResponse<String>.none();
    saveUserDataResponse = NetworkResponse<String>.none();
  }

  bool? get autoValidate => _autoValidate;

  set autoValidate(bool? value) {
    _autoValidate = value;
    notifyListeners();
  }

  String? validateEmail(String? email) {
    return _validationService.validEmail(email ?? '');
  }

  String? validateFirstName(String? firstName) {
    return _validationService.validateFirstName(firstName ?? '');
  }

  String? validateLastName(String? lastName) {
    return _validationService.validateLastName(lastName ?? '');
  }

  String? validateDateOfBirth(DateTime dateTime) {
    return _validationService.validateDateOfBirth(dateTime);
  }

  String? validatePassword(String password) {
    return _validationService.validPassword(password);
  }

  String? validateConfirmPassword(String password, String passwordAgain) {
    return _validationService.validConfirmPassword(password, passwordAgain);
  }

  bool isDataValid(
      {String? firstName,
      String? lastName,
      DateTime? dateOfBirthday,
      required String email,
      required String password,
      String? confirmPassword}) {
    var isPersonalDataValid = validateEmail(email) == null &&
        validateFirstName(firstName!) == null &&
        validateLastName(lastName!) == null &&
        dateOfBirthday != null;

    bool isPasswordSectionValid;

    if (password.isEmpty && confirmPassword!.isEmpty) {
      isPasswordSectionValid = true;
    } else {
      isPasswordSectionValid = validatePassword(password) == null &&
          validateConfirmPassword(password, confirmPassword!) == null;
    }

    return !_autoValidate! || isPasswordSectionValid && isPersonalDataValid;
  }

  Future<void> loadUserData() async {
    loadUserDataResponse = NetworkResponse.loading('Loading user data is in progress..');
    notifyListeners();
    try {
      var response = await _authRepository.getUserData();
      if (response.statusCode == 200) {
        loadUserDataResponse =
            NetworkResponse.completed(UserModel.fromJson(jsonDecode(response.body)['user']));
      } else {
        loadUserDataResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      loadUserDataResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> saveUserData(
      {required String firstName,
      required String lastName,
      required DateTime? dateOfBirthday,
      required String email,
      String? place,
      String? middleName}) async {
    saveUserDataResponse = NetworkResponse.loading('Data is saving ...');
    notifyListeners();
    try {
      var response = await (_authRepository.saveUserData(
          email: email,
          firstName: firstName,
          lastName: lastName,
          dateTime: dateOfBirthday,
          placeOfBirth: place,
          middleName: middleName));
      if (response.statusCode == 200) {
        saveUserDataResponse = NetworkResponse.completed((jsonDecode(response.body)['message']));
      } else {
        saveUserDataResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      saveUserDataResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> changePassword(String password) async {
    changePasswordResponse = NetworkResponse<String>.loading('Password is changing...');
    try {
      var response =
          await (_authRepository.changePassword(password));
      if (response.statusCode == 200) {
        changePasswordResponse = NetworkResponse.completed(jsonDecode(response.body)['message']);
      } else {
        changePasswordResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      changePasswordResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
