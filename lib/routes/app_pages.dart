import 'package:get/get.dart';
import 'app_routes.dart';
import '../view/splash_page.dart';
import '../view/login_page.dart';
import '../view/register_page.dart';
import '../view/home_page.dart';
import '../view/detail_page.dart';
import '../view/bidding_page.dart';
import '../view/edit_profile_page.dart';
import '../view/notification_page.dart';
import '../view/payment_detail_page.dart';
import '../view/wallet_page.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.artDetail,
      page: () => const DetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.bidding,
      page: () => const BiddingPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => EditProfilePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.paymentDetail,
      page: () => const PaymentDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
