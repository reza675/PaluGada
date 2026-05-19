import 'package:get/get.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Login via API
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _api.post(
        '/user/login',
        body: {'email': email, 'password': password},
      );
      final token = response is Map ? response['token']?.toString() : null;
      if (token == null || token.isEmpty) {
        throw Exception('Token login tidak ditemukan');
      }
      await _api.setToken(token);

      final profileResp = await _api.get('/user/profile');
      if (profileResp is Map && profileResp['user'] != null) {
        currentUser.value = UserModel.fromJson(
          profileResp['user'] as Map<String, dynamic>,
        );
      } else {
        throw Exception('Gagal mengambil profil pengguna');
      }

      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.home);
    } catch (error) {
      Get.snackbar('Login gagal', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Register via API
  Future<void> register(
    String username,
    String full_name,
    String email,
    String password,
    String phone_number,
  ) async {
    isLoading.value = true;
    try {
      await _api.post(
        '/user/register',
        body: {
          'username': username,
          'full_name': full_name,
          'email': email,
          'phone_number': phone_number,
          'password': password,
          'role': 'KOLEKTOR',
        },
      );
      isLoggedIn.value = false;
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('Registrasi berhasil', 'Silakan login untuk melanjutkan');
    } catch (error) {
      Get.snackbar('Registrasi gagal', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update account via API
  Future<void> updateAccount({
    String? full_name,
    String? phone_number,
    String? email,
  }) async {
    isLoading.value = true;
    try {
      await _api.put(
        '/user/update/profile',
        body: {if (full_name != null) 'full_name': full_name},
      );
      if (currentUser.value != null) {
        currentUser.value = currentUser.value!.copyWith(
          full_name: full_name ?? currentUser.value!.full_name,
          phone_number: phone_number ?? currentUser.value!.phone_number,
          email: email ?? currentUser.value!.email,
        );
      }
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui');
    } catch (error) {
      Get.snackbar('Gagal', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete account via API
  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      await _api.delete('/user/delete');
      await _api.clearToken();
      currentUser.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('Akun Dihapus', 'Akun Anda telah dihapus');
    } catch (error) {
      Get.snackbar('Gagal', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _api.clearToken();
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }
}
