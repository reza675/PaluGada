import 'package:get/get.dart';
import '../models/payment_model.dart';
import '../services/api_service.dart';

class PaymentController extends GetxController {
  final ApiService _api = Get.find<ApiService>();
  final payments = <PaymentModel>[].obs;
  final isLoading = false.obs;

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
      payments.assignAll(mapped);
    } catch (error) {
      Get.snackbar('Gagal memuat pembayaran', error.toString());
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

  double get totalSpent => payments.fold(0.0, (sum, p) => sum + p.amount);
  int get completedCount => payments.length;
  int get pendingCount => 0;
}
