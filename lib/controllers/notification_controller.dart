import 'dart:async';
import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  final _pushedIds = <String>{};

  Timer? _pollingTimer;
  // Jumlah notifikasi yang belum dibaca
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _pollForNewNotifications(),
    );
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  /// Memuat semua notifikasi dari backend Redis
  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final response = await _api.get('/notification');
      final List<dynamic> rawList =
          response is List ? response : [];

      final fetched = rawList
          .whereType<Map<String, dynamic>>()
          .map((json) => NotificationModel.fromApi(json))
          .toList();

      fetched.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final currentReadIds = notifications
          .where((n) => n.isRead)
          .map((n) => n.id)
          .toSet();

      final merged = fetched.map((n) {
        return currentReadIds.contains(n.id) ? n.copyWith(isRead: true) : n;
      }).toList();

      notifications.assignAll(merged);

      _pushNewToSystemTray(merged);
    } catch (error) {
      if (isLoading.value) {
        Get.snackbar('Gagal memuat notifikasi', error.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _pollForNewNotifications() async {
    try {
      final response = await _api.get('/notification');
      final List<dynamic> rawList = response is List ? response : [];

      final fetched = rawList
          .whereType<Map<String, dynamic>>()
          .map((json) => NotificationModel.fromApi(json))
          .toList();

      fetched.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final currentIds = notifications.map((n) => n.id).toSet();
      final newNotifs = fetched.where((n) => !currentIds.contains(n.id)).toList();

      if (newNotifs.isNotEmpty) {
        final currentReadIds = notifications
            .where((n) => n.isRead)
            .map((n) => n.id)
            .toSet();

        final merged = [
          ...newNotifs,
          ...notifications,
        ].map((n) {
          return currentReadIds.contains(n.id) ? n.copyWith(isRead: true) : n;
        }).toList();

        notifications.assignAll(merged);
        _pushNewToSystemTray(newNotifs);
      }
    } catch (_) {
      // abaikan
    }
  }

  // Kirim notif yang belum pernah di-push ke system
  void _pushNewToSystemTray(List<NotificationModel> notifList) {
    final unread = notifList.where((n) => !n.isRead && !_pushedIds.contains(n.id)).toList();
    for (final notif in unread) {
      NotificationService.showNotification(
        id: notif.id.hashCode.abs(),
        title: notif.title,
        body: notif.message,
      );
      _pushedIds.add(notif.id);
    }
  }

  // Tandai notif sebagai sudah dibaca
  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
    try {
      await _api.put('/notification/read/$id');
    } catch (_) {
      // Biarkan tetap isRead=true
    }
  }

  Future<void> markAllAsRead() async {
    for (var i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }

    final unread = notifications.toList();
    await Future.wait(
      unread.map((n) async {
        try {
          await _api.put('/notification/read/${n.id}');
        } catch (_) {}
      }),
    );
  }
}
