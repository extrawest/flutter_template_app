import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_template_app/network/api_service_impl.dart';
import 'package:flutter_template_app/network/api_service_mock.dart';

/// Abstract class for definition requests
/// [ApiServiceImpl] - real service for interaction with the Backend
/// [ApiServiceMock] - mock server for testing the app functionality without the Backend

abstract class ApiService {
  Future<Response> signUp({required String email, required String password});

  Future<Response> signIn({required String email, required String password});

  Future<Response> forgotPassword({required String email});

  Future<Response> completeSetup(
      {required String firstName,
      String? middleName,
      required String lastName,
      required DateTime? dateOfBirth,
      required String placeOfBirth});


  Future<Response> changePassword({required String password});

  Future<Response> sendMessageToSupport(
      {required String subject, required String message});

  Future<Response> checkUserAccount();

  Future<Response> acceptDisclaimer();

  Future<Response> getUserData();

  Future<Response> updateUserData({
    required String email,
    required String firstName,
    required String? middleName,
    required String lastName,
    required DateTime? birthday,
    required String? place});

}
