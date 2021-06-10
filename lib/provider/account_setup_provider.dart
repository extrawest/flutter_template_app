import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/repository/auth_repository.dart';
import 'package:flutter_template_app/service/service_locator.dart';
import 'package:flutter_template_app/service/validation_service.dart';
import 'package:flutter_template_app/status/user_status.dart';

class AccountSetupProvider extends ChangeNotifier {
  bool? _autoValidate;
  late ValidationService _validationService;
  late NetworkResponse<UserStatus> accountSetupResponse;

  final AuthRepository _authRepository;

  /// Reset data from the previous operations
  void reset() {
    _autoValidate = false;
    accountSetupResponse = NetworkResponse<UserStatus>.none();
  }

  bool? get autoValidate => _autoValidate;

  set autoValidate(bool? value) {
    _autoValidate = value;
    notifyListeners();
  }

  AccountSetupProvider({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _validationService = serviceLocator.get<ValidationService>();
  }

  /// Middleware between validation service and UI
  String? validateFirstName(String? firstName) {
    return _validationService.validateFirstName(firstName ?? '');
  }

  String? validateLastName(String? lastName) {
    return _validationService.validateLastName(lastName ?? '');
  }

  String? validateDateOfBirth(DateTime? dateTime) {
    return _validationService.validateDateOfBirth(dateTime);
  }

  /// Executing backend request and updating the app during this process.
  /// Initial preparation before request. (Showing loader on the screen)
  /// ```
  ///   accountSetupResponse = NetworkResponse.loading('Setup is in progress..');
  ///   notifyListeners();
  /// ```
  ///
  /// Rebuilding the screen associated with this provider after request execution
  ///
  /// ```
  /// } finally {
  ///   notifyListeners();
  /// }
  /// ```
  ///
  Future<void> completeSetup(String firstName, String middleName, String lastName,
      DateTime? dateTime, String placeOfBirth) async {
    accountSetupResponse = NetworkResponse.loading('Setup is in progress..');
    notifyListeners();
    try {
      final response = await _authRepository.completeSetup(
        placeOfBirth: placeOfBirth,
        middleName: middleName,
        firstName: firstName,
        lastName: lastName,
        dateTime: dateTime,
      );
      if (response.statusCode == 200) {
        accountSetupResponse =
            NetworkResponse.completed(decodeUserStatus(jsonDecode(response.body)['status']));
      } else {
        accountSetupResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      accountSetupResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Check on fields validate
  bool isDataValid(String firstName, String lastName, DateTime? dateTime) {
    return !_autoValidate! ||
        validateFirstName(firstName) == null &&
            validateLastName(lastName) == null &&
            validateDateOfBirth(dateTime) == null;
  }
}
