import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/repository/auth_repository.dart';

class OnboardingProvider extends ChangeNotifier {

  final AuthRepository _authRepository;

  late NetworkResponse<String> acceptDisclaimerResponse;

  OnboardingProvider({required AuthRepository authRepository}) : _authRepository = authRepository;

  void reset(){
    acceptDisclaimerResponse = NetworkResponse<String>.none();
  }

  Future<void> accept() async {
    acceptDisclaimerResponse = NetworkResponse.loading('Accepting is in progress...');
    notifyListeners();
    try {
      var response = await _authRepository.acceptDisclaimer();

      if (response.statusCode == 200) {
        acceptDisclaimerResponse = NetworkResponse.completed(jsonDecode(response.body)['status']);
      } else {
        acceptDisclaimerResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch(e){
      acceptDisclaimerResponse = NetworkResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }


}