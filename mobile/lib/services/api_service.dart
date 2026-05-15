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

class ApiService extends GetxService {
  // Ganti dengan base URL API teman kamu nanti
  static const String baseUrl = 'https://your-api-url.com/api';

  // Headers default
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Tambahkan Authorization header setelah login:
    // 'Authorization': 'Bearer $token',
  };

  /// GET request
  Future<dynamic> get(String endpoint) async {
    // TODO: Implementasi HTTP GET
    // final response = await http.get(
    //   Uri.parse('$baseUrl$endpoint'),
    //   headers: _headers,
    // );
    // return jsonDecode(response.body);
    throw UnimplementedError('API belum diimplementasi');
  }

  /// POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    // TODO: Implementasi HTTP POST
    // final response = await http.post(
    //   Uri.parse('$baseUrl$endpoint'),
    //   headers: _headers,
    //   body: jsonEncode(body),
    // );
    // return jsonDecode(response.body);
    throw UnimplementedError('API belum diimplementasi');
  }

  /// PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    // TODO: Implementasi HTTP PUT
    throw UnimplementedError('API belum diimplementasi');
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    // TODO: Implementasi HTTP DELETE
    throw UnimplementedError('API belum diimplementasi');
  }
}
