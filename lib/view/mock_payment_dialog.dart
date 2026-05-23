import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../controllers/payment_controller.dart';
import '../controllers/wallet_controller.dart';

class MockPaymentDialog extends StatefulWidget {
  final String bidId;
  final int bidAmount;
  final String artworkTitle;

  const MockPaymentDialog({
    super.key,
    required this.bidId,
    required this.bidAmount,
    this.artworkTitle = 'Karya Seni',
  });

  static void show({
    required String bidId,
    required int bidAmount,
    String artworkTitle = 'Karya Seni',
  }) {
    Get.bottomSheet(
      MockPaymentDialog(
        bidId: bidId,
        bidAmount: bidAmount,
        artworkTitle: artworkTitle,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<MockPaymentDialog> createState() => _MockPaymentDialogState();
}

class _MockPaymentDialogState extends State<MockPaymentDialog> {
  int _selectedMethod = 0;

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final payCtrl = Get.find<PaymentController>();
    final walletCtrl = Get.find<WalletController>();
    final fee = widget.bidAmount * 0.035;
    final total = widget.bidAmount + fee;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
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

            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: AppColors.warmGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.payment_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Konfirmasi Pembayaran',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.artworkTitle,
              style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.divider.withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                children: [
                  _billRow('Harga Bid', 'Rp ${_fmt(widget.bidAmount.toDouble())}'),
                  const SizedBox(height: 12),
                  _billRow('Fee Admin (3.5%)', 'Rp ${_fmt(fee)}'),
                  const SizedBox(height: 12),
                  Container(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),
                  _billRow('Total Bayar', 'Rp ${_fmt(total)}', isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metode Pembayaran',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _methodTile(
                    index: 0,
                    icon: Icons.account_balance_rounded,
                    iconColor: AppColors.accentDark,
                    label: 'Bank Transfer',
                    subtitle: 'Simulasi transfer instan',
                  ),
                  const SizedBox(height: 8),
                  Obx(() => _methodTile(
                        index: 1,
                        icon: Icons.account_balance_wallet_rounded,
                        iconColor: AppColors.primary,
                        label: 'E-Wallet',
                        subtitle:
                            'Saldo: Rp ${_fmt(walletCtrl.balance.value)}',
                        trailing: walletCtrl.balance.value < total
                            ? _insufficientBadge()
                            : _sufficientBadge(),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (payCtrl.isCreating.value ||
                            walletCtrl.isProcessing.value)
                        ? null
                        : () => _handlePayment(payCtrl, walletCtrl, total),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: (payCtrl.isCreating.value ||
                            walletCtrl.isProcessing.value)
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Bayar Sekarang',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Batal',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: AppColors.textHint,
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment(
    PaymentController payCtrl,
    WalletController walletCtrl,
    double total,
  ) async {
    // Tutup dialog langsung agar tidak bisa di-klik 2x
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }

    await payCtrl.createPayment(widget.bidId, total.round());
  }

  Widget _methodTile({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    Widget? trailing,
  }) {
    final isSelected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.divider.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _insufficientBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Kurang',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.warning,
          ),
        ),
      );

  Widget _sufficientBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Cukup',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
      );

  Widget _billRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
