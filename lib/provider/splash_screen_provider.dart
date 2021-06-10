import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template_app/network/network_response.dart';
import 'package:flutter_template_app/repository/auth_repository.dart';
import 'package:flutter_template_app/routes.dart';
import 'package:flutter_template_app/status/user_status.dart';
import 'package:flutter_template_app/util/secure_storage_utils.dart';

class SplashScreenProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  SplashScreenProvider({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<String> getScreenRouteBasedOnUserData() async {
    final token = await SecureStorageUtils.readAuthToken();

    if (token == null) {
      return welcomeScreenRoute;
    }

    final checkUserResponse = await _loadUserStatus();
    if (checkUserResponse.status.isCompleted) {
      switch (checkUserResponse.data) {
        case UserStatus.notCompletedSetup:
          return accountSetupScreenRoute;
        case UserStatus.completedSetup:
          return dashboardScreenRoute;
        case UserStatus.notAccepted:
        default:
          return onboardingScreenRoute;
      }
    }
    if (checkUserResponse.status.isError) {
      print(checkUserResponse.message);
      await SecureStorageUtils.writeAuthToken(null);
    }
    return welcomeScreenRoute;
  }

  Future<NetworkResponse<UserStatus>> _loadUserStatus() async {
    var checkUserResponse = NetworkResponse<UserStatus>.none();
    try {
      final response = await _authRepository.checkUserAccount();
      if (response.statusCode == 200) {
        checkUserResponse =
            NetworkResponse.completed(decodeUserStatus(jsonDecode(response.body)['status']));
      } else {
        checkUserResponse = NetworkResponse.error(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      checkUserResponse = NetworkResponse.error(e.toString());
    }
    return checkUserResponse;
  }
}
