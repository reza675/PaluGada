import 'package:get/get.dart';
import '../models/payment_model.dart';

class PaymentController extends GetxController {
  final payments = <PaymentModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockPayments();
  }

  void loadMockPayments() {
    isLoading.value = true;
    payments.value = [
      PaymentModel(id: 'pay_001', artworkId: 'art_010', artworkTitle: 'Harmony in Chaos', artworkImageUrl: 'https://picsum.photos/seed/pay1/200/200', amount: 8500000, status: 'completed', paymentMethod: 'Bank BCA', paymentDate: DateTime.now().subtract(const Duration(days: 3))),
      PaymentModel(id: 'pay_002', artworkId: 'art_011', artworkTitle: 'Morning Dew', artworkImageUrl: 'https://picsum.photos/seed/pay2/200/200', amount: 3200000, status: 'completed', paymentMethod: 'GoPay', paymentDate: DateTime.now().subtract(const Duration(days: 7))),
      PaymentModel(id: 'pay_003', artworkId: 'art_012', artworkTitle: 'Batik Modern', artworkImageUrl: 'https://picsum.photos/seed/pay3/200/200', amount: 12000000, status: 'pending', paymentMethod: 'Bank Mandiri', paymentDate: DateTime.now().subtract(const Duration(days: 1))),
      PaymentModel(id: 'pay_004', artworkId: 'art_013', artworkTitle: 'Keris Pusaka', artworkImageUrl: 'https://picsum.photos/seed/pay4/200/200', amount: 25000000, status: 'completed', paymentMethod: 'Bank BNI', paymentDate: DateTime.now().subtract(const Duration(days: 14))),
      PaymentModel(id: 'pay_005', artworkId: 'art_014', artworkTitle: 'Abstract Volcano', artworkImageUrl: 'https://picsum.photos/seed/pay5/200/200', amount: 6700000, status: 'failed', paymentMethod: 'OVO', paymentDate: DateTime.now().subtract(const Duration(days: 5))),
    ];
    isLoading.value = false;
  }

  double get totalSpent => payments.where((p) => p.status == 'completed').fold(0.0, (sum, p) => sum + p.amount);
  int get completedCount => payments.where((p) => p.status == 'completed').length;
  int get pendingCount => payments.where((p) => p.status == 'pending').length;
}
