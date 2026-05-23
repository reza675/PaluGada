import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';

class WalletController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final balance = 0.0.obs;
  final isLoading = false.obs;
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBalance();
  }

  // Fetch saldo wallet dari backend
  Future<void> loadBalance() async {
    isLoading.value = true;
    try {
      final response = await _api.get('/wallet');
      if (response is Map<String, dynamic>) {
        balance.value = (response['balance'] ?? 0).toDouble();
      }
    } catch (e) {
      // Jika gagal, biarkan saldo 0
    } finally {
      isLoading.value = false;
    }
  }

  // Top up saldo wallet
  Future<void> topUp(double amount) async {
    if (amount <= 0) return;
    isProcessing.value = true;
    try {
      final response = await _api.put('/wallet/topup', body: {'amount': amount});
      if (response is Map<String, dynamic>) {
        balance.value = (response['balance'] ?? 0).toDouble();
      }
      Get.snackbar(
        'Top Up Berhasil ✓',
        'Saldo Anda bertambah Rp ${_fmt(amount)}',
        backgroundColor: AppColors.success.withValues(alpha: 0.95),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        borderRadius: 14,
        icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Top Up Gagal',
        e.toString(),
        backgroundColor: AppColors.error.withValues(alpha: 0.95),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isProcessing.value = false;
    }
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}
