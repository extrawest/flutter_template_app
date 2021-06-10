import 'package:flutter/cupertino.dart';
import 'package:http/src/response.dart';
import 'package:flutter_template_app/network/api_service.dart';

class ApiServiceMock extends ApiService {
  @override
  Future<Response> changePassword({required String password}) async {
    await Future.delayed(Duration(seconds: 1));
    return Response('{\"message\": \"Password was changed.\"}', 200);
  }

  @override
  Future<Response> completeSetup(
      {required String firstName,
      String? middleName,
      required String lastName,
      required DateTime? dateOfBirth,
      required String placeOfBirth}) async {
    await Future.delayed(Duration(seconds: 2));
    return Response('{\"status\": \"completedSetup\"}', 200);
  }

  @override
  Future<Response> forgotPassword({required String email}) async {
    await Future.delayed(Duration(seconds: 2));
    if (email == 'test@mail.com') {
      return Response('{\"message\": \"An email has been sent to you.\"}', 200);
    } else {
      return Response(
          '{\"message\": \"Forgot password failed. We did not find your email.\"}', 401);
    }
  }

  @override
  Future<Response> sendMessageToSupport({required String subject, required String message}) async {
    await Future.delayed(Duration(seconds: 2));
    return Response('{\"message\": \"Message was sent to support.\"}', 200);
  }

  @override
  Future<Response> signIn({required String email, required String password}) async {
    await Future.delayed(Duration(seconds: 2));
    if (email == 'test@mail.com' && password == '111111') {
      return Response('{\"token\": \"123456789\"}', 200);
    } else {
      return Response('{\"message\": \"Sign in failed. Wrong email or password.\"}', 401);
    }
  }

  @override
  Future<Response> signUp({required String email, required String password}) async {
    await Future.delayed(Duration(seconds: 2));
    return Response('{\"token\": \"123456789\"}', 200);
  }

  @override
  Future<Response> checkUserAccount() async {
    await Future.delayed(Duration(seconds: 1));
    return Response('{\"status\": \"completedSetup\"}', 200);
  }

  @override
  Future<Response> acceptDisclaimer() async {
    await Future.delayed(Duration(seconds: 1));
    return Response('{\"status\": \"accepted\"}', 200);
  }

  @override
  Future<Response> getUserData() async {
    await Future.delayed(Duration(seconds: 2));
    return Response(
        '{\"user\" : { \"email\": \"test@mail.com\", \"first_name\": \"John\", \"middle_name\": null, \"last_name\": \"Smith\", \"date_of_birth\": \"2011-10-05T14:48:00.000Z\", \"place_of_birth\":  \"Melbourne\"}}',
        200);
  }

  @override
  Future<Response> updateUserData({String? email, String? firstName, String? middleName, String? lastName, DateTime? birthday, String? place}) async {
    await Future.delayed(Duration(seconds: 1));
    return Response('{\"message\": \"User data has been changed.\"}', 200);
  }
}
