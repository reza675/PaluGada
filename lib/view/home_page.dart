import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../controllers/home_controller.dart';
import '../controllers/catalog_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../routes/app_routes.dart';
import 'catalog_page.dart';
import 'watchlist_page.dart';
import 'payment_page.dart';
import 'profile_page.dart';
import 'artwork_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    Get.find<CatalogController>();
    Get.find<AuthController>();

    final pages = [
      _HomeDashboard(),
      const CatalogPage(),
      const WatchlistPage(),
      const PaymentPage(),
      const ProfilePage(),
    ];

    return Obx(
      () => Scaffold(
        body: pages[homeCtrl.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_rounded, 'Beranda', 0, homeCtrl),
                  _navItem(Icons.palette_outlined, 'Katalog', 1, homeCtrl),
                  _navItem(Icons.bookmark_outline, 'Watchlist', 2, homeCtrl),
                  _navItem(Icons.receipt_long_outlined, 'Riwayat', 3, homeCtrl),
                  _navItem(Icons.person_outline, 'Profil', 4, homeCtrl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int idx, HomeController ctrl) {
    return Obx(() {
      final active = ctrl.currentIndex.value == idx;
      return GestureDetector(
        onTap: () => ctrl.changeTab(idx),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: active ? 16 : 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: active ? AppColors.primary : AppColors.textHint,
                size: active ? 26 : 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: active ? AppColors.primary : AppColors.textHint,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final catCtrl = Get.find<CatalogController>();
    final homeCtrl = Get.find<HomeController>();
    final notifCtrl = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await catCtrl.loadArtworks();
        },
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 24,
                  right: 24,
                  bottom: 28,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColors.warmGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  'Halo, ${authCtrl.currentUser.value?.username != null && authCtrl.currentUser.value!.username.isNotEmpty ? authCtrl.currentUser.value!.username : 'Kolektor'} 👋',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Temukan Karya\nSeni Impianmu',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.notifications),
                          child: Obx(() => Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                if (notifCtrl.unreadCount > 0)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${notifCtrl.unreadCount}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => homeCtrl.changeTab(4),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => homeCtrl.changeTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Cari karya seni...',
                              style: GoogleFonts.outfit(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
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
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.palette,
                        label: 'Karya Seni',
                        value: '${catCtrl.artworks.length}',
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.gavel,
                        label: 'Verified',
                        value:
                            '${catCtrl.artworks.where((a) => a.verification_status == "VERIFIED").length}',
                        color: AppColors.accentDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.bookmark,
                        label: 'Watchlist',
                        value: '${catCtrl.watchlistItems.length}',
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Karya Unggulan',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: Obx(() {
                  final now = DateTime.now();

                  var featuredItems = catCtrl.artworks
                      .where(
                        (a) =>
                            a.verification_status == 'VERIFIED' &&
                            a.close_bid_time != null &&
                            a.close_bid_time!.isAfter(now),
                      )
                      .toList();

                  if (featuredItems.isEmpty) {
                    featuredItems = catCtrl.artworks
                        .where(
                          (a) =>
                              a.verification_status == 'VERIFIED' &&
                              a.close_bid_time != null &&
                              a.close_bid_time!.isBefore(now),
                        )
                        .toList();
                  }

                  featuredItems.sort(
                    (a, b) => b.totalBids.compareTo(a.totalBids),
                  );

                  final items = featuredItems.take(3).toList();

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada karya unggulan',
                        style: GoogleFonts.outfit(color: AppColors.textHint),
                      ),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: SizedBox(
                        width: 220,
                        child: ArtworkCard(artwork: items[i], isCompact: true),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Semua Karya
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Semua Karya Seni',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            Obx(() {
              final items = catCtrl.artworks.toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ArtworkCard(artwork: items[i]),
                  ),
                  childCount: items.length,
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
