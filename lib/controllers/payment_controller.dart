import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/payment_model.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import 'auth_controller.dart';
import 'catalog_controller.dart';
import '../models/bid_model.dart';

class PaymentController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final payments = <PaymentModel>[].obs;
  final isLoading = false.obs;
  final isCreating = false.obs;
  final _pendingCount = 0.obs;
  final pendingItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  Future<void> loadPayments() async {
    isLoading.value = true;
    try {
      final response = await _api.get('/payments');
      final dataList = _extractList(response);
      final mapped = dataList
          .map((json) => PaymentModel.fromJson(json))
          .toList();

      final catCtrl = Get.find<CatalogController>();
      for (int i = 0; i < mapped.length; i++) {
        if (mapped[i].artworkId.isNotEmpty) {
          final detail = await catCtrl.fetchArtworkDetail(mapped[i].artworkId);
          if (detail != null) {
            mapped[i] = mapped[i].copyWith(artistName: detail.artistName);
          }
        }
      }

      payments.assignAll(mapped);
      await calculatePendingCount();
    } catch (error) {
      Get.snackbar('Gagal memuat pembayaran', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Melakukan validasi pembayaran (record ke DB)
  Future<void> createPayment(String bidId, int amount) async {
    isCreating.value = true;
    try {
      await _api.post('/payments', body: {
        'ammounts': amount,
        'fee': 0,
        'for_bid': bidId,
      });

      await loadPayments();

      Get.snackbar(
        'Pembayaran Berhasil ✓',
        'Pembayaran sebesar Rp ${_fmtSnackbar(amount)} telah diproses.',
        backgroundColor: AppColors.success.withValues(alpha: 0.95),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        borderRadius: 14,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (error) {
      Get.snackbar(
        'Pembayaran Gagal',
        error.toString(),
        backgroundColor: AppColors.error.withValues(alpha: 0.95),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        borderRadius: 14,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isCreating.value = false;
    }
  }

  String _fmtSnackbar(int v) => v
      .toString()
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) return response.cast<Map<String, dynamic>>();
    if (response is Map && response['data'] is List) {
      return (response['data'] as List).cast<Map<String, dynamic>>();
    }
    return <Map<String, dynamic>>[];
  }

  double get totalSpent => payments.fold(0.0, (sum, p) => sum + p.amount);
  int get completedCount => payments.length;
  int get pendingCount => _pendingCount.value;

  // Hitung pending payment secara dinamis
  Future<void> calculatePendingCount() async {
    try {
      final authCtrl = Get.find<AuthController>();
      final currentUserId = authCtrl.currentUser.value?.id;
      if (currentUserId == null) {
        _pendingCount.value = 0;
        pendingItems.clear();
        return;
      }

      final catalogCtrl = Get.find<CatalogController>();
      if (catalogCtrl.artworks.isEmpty) {
        await catalogCtrl.loadArtworks();
      }

      // Fetch all bids across all artworks
      final bidResponse = await _api.get('/bid');
      final bidList = _extractList(bidResponse);
      final allBids = bidList.map((json) => BidModel.fromJson(json)).toList();

      final List<Map<String, dynamic>> tempPending = [];
      for (var artwork in catalogCtrl.artworks) {
        if (artwork.isBiddingClosed) {
          final artworkBids = allBids.where((b) => b.artworksId == artwork.id).toList();
          if (artworkBids.isNotEmpty) {
            artworkBids.sort((a, b) => b.amount.compareTo(a.amount));
            final highestBid = artworkBids.first;
            
            if (highestBid.bidById == currentUserId) {
              final hasPaid = payments.any((p) => p.bidId == highestBid.id);
              if (!hasPaid) {
                tempPending.add({
                  'artwork': artwork,
                  'bid': highestBid,
                });
              }
            }
          }
        }
      }
      pendingItems.assignAll(tempPending);
      _pendingCount.value = tempPending.length;
    } catch (e) {
      print("Gagal menghitung pending count: $e");
      _pendingCount.value = 0;
      pendingItems.clear();
    }
  }
}
