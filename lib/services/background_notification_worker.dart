import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

// task background worker
const String kBgNotifTask = 'palugada_bg_notif_check';
const String kBgNotifTag = 'palugada_notif';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == kBgNotifTask) {
      await _checkAndPushNotifications();
    }
    return true;
  });
}

// Cek notif baru dari backend
Future<void> _checkAndPushNotifications() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final baseUrl = prefs.getString('api_base_url') ??
        'https://tcc-final-project-805193520.us-central1.run.app';

    if (token == null || token.isEmpty) return;

    final response = await http
        .get(
          Uri.parse('$baseUrl/notification'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) return;

    final List<dynamic> rawList = jsonDecode(response.body);
    final pushedJson = prefs.getString('_bg_pushed_notif_ids') ?? '[]';
    final pushedIds = Set<String>.from(jsonDecode(pushedJson) as List);

    final plugin = FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await plugin.initialize(settings);

    final newPushed = <String>{};

    for (final item in rawList) {
      if (item is! Map<String, dynamic>) continue;
      final id = item['id']?.toString() ?? '';
      if (id.isEmpty || pushedIds.contains(id)) continue;

      final message = item['message']?.toString() ?? '';
      final title = _deriveTitle(message);

      final androidDetails = AndroidNotificationDetails(
        'palugada_channel',
        'Palu Gada Notifications',
        channelDescription: 'Notifikasi untuk aplikasi Palu Gada Lelang Seni',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );
      await plugin.show(
        id.hashCode.abs(),
        title,
        message,
        NotificationDetails(android: androidDetails),
      );

      newPushed.add(id);
    }

    // Simpan ID yang sudah di-push
    final updatedPushed = {...pushedIds, ...newPushed};
    final limitedPushed = updatedPushed.toList();
    if (limitedPushed.length > 100) {
      limitedPushed.removeRange(0, limitedPushed.length - 100);
    }
    await prefs.setString('_bg_pushed_notif_ids', jsonEncode(limitedPushed));
  } catch (_) {
    // abaikan
  }
}

String _deriveTitle(String message) {
  final lower = message.toLowerCase();
  if (lower.contains('outbid') || lower.contains('highest bid')) {
    return 'Penawaran Anda Disalip!';
  }
  return 'Notifikasi Lelang';
}
class BackgroundNotificationWorker {
  static Future<void> register() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    await Workmanager().registerPeriodicTask(
      kBgNotifTag,
      kBgNotifTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }

  static Future<void> cancel() async {
    await Workmanager().cancelByTag(kBgNotifTag);
  }
}
