import 'package:http/src/response.dart';
import 'package:flutter_template_app/network/api_client.dart';
import 'package:flutter_template_app/network/api_service.dart';

const String changePasswordPath = 'auth/changePassword';
const String completeSetupPath = 'auth/completeSetup';
const String forgotPasswordPath = 'auth/forgotPassword';
const String setAccountDetailsPath = 'auth/setAccountDetails';
const String signInPath = 'auth/signIn';
const String signUpPath = 'auth/signUp';
const String checkUserPath = 'auth/checkUser';
const String acceptDisclaimerPath = 'auth/acceptDisclaimer';
const String getUserDataPath = 'auth/userData';
const String setUserDataPath = 'auth/userData';

const String sendMessageToSupportPath = 'mail/sendMessageToSupport';

class ApiServiceImpl extends ApiService {
  late ApiClient _apiClient;

  ApiServiceImpl({required String baseApiUrl}) {
    _apiClient = ApiClient(baseApiUrl: baseApiUrl);
  }

  @override
  Future<Response> changePassword({String? password}) async {
    final body = <String, String?>{'password': password};
    return await _apiClient.post(changePasswordPath, body);
  }

  @override
  Future<Response> completeSetup(
      {String? firstName,
      String? middleName,
      String? lastName,
      DateTime? dateOfBirth,
      String? placeOfBirth}) async {
    final body = <String, String?>{
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth!.toIso8601String(),
      'placeOfBirth': placeOfBirth
    };
    return await _apiClient.post(completeSetupPath, body);
  }

  @override
  Future<Response> forgotPassword({String? email}) async {
    final body = <String, String?>{'email': email};
    return await _apiClient.post(forgotPasswordPath, body);
  }

  @override
  Future<Response> sendMessageToSupport({String? subject, String? message}) async {
    final body = <String, String?>{
      'subject': subject,
      'message': message,
    };
    return await _apiClient.post(sendMessageToSupportPath, body);
  }

  @override
  Future<Response> signIn({String? email, String? password}) async {
    final body = <String, String?>{
      'email': email,
      'password': password,
    };
    return await _apiClient.post(signInPath, body);
  }

  @override
  Future<Response> signUp({String? email, String? password}) async {
    final body = <String, String?>{
      'email': email,
      'password': password,
    };
    return await _apiClient.post(signUpPath, body);
  }

  @override
  Future<Response> checkUserAccount() async {
    return await _apiClient.get(checkUserPath);
  }

  @override
  Future<Response> acceptDisclaimer() async {
    return await _apiClient.get(acceptDisclaimerPath);
  }

  @override
  Future<Response> getUserData() async {
    return await _apiClient.get(getUserDataPath);
  }

  @override
  Future<Response> updateUserData(
      {String? email,
      String? firstName,
      String? middleName,
      String? lastName,
      DateTime? birthday,
      String? place}) async {
    final body = <String, String?>{
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dateOfBirth': birthday!.toIso8601String(),
      'placeOfBirth': place,
      'email': email
    };
    return await _apiClient.post(setUserDataPath, body);
  }
}
