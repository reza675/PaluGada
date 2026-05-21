import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/catalog_controller.dart';
import '../controllers/bidding_controller.dart';
import '../controllers/payment_controller.dart';
import '../controllers/home_controller.dart';
import '../services/api_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => CatalogController(), fenix: true);
    Get.lazyPut(() => BiddingController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
