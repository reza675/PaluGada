import 'package:get/get.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Mock login – ganti dengan real API / Firebase Auth nanti
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    currentUser.value = UserModel(
      id: 'usr_001',
      name: 'Reza',
      email: email,
      phone: '+62 812 3456 7890',
      role: 'collector',
    );
    isLoggedIn.value = true;
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.home);
  }

  /// Mock register
  Future<void> register(String name, String email, String password, String phone) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    currentUser.value = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: 'collector',
    );
    isLoggedIn.value = true;
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.home);
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
