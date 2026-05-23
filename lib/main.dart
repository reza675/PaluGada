import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';
import 'bindings/app_bindings.dart';
import 'services/notification_service.dart';
import 'services/background_notification_worker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await initializeDateFormatting('id', null);
  await NotificationService.initialize();
  await BackgroundNotificationWorker.register();
  runApp(const PasarLelangApp());
}


class PasarLelangApp extends StatelessWidget {
  const PasarLelangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Palu Gada',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
