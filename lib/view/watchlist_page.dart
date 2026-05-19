import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../controllers/catalog_controller.dart';
import '../routes/app_routes.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final catCtrl = Get.find<CatalogController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Watchlist')),
      body: Obx(() {
        final items = catCtrl.watchlistItems;
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 72,
                  color: AppColors.textHint.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Watchlist Kosong',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Simpan karya seni favoritmu di sini',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final art = items[i];
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.artDetail, arguments: art.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        art.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 80,
                          height: 80,
                          color: AppColors.shimmer,
                          child: const Icon(
                            Icons.palette,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            art.nama_karya,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Katalog: ${art.katalog}',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Rp ${_fmt(art.min_bid_ammount.toDouble())}',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => catCtrl.toggleWatchlist(art.id),
                      icon: const Icon(
                        Icons.bookmark,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
