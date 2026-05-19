import 'package:get/get.dart';
import '../models/bid_model.dart';
import '../services/api_service.dart';

class BiddingController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final bids = <BidModel>[].obs;
  final isLoading = false.obs;
  final currentArtworkId = ''.obs;

  /// Load all bids from API
  Future<void> loadBidsForArtwork(String artworkId) async {
    isLoading.value = true;
    currentArtworkId.value = artworkId;
    try {
      final response = await _api.get('/bid');
      final dataList = _extractList(response);
      final allBids = dataList.map((json) => BidModel.fromJson(json)).toList();
      // Filter bids for this artwork
      final filtered = allBids.where((b) => b.artworksId == artworkId).toList();
      filtered.sort((a, b) => b.amount.compareTo(a.amount)); // highest first
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

  /// Place a new bid via API
  Future<bool> placeBid(String artworkId, int ammount) async {
    isLoading.value = true;
    try {
      await _api.post(
        '/bid/new',
        body: {'artworks_id': artworkId, 'ammount': ammount},
      );
      Get.snackbar(
        'Bid Berhasil! 🎉',
        'Anda menawar Rp ${_formatCurrency(ammount.toDouble())}',
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
