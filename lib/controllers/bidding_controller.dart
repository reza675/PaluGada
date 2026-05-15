import 'package:get/get.dart';
import '../models/bid_model.dart';

class BiddingController extends GetxController {
  final bids = <BidModel>[].obs;
  final isLoading = false.obs;
  final currentArtworkId = ''.obs;

  void loadBidsForArtwork(String artworkId) {
    isLoading.value = true;
    currentArtworkId.value = artworkId;
    bids.value = [
      BidModel(id: 'bid_001', artworkId: artworkId, bidderId: 'usr_010', bidderName: 'Ahmad Fauzi', amount: 7500000, bidTime: DateTime.now().subtract(const Duration(minutes: 5))),
      BidModel(id: 'bid_002', artworkId: artworkId, bidderId: 'usr_011', bidderName: 'Siti Rahayu', amount: 7000000, bidTime: DateTime.now().subtract(const Duration(minutes: 30))),
      BidModel(id: 'bid_003', artworkId: artworkId, bidderId: 'usr_012', bidderName: 'Budi Santoso', amount: 6500000, bidTime: DateTime.now().subtract(const Duration(hours: 1))),
      BidModel(id: 'bid_004', artworkId: artworkId, bidderId: 'usr_013', bidderName: 'Dewi Lestari', amount: 6000000, bidTime: DateTime.now().subtract(const Duration(hours: 2))),
      BidModel(id: 'bid_005', artworkId: artworkId, bidderId: 'usr_014', bidderName: 'Hasan Ibrahim', amount: 5500000, bidTime: DateTime.now().subtract(const Duration(hours: 3))),
      BidModel(id: 'bid_006', artworkId: artworkId, bidderId: 'usr_015', bidderName: 'Linda Wijaya', amount: 5200000, bidTime: DateTime.now().subtract(const Duration(hours: 5))),
    ];
    isLoading.value = false;
  }

  BidModel? get lastBid => bids.isNotEmpty ? bids.first : null;

  double get highestBid =>
      bids.isNotEmpty ? bids.map((b) => b.amount).reduce((a, b) => a > b ? a : b) : 0;

  double get lowestBid =>
      bids.isNotEmpty ? bids.map((b) => b.amount).reduce((a, b) => a < b ? a : b) : 0;

  Future<bool> placeBid(String artworkId, double amount, String bidderName) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    final newBid = BidModel(
      id: 'bid_${DateTime.now().millisecondsSinceEpoch}',
      artworkId: artworkId, bidderId: 'usr_001',
      bidderName: bidderName, amount: amount,
    );
    bids.insert(0, newBid);
    isLoading.value = false;
    Get.snackbar('Bid Berhasil! 🎉', 'Anda menawar Rp ${_formatCurrency(amount)}', snackPosition: SnackPosition.TOP);
    return true;
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
