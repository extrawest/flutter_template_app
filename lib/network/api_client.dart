import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_template_app/util/secure_storage_utils.dart';
import 'package:http/http.dart' as http;

import 'exception.dart';

const String HEADER_ACCESS_TOKEN = 'Authorization';

class ApiClient {
  final String baseApiUrl;

  var headers = <String, String>{'Content-type': 'application/json'};

  ApiClient({required this.baseApiUrl});

  Future<http.Response> get(
      String url, {
        Map<String, String>? addHeaders,
        Map<String, String>? params,
      }) async {
    dynamic responseJson;
    final updatedHeaders = await _setupHeaders(headers);

    try {
      final uri = _buildUrl(url, params: params);
      print('[HTTP GET REQUEST: $uri, headers: $updatedHeaders]');
      final response = await http.get(uri, headers: updatedHeaders);
      print('[HTTP GET RESPONSE: $uri, ${response.body}]');
      _validateResponse(response);
      responseJson = json.decode(response.body.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<http.Response> post(
      String url,
      Map<String, String?> jsonBody, {
        Map<String, String>? addHeaders,
        Map<String, String>? params,
      }) async {
    dynamic responseJson;
    final updatedHeaders = await _setupHeaders(headers);

    try {
      final uri = _buildUrl(url, params: params);
      print('[HTTP POST REQUEST: $uri, body: $jsonBody, headers: $updatedHeaders]');
      final response = await http.post(uri, body: jsonBody, headers: updatedHeaders);
      print('[HTTP POST RESPONSE: $uri, ${response.body}]');
      _validateResponse(response);
      responseJson = json.decode(response.body.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<http.Response> put(
      String url, {
        Map<String, String>? headers,
        Map<String, String>? params,
      }) async {
    dynamic responseJson;
    final updatedHeaders = await _setupHeaders(headers);
    final uri = _buildUrl(url, params: params);
    try {
      print('[HTTP PUT REQUEST: $uri, headers: $headers]');
      final response = await http.put(uri, headers: updatedHeaders);
      print('[HTTP PUT RESPONSE: $uri, headers: $updatedHeaders, body: ${response.body}]');

      _validateResponse(response);
      responseJson = json.decode(response.body.toString());

    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  /// Creating [Uri] object of the request. Using https protocol.
  Uri _buildUrl(String url, {Map<String, String>? params}) {
    print('baseApiUrl $baseApiUrl');
    Uri uri;
    if (params != null) {
      uri = Uri.https(baseApiUrl, url, params);
    } else {
      uri = Uri.https(baseApiUrl, url);
    }
    print('uri $uri');
    return uri;
  }


  /// Adding access token from local storage if it exists
  Future<Map<String, String>> _setupHeaders(Map<String, String>? newHeaders) async {
    final updatedHeaders = <String, String>{};

    updatedHeaders.addAll(headers);
    if (newHeaders != null) {
      updatedHeaders.addAll(newHeaders);
    }

    final authToken = await SecureStorageUtils.readAuthToken();
    if (authToken != null) {
      updatedHeaders.addAll({HEADER_ACCESS_TOKEN: 'Bearer $authToken'});
    }
    return updatedHeaders;
  }

  /// Check response status code and throw proper error
  void _validateResponse(http.Response response) {
    switch (response.statusCode) {
    // TODO: update response codes
      case 201:
      case 200:
        final responseJson = json.decode(response.body.toString());
        print('responseJson $responseJson');
        break;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

