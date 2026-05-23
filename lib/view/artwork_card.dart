import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/artwork_model.dart';
import '../controllers/catalog_controller.dart';
import '../routes/app_routes.dart';

class ArtworkCard extends StatelessWidget {
  final ArtworkModel artwork;
  final bool isCompact;

  const ArtworkCard({super.key, required this.artwork, this.isCompact = false});

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  String _timeLeft(DateTime? end) {
    if (end == null) return '';
    final d = end.difference(DateTime.now());
    if (d.isNegative) return 'Berakhir';
    if (d.inDays > 0) return '${d.inDays}h ${d.inHours % 24}j';
    if (d.inHours > 0) return '${d.inHours}j ${d.inMinutes % 60}m';
    return '${d.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final catCtrl = Get.find<CatalogController>();
    return isCompact ? _compact(catCtrl) : _full(catCtrl);
  }

  Widget _compact(CatalogController catCtrl) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.artDetail, arguments: artwork.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.network(
                    artwork.imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 160,
                      color: AppColors.shimmer,
                      child: const Center(
                        child: Icon(
                          Icons.palette,
                          size: 40,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => catCtrl.toggleWatchlist(artwork.id),
                    child: Obx(() {
                      final a = catCtrl.artworks.firstWhere(
                        (x) => x.id == artwork.id,
                      );
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          a.isInWatchlist
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: a.isInWatchlist
                              ? AppColors.accentDark
                              : AppColors.textHint,
                          size: 18,
                        ),
                      );
                    }),
                  ),
                ),
                if (artwork.close_bid_time != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _timeLeft(artwork.close_bid_time),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artwork.nama_karya,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    artwork.artistName.isNotEmpty ? artwork.artistName : 'ID: ${artwork.artistId}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Rp ${_fmt(artwork.min_bid_ammount.toDouble())}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      if (artwork.totalBids > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.gavel,
                              size: 12,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${artwork.totalBids}',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _full(CatalogController catCtrl) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.artDetail, arguments: artwork.id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                  ),
                  child: Image.network(
                    artwork.imageUrl,
                    width: 130,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 130,
                      height: 140,
                      color: AppColors.shimmer,
                      child: const Icon(
                        Icons.palette,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
                if (artwork.verification_status == 'VERIFIED')
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'VERIFIED',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            artwork.katalog,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentDark,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => catCtrl.toggleWatchlist(artwork.id),
                          child: Obx(() {
                            final a = catCtrl.artworks.firstWhere(
                              (x) => x.id == artwork.id,
                            );
                            return Icon(
                              a.isInWatchlist
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: a.isInWatchlist
                                  ? AppColors.accentDark
                                  : AppColors.textHint,
                              size: 22,
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      artwork.nama_karya,
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
                      artwork.artistName.isNotEmpty ? artwork.artistName : 'ID: ${artwork.artistId}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${_fmt(artwork.min_bid_ammount.toDouble())}',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        if (artwork.totalBids > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.gavel,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${artwork.totalBids} bid',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
