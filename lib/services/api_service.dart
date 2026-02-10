import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = Duration(seconds: AppConstants.requestTimeout);

  final http.Client _client = http.Client();

  // Get headers with authentication
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = StorageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  void _logRequest(String method, Uri uri, Map<String, String> headers, dynamic body) {
    if (!kDebugMode) return;
    debugPrint('[ApiService][$method] ${uri.toString()}');
    debugPrint('[ApiService][Headers] ${jsonEncode(headers)}');
    if (body != null) {
      debugPrint('[ApiService][Body] ${jsonEncode(body)}');
    }
  }

  void _logResponse(String method, Uri uri, http.Response response) {
    if (!kDebugMode) return;
    debugPrint('[ApiService][$method][Response ${response.statusCode}] ${uri.toString()}');
    if (response.body.isNotEmpty) {
      debugPrint('[ApiService][Payload] ${response.body}');
    }
  }

  void _logError(String stage, Object error) {
    if (!kDebugMode) return;
    debugPrint('[ApiService][Error][$stage] ${error.toString()}');
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    var uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'An error occurred');
    }
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final headers = _getHeaders(includeAuth: includeAuth);
      _logRequest('GET', uri, headers, queryParams);

      final response = await _client
          .get(uri, headers: headers)
          .timeout(_timeout);

      _logResponse('GET', uri, response);
      return _handleResponse(response);
    } catch (e) {
      _logError('GET $endpoint', e);
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _getHeaders(includeAuth: includeAuth);
      _logRequest('POST', uri, headers, body);

      final response = await _client
          .post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      _logResponse('POST', uri, response);
      return _handleResponse(response);
    } catch (e) {
      _logError('POST $endpoint', e);
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _getHeaders(includeAuth: includeAuth);
      _logRequest('PUT', uri, headers, body);

      final response = await _client
          .put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      _logResponse('PUT', uri, response);
      return _handleResponse(response);
    } catch (e) {
      _logError('PUT $endpoint', e);
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _getHeaders(includeAuth: includeAuth);
      _logRequest('DELETE', uri, headers, null);

      final response = await _client
          .delete(
            uri,
            headers: headers,
          )
          .timeout(_timeout);

      _logResponse('DELETE', uri, response);
      return _handleResponse(response);
    } catch (e) {
      _logError('DELETE $endpoint', e);
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // PATCH request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = _getHeaders(includeAuth: includeAuth);
      _logRequest('PATCH', uri, headers, body);

      final response = await _client
          .patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      _logResponse('PATCH', uri, response);
      return _handleResponse(response);
    } catch (e) {
      _logError('PATCH $endpoint', e);
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Upload file (multipart)
  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    String filePath,
    String fieldName, {
    Map<String, String>? additionalFields,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      final token = StorageService.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      if (kDebugMode) {
        debugPrint('[ApiService][UPLOAD] ${uri.toString()}');
        debugPrint('[ApiService][UPLOAD][Fields] ${additionalFields ?? {}}');
      }

      // Add file
      final file = await http.MultipartFile.fromPath(fieldName, filePath);
      request.files.add(file);

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logResponse('UPLOAD', uri, response);

      return _handleResponse(response);
    } catch (e) {
      _logError('UPLOAD $endpoint', e);
      throw Exception('Upload error: ${e.toString()}');
    }
  }
}
