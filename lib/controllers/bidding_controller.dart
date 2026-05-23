import 'package:get/get.dart';
import '../models/bid_model.dart';
import '../services/api_service.dart';
import '../controllers/wallet_controller.dart';

class BiddingController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final bids = <BidModel>[].obs;
  final isLoading = false.obs;
  final currentArtworkId = ''.obs;

  Future<void> loadBidsForArtwork(String artworkId) async {
    isLoading.value = true;
    currentArtworkId.value = artworkId;
    try {
      final response = await _api.get('/bid');
      final dataList = _extractList(response);
      final allBids = dataList.map((json) => BidModel.fromJson(json)).toList();
      final filtered = allBids.where((b) => b.artworksId == artworkId).toList();
      filtered.sort((a, b) => b.amount.compareTo(a.amount)); 
      bids.assignAll(filtered);
    } catch (error) {
      Get.snackbar('Gagal memuat bid', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) return response.cast<Map<String, dynamic>>();
    if (response is Map && response['data'] is List) {
      return (response['data'] as List).cast<Map<String, dynamic>>();
    }
    return <Map<String, dynamic>>[];
  }

  BidModel? get lastBid => bids.isNotEmpty ? bids.first : null;

  double get highestBid => bids.isNotEmpty
      ? bids.map((b) => b.amount.toDouble()).reduce((a, b) => a > b ? a : b)
      : 0;

  double get lowestBid => bids.isNotEmpty
      ? bids.map((b) => b.amount.toDouble()).reduce((a, b) => a < b ? a : b)
      : 0;

  /// Bid pemenang
  BidModel? get winnerBid {
    final openBids = bids.where((b) => b.status == 'OPEN').toList();
    if (openBids.isEmpty) return null;
    openBids.sort((a, b) => b.amount.compareTo(a.amount));
    return openBids.first;
  }
  
  String? get winnerBidId => winnerBid?.id;

  String? get winnerUserId => winnerBid?.bidById;

  Future<bool> placeBid(String artworkId, int ammount) async {
    isLoading.value = true;
    try {
      final response = await _api.post(
        '/bid/new',
        body: {'artworks_id': artworkId, 'ammount': ammount},
      );
      // Backend mengembalikan walletBalance setelah deduct
      if (response is Map<String, dynamic>) {
        final newBalance = response['walletBalance'];
        if (newBalance != null) {
          try {
            final walletCtrl = Get.find<WalletController>();
            walletCtrl.balance.value = (newBalance is num)
                ? newBalance.toDouble()
                : double.tryParse(newBalance.toString()) ?? 0;
          } catch (_) {
            // WalletController em ini diabaikan ae
          }
        }
      }

      Get.snackbar(
        'Bid Berhasil!',
        'Anda menawar Rp ${_formatCurrency(ammount.toDouble())}.\nSaldo wallet telah dikurangi otomatis.',
        snackPosition: SnackPosition.TOP,
      );
      await loadBidsForArtwork(artworkId);
      return true;
    } catch (error) {
      Get.snackbar('Bid Gagal', error.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _formatCurrency(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
