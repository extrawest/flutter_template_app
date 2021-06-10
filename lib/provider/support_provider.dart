import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template_app/network/api_service.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/service/service_locator.dart';
import 'package:flutter_template_app/service/validation_service.dart';

class SupportProvider extends ChangeNotifier {
  bool? _autoValidate;
  late NetworkResponse<String> emailSendResponse;
  late ValidationService _validationService;

  final ApiService _apiService;

  SupportProvider(this._apiService) {
    _validationService = serviceLocator.get<ValidationService>();
  }

  void reset() {
    _autoValidate = false;
    emailSendResponse = NetworkResponse<String>.none();
  }

  bool? get autoValidate => _autoValidate;

  set autoValidate(bool? value) {
    _autoValidate = value;
    notifyListeners();
  }

  bool isDataValid(String subject, String message) {
    return !_autoValidate! ||
        _validationService.validateSubject(subject) == null &&
            _validationService.validateMessage(message) == null;
  }

  Future<void> sendMessageToSupport(String subject, String message) async {
    emailSendResponse = NetworkResponse.loading('Message is sending...');
    notifyListeners();
    try {
      final response = await _apiService.sendMessageToSupport(subject: subject, message: message);
      if (response.statusCode == 200) {
        emailSendResponse = NetworkResponse.completed(jsonDecode(response.body)?['message']);
      } else {
        emailSendResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      emailSendResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }

  String? validateSubject(String? value) {
    return _validationService.validateSubject(value ?? '');
  }

  String? validateMessage(String? value) {
    return _validationService.validateMessage(value ?? '');
  }
}
