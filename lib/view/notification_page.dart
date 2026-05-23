import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifCtrl = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            if (notifCtrl.unreadCount == 0) return const SizedBox.shrink();
            return TextButton.icon(
              onPressed: () => notifCtrl.markAllAsRead(),
              icon: const Icon(
                Icons.done_all_rounded,
                size: 18,
                color: AppColors.accent,
              ),
              label: Text(
                'Baca Semua',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (notifCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (notifCtrl.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.notifications_off_outlined,
                    size: 40,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada notifikasi',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Notifikasi Anda akan muncul di sini',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => notifCtrl.loadNotifications(),
          color: AppColors.primary,
          child: Column(
            children: [
              Obx(() {
                final unread = notifCtrl.unreadCount;
                if (unread == 0) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppColors.warmGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$unread notifikasi belum dibaca',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 4),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: notifCtrl.notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifCtrl.notifications[index];
                    return _NotificationTile(
                      notification: notif,
                      onTap: () {
                        if (!notif.isRead) {
                          notifCtrl.markAsRead(notif.id);
                        }
                        _showNotificationDetail(context, notif);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showNotificationDetail(
      BuildContext context, NotificationModel notif) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _getIconColor(notif.title).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getIcon(notif.title),
                    color: _getIconColor(notif.title),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    notif.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              notif.message,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatTimestamp(notif.timestamp),
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime ts) {
    final now = DateTime.now();
    final diff = now.difference(ts);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('dd MMM yyyy, HH:mm').format(ts);
  }

  IconData _getIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('terlampaui') || lower.contains('outbid')) {
      return Icons.trending_up_rounded;
    }
    if (lower.contains('pembayaran') || lower.contains('payment')) {
      return Icons.payment_rounded;
    }
    if (lower.contains('pemenang') || lower.contains('selamat')) {
      return Icons.emoji_events_rounded;
    }
    if (lower.contains('lelang') || lower.contains('baru')) {
      return Icons.new_releases_rounded;
    }
    return Icons.notifications_rounded;
  }

  Color _getIconColor(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('terlampaui') || lower.contains('outbid')) {
      return AppColors.warning;
    }
    if (lower.contains('pembayaran') || lower.contains('payment')) {
      return AppColors.success;
    }
    if (lower.contains('pemenang') || lower.contains('selamat')) {
      return AppColors.accentDark;
    }
    if (lower.contains('lelang') || lower.contains('baru')) {
      return AppColors.info;
    }
    return AppColors.primary;
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.surfaceVariant
              : AppColors.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: isUnread
              ? Border.all(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  width: 1.2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: isUnread ? 0.06 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getIconColor(notification.title).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getIcon(notification.title),
                color: _getIconColor(notification.title),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight:
                                isUnread ? FontWeight.w700 : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime ts) {
    final now = DateTime.now();
    final diff = now.difference(ts);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('dd MMM yyyy, HH:mm').format(ts);
  }

  IconData _getIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('terlampaui') || lower.contains('outbid')) {
      return Icons.trending_up_rounded;
    }
    if (lower.contains('pembayaran') || lower.contains('payment')) {
      return Icons.payment_rounded;
    }
    if (lower.contains('pemenang') || lower.contains('selamat')) {
      return Icons.emoji_events_rounded;
    }
    if (lower.contains('lelang') || lower.contains('baru')) {
      return Icons.new_releases_rounded;
    }
    return Icons.notifications_rounded;
  }

  Color _getIconColor(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('terlampaui') || lower.contains('outbid')) {
      return AppColors.warning;
    }
    if (lower.contains('pembayaran') || lower.contains('payment')) {
      return AppColors.success;
    }
    if (lower.contains('pemenang') || lower.contains('selamat')) {
      return AppColors.accentDark;
    }
    if (lower.contains('lelang') || lower.contains('baru')) {
      return AppColors.info;
    }
    return AppColors.primary;
  }
}
