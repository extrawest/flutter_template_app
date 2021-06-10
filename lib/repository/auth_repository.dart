import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_template_app/network/api_service.dart';

/// [AuthRepository] is a middleware between Provider and Api Service
/// Using for requests associated with user's data and app's accessibility
class AuthRepository {
  final ApiService _apiService;

  AuthRepository({required ApiService apiService}) : _apiService = apiService;

  Future<Response> signIn({required String email, required String password}) async {
    return await _apiService.signIn(email: email, password: password);
  }

  Future<Response> signUp({required String email, required String password}) async {
    return await _apiService.signUp(email: email, password: password);
  }

  Future<Response> forgotPassword({required String email}) async {
    return await _apiService.forgotPassword(email: email);
  }

  // TODO: Modify your UserStatus or data parser according to backend response.
  Future<Response> checkUserAccount() async {
    return await _apiService.checkUserAccount();
  }

  Future<Response> completeSetup({
  required String firstName,
  String? middleName,
  required String lastName,
  required DateTime? dateTime,
  required String placeOfBirth
  }) async {
    return await _apiService.completeSetup(
      dateOfBirth: dateTime,
      firstName: firstName,
      lastName: lastName,
      placeOfBirth: placeOfBirth,
      middleName: middleName
    );
  }

  Future<Response> acceptDisclaimer() async {
    return await _apiService.acceptDisclaimer();
  }

  Future<Response> getUserData() async {
    return await _apiService.getUserData();
  }

  Future<Response> changePassword(String password) async {
    return await _apiService.changePassword(password: password);
  }

  Future<Response> saveUserData({
    required String email,
    required String firstName,
    String? middleName,
    required String lastName,
    required DateTime? dateTime,
    required String? placeOfBirth
  }) async {
    return await _apiService.updateUserData(
        email: email,
        birthday: dateTime,
        firstName: firstName,
        lastName: lastName,
        place: placeOfBirth,
        middleName: middleName
    );
  }

}
