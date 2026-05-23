import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final user = authCtrl.currentUser.value;
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  bottom: 30,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColors.warmGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Profil Saya',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user?.username ?? 'Kolektor',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        user?.role ?? 'KOLEKTOR',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akun',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _menu(
                      Icons.edit_outlined,
                      'Edit Profil',
                      () => Get.toNamed(AppRoutes.editProfile),
                    ),
                    _menu(
                      Icons.phone_outlined,
                      'No. Telepon',
                      () {},
                      subtitle: user?.phone_number ?? '-',
                    ),
                    _menu(
                      Icons.person_outline,
                      'Username',
                      () {},
                      subtitle: user?.username ?? '-',
                    ),
                    const Divider(height: 30),
                    Text(
                      'Keuangan',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _menu(
                      Icons.account_balance_wallet_rounded,
                      'E-Wallet',
                      () => Get.toNamed(AppRoutes.wallet),
                      subtitle: 'Top Up & kelola saldo',
                    ),
                    const Divider(height: 30),
                    Text(
                      'Lainnya',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _menu(
                      Icons.info_outline,
                      'Tentang Aplikasi',
                      () => _showAbout(),
                    ),
                    _menu(
                      Icons.logout,
                      'Keluar',
                      () => _confirmLogout(authCtrl),
                    ),
                    _menu(
                      Icons.delete,
                      'Hapus Akun',
                      () => _confirmDeleteAccount(authCtrl),
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _menu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    String? subtitle,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withValues(alpha: 0.05)
              : AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                ],
              ),
            ),
            if (!isDestructive)
              const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showAbout() {
    Get.defaultDialog(
      title: 'Pasar Lelang Barang Seni',
      titleStyle: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
      middleText:
          'Aplikasi lelang karya seni online.\n\nTemukan, tawar, dan menangkan karya seni favoritmu dengan mudah.',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () => Get.back(),
    );
  }

  void _confirmLogout(AuthController ctrl) {
    Get.defaultDialog(
      title: 'Keluar',
      titleStyle: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
      middleText: 'Apakah Anda yakin ingin keluar?',
      radius: 8,
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          elevation: 0,
          minimumSize: const Size(110, 42),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => Get.back(),
        child: Text(
          'Batal',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          minimumSize: const Size(110, 42),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => ctrl.logout(),
        child: Text(
          'Keluar',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAccount(AuthController ctrl) {
    Get.defaultDialog(
      title: 'Hapus Akun',
      titleStyle: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
      middleText: 'Apakah Anda yakin ingin menghapus akun?',
      radius: 8,
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          elevation: 0,
          minimumSize: const Size(110, 42),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => Get.back(),
        child: Text(
          'Batal',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          elevation: 0,
          minimumSize: const Size(110, 42),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () => ctrl.deleteAccount(),
        child: Text(
          'Hapus',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
