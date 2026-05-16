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
        body: {
          'email': email,
          'password': password,
        },
      );
      final token = response is Map ? response['token']?.toString() : null;
      if (token == null || token.isEmpty) {
        throw Exception('Token login tidak ditemukan');
      }
      await _api.setToken(token);

      currentUser.value = UserModel(
        id: 'usr_local',
        name: email.split('@').first,
        email: email,
        role: 'collector',
      );
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
    String name,
    String email,
    String password,
    String phone,
  ) async {
    isLoading.value = true;
    try {
      await _api.post(
        '/user/register',
        body: {
          'username': username,
          'full_name': name,
          'email': email,
          'phone_number': phone,
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

  /// Update account
  Future<void> updateAccount({String? name, String? phone, String? email}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(
        name: name ?? currentUser.value!.name,
        phone: phone ?? currentUser.value!.phone,
        email: email ?? currentUser.value!.email,
      );
    }
    isLoading.value = false;
    Get.snackbar('Berhasil', 'Profil berhasil diperbarui');
  }

  /// Delete account
  Future<void> deleteAccount() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    currentUser.value = null;
    isLoggedIn.value = false;
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.login);
    Get.snackbar('Akun Dihapus', 'Akun Anda telah dihapus');
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }
}
