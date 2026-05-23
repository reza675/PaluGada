import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../theme/app_colors.dart';
import '../models/payment_model.dart';
import '../services/certificate_service.dart';

class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({super.key});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  bool _isGenerating = false;

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final PaymentModel pay = Get.arguments as PaymentModel;
    final artistDisplay =
        pay.artistName.isNotEmpty ? pay.artistName : 'Unknown Artist';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (pay.artworkImageUrl.isNotEmpty)
                    Image.network(
                      pay.artworkImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.palette,
                          size: 80,
                          color: AppColors.textHint,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.palette,
                        size: 80,
                        color: AppColors.textHint,
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 160,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.95),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'PAID',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pay.artworkTitle.isNotEmpty ? pay.artworkTitle : 'Karya Seni',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.palette_outlined,
                        size: 16,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'oleh $artistDisplay',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: AppColors.warmGradient,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Rincian Pembayaran',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _detailRow(
                                'ID Pembayaran',
                                '#${pay.id.length > 10 ? pay.id.substring(0, 10) : pay.id}',
                                icon: Icons.tag_rounded,
                              ),
                              const Divider(height: 24),
                              _detailRow(
                                'Tanggal',
                                DateFormat('dd MMMM yyyy, HH:mm', 'id')
                                    .format(pay.timestamp),
                                icon: Icons.calendar_today_rounded,
                              ),
                              const Divider(height: 24),
                              _detailRow(
                                'Metode Pembayaran',
                                'E-Wallet',
                                icon: Icons.account_balance_wallet_rounded,
                              ),
                              const Divider(height: 24),
                              _detailRow(
                                'Harga Bid',
                                'Rp ${_fmt(pay.amount.toDouble())}',
                                icon: Icons.gavel_rounded,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: AppColors.warmGradient,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Bayar',
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${_fmt(pay.amount.toDouble())}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: AppColors.accentDark,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sertifikat Kepemilikan',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Unduh bukti kepemilikan karya seni Anda',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _isGenerating
                                ? null
                                : () => _downloadCertificate(pay),
                            icon: _isGenerating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.download_rounded,
                                    size: 20,
                                  ),
                            label: Text(
                              _isGenerating
                                  ? 'Membuat Sertifikat...'
                                  : 'Download Sertifikat PDF',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentDark,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  AppColors.accentDark.withValues(alpha: 0.5),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadCertificate(PaymentModel pay) async {
    setState(() => _isGenerating = true);
    try {
      final file = await CertificateService.generateAndDownload(
        artworkTitle:
            pay.artworkTitle.isNotEmpty ? pay.artworkTitle : 'Karya Seni',
        artistName: pay.artistName,
        bidAmount: pay.amount,
        paymentId: pay.id,
        paymentDate: pay.timestamp,
      );

      if (file == null) {
        Get.snackbar(
          'Gagal',
          'Tidak bisa membuat sertifikat',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      // "Save as PDF" 
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => await file.readAsBytes(),
        name: 'sertifikat_${pay.artworkTitle.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Error: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Widget _detailRow(
    String label,
    String value, {
    IconData? icon,
    bool isSubtle = false,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: isSubtle ? AppColors.textHint : AppColors.primary,
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: isSubtle ? 12 : 13,
              color: isSubtle ? AppColors.textHint : AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isSubtle ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: isSubtle ? AppColors.textHint : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
