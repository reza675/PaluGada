/// ApiService — Placeholder untuk integrasi API nantinya.
///
/// Saat ini semua data menggunakan mock di controller.
/// Setelah endpoint API dari teman selesai, implementasi method di sini
/// lalu panggil dari controller.
///
/// Contoh penggunaan nanti:
/// ```dart
/// class AuthController extends GetxController {
///   final ApiService _api = Get.find<ApiService>();
///
///   Future<void> login(String email, String password) async {
///     final response = await _api.post('/auth/login', body: {...});
///     ...
///   }
/// }
/// ```
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends GetxService {
  static const String _defaultBaseUrl = 'http://127.0.0.1:3000';
  static const String _baseUrlKey = 'api_base_url';
  static const String _tokenKey = 'auth_token';

  SharedPreferences? _prefs;
  String _baseUrl = _defaultBaseUrl;

  String get baseUrl => _baseUrl;

  Future<SharedPreferences> get _prefsInstance async {
    _prefs ??= await SharedPreferences.getInstance();
    _baseUrl = _prefs?.getString(_baseUrlKey) ?? _defaultBaseUrl;
    return _prefs!;
  }

  Future<void> setBaseUrl(String url) async {
    _baseUrl = url;
    final prefs = await _prefsInstance;
    await prefs.setString(_baseUrlKey, url);
  }

  Future<void> setToken(String token) async {
    final prefs = await _prefsInstance;
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefsInstance;
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await _prefsInstance;
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _resolveUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return Uri.parse(endpoint);
    }
    final normalized = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$_baseUrl$normalized');
  }

  dynamic _decodeResponse(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json') && response.body.isNotEmpty) {
      return jsonDecode(response.body);
    }
    return response.body;
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    final body = _decodeResponse(response);
    final message = body is Map && body['message'] != null
        ? body['message'].toString()
        : 'HTTP ${response.statusCode}';
    throw ApiException(message, statusCode: response.statusCode);
  }

  /// GET request
  Future<dynamic> get(String endpoint) async {
    final url = _resolveUrl(endpoint);
    final response = await http
        .get(url, headers: await _buildHeaders())
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
    return _decodeResponse(response);
  }

  /// POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final url = _resolveUrl(endpoint);
    final response = await http
        .post(
          url,
          headers: await _buildHeaders(),
          body: jsonEncode(body ?? {}),
        )
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
    return _decodeResponse(response);
  }

  /// PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    final url = _resolveUrl(endpoint);
    final response = await http
        .put(
          url,
          headers: await _buildHeaders(),
          body: jsonEncode(body ?? {}),
        )
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
    return _decodeResponse(response);
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    final url = _resolveUrl(endpoint);
    final response = await http
        .delete(url, headers: await _buildHeaders())
        .timeout(const Duration(seconds: 20));
    _ensureSuccess(response);
    return _decodeResponse(response);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
