import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../controllers/bidding_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/payment_controller.dart';
import '../controllers/catalog_controller.dart';
import '../models/bid_model.dart';
import '../models/artwork_model.dart';


class BiddingPage extends StatelessWidget {
  const BiddingPage({super.key});

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  Widget _buildStatusBadge({
    required BidModel bid,
    required ArtworkModel? artwork,
    required bool isHighest,
    required PaymentController payCtrl,
    required String? currentUserId,
  }) {
    if (artwork == null) {
      return _badgeWidget(text: 'OPEN', color: AppColors.success);
    }

    final isClosed = artwork.isBiddingClosed;

    if (isClosed) {
      if (isHighest) {
        final hasPaid = payCtrl.payments.any((p) => p.bidId == bid.id);
        if (hasPaid) {
          return _badgeWidget(text: 'DIBAYAR', color: AppColors.success);
        } else {
          if (bid.bidById == currentUserId) {
            return _badgeWidget(text: 'MENANG (BELUM DIBAYAR)', color: Colors.blue);
          } else {
            return _badgeWidget(text: 'MENANG', color: AppColors.accentDark);
          }
        }
      } else {
        return _badgeWidget(text: 'KALAH (OUTBID)', color: Colors.grey);
      }
    } else {
      if (isHighest) {
        return _badgeWidget(text: 'TERTINGGI', color: Colors.amber.shade800);
      } else {
        return _badgeWidget(text: 'OUTBID', color: Colors.grey);
      }
    }
  }

  Widget _badgeWidget({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bidCtrl = Get.find<BiddingController>();
    final authCtrl = Get.find<AuthController>();
    final payCtrl = Get.find<PaymentController>();
    final catalogCtrl = Get.find<CatalogController>();

    final currentUserId = authCtrl.currentUser.value?.id;
    final currentUserName = authCtrl.currentUser.value?.username ?? 'Anda';
    final artwork = catalogCtrl.getArtworkById(bidCtrl.currentArtworkId.value);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Bidding'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (bidCtrl.isLoading.value)
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _stat('Tertinggi', 'Rp ${_fmt(bidCtrl.highestBid)}'),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _stat('Terendah', 'Rp ${_fmt(bidCtrl.lowestBid)}'),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _stat('Total', '${bidCtrl.bids.length} bid'),
                ],
              ),
            ),

            if (bidCtrl.lastBid != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.accentDark,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bidder Terakhir',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                bidCtrl.lastBid!.bidById == currentUserId
                                    ? '$currentUserName (Anda)'
                                    : (bidCtrl.lastBid!.bidderName.length > 20
                                        ? 'User (${bidCtrl.lastBid!.bidderName.substring(0, 6)})'
                                        : bidCtrl.lastBid!.bidderName),
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusBadge(
                                bid: bidCtrl.lastBid!,
                                artwork: artwork,
                                isHighest: true,
                                payCtrl: payCtrl,
                                currentUserId: currentUserId,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${_fmt(bidCtrl.lastBid!.amount.toDouble())}',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Semua Bid',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bidCtrl.bids.length,
                itemBuilder: (_, i) {
                  final bid = bidCtrl.bids[i];
                  final isFirst = i == 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isFirst
                          ? AppColors.primary.withValues(alpha: 0.06)
                          : AppColors.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: isFirst
                          ? Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isFirst
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                color: isFirst
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    bid.bidById == currentUserId
                                        ? '$currentUserName (Anda)'
                                        : (bid.bidderName.length > 20
                                            ? 'User (${bid.bidderName.substring(0, 6)})'
                                            : bid.bidderName),
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildStatusBadge(
                                    bid: bid,
                                    artwork: artwork,
                                    isHighest: isFirst,
                                    payCtrl: payCtrl,
                                    currentUserId: currentUserId,
                                  ),
                                ],
                              ),
                              Text(
                                DateFormat(
                                  'dd MMM yyyy, HH:mm',
                                ).format(bid.timestamp),
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Rp ${_fmt(bid.amount.toDouble())}',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isFirst
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _stat(String label, String value) => Expanded(
    child: Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
