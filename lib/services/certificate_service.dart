import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificateService {
  static Future<File?> generateAndDownload({
    required String artworkTitle,
    required String artistName,
    required int bidAmount,
    required String paymentId,
    required DateTime paymentDate,
  }) async {
    try {
      final pdf = pw.Document();

      final regularFont = await PdfGoogleFonts.outfitRegular();
      final boldFont = await PdfGoogleFonts.outfitBold();
      final titleFont = await PdfGoogleFonts.playfairDisplayBold();
      final cursiveFont = await PdfGoogleFonts.dancingScriptBold();

      final fmtAmount = _fmt(bidAmount.toDouble());
      final fmtDate = DateFormat('dd MMMM yyyy', 'id').format(paymentDate);
      final fmtId = paymentId.length > 12 ? paymentId.substring(0, 12) : paymentId;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          build: (context) => pw.Stack(
            children: [
              pw.Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.white,
                ),
              ),
              pw.Positioned(
                left: 20,
                top: 20,
                right: 20,
                bottom: 20,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: const PdfColor.fromInt(0xFF6D4C2E),
                      width: 3,
                    ),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                ),
              ),
              pw.Positioned(
                left: 26,
                top: 26,
                right: 26,
                bottom: 26,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: const PdfColor.fromInt(0xFFD4A853),
                      width: 1,
                    ),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: const PdfColor.fromInt(0xFF6D4C2E),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
                      ),
                      child: pw.Text(
                        'PALU GADA ART AUCTION',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 10,
                          color: PdfColors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 20),

                    pw.Text(
                      'SERTIFIKAT',
                      style: pw.TextStyle(
                        font: titleFont,
                        fontSize: 36,
                        color: const PdfColor.fromInt(0xFF6D4C2E),
                        letterSpacing: 4,
                      ),
                    ),
                    pw.Text(
                      'KEPEMILIKAN KARYA SENI',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 13,
                        color: const PdfColor.fromInt(0xFF8D6E63),
                        letterSpacing: 3,
                      ),
                    ),
                    pw.SizedBox(height: 8),

                    pw.Container(
                      width: 200,
                      height: 2,
                      color: const PdfColor.fromInt(0xFFD4A853),
                    ),
                    pw.SizedBox(height: 30),

                    pw.Text(
                      'Dengan bangga kami menyatakan bahwa',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: const PdfColor.fromInt(0xFF5D4037),
                      ),
                    ),
                    pw.SizedBox(height: 20),

                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(24),
                      decoration: pw.BoxDecoration(
                        color: const PdfColor.fromInt(0xFFFFF8E7),
                        border: pw.Border.all(
                          color: const PdfColor.fromInt(0xFFD4A853),
                          width: 1,
                        ),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _certRow('Nama Karya', artworkTitle, titleFont, regularFont, boldFont),
                          pw.SizedBox(height: 14),
                          _certRow('Nama Artist', artistName.isNotEmpty ? artistName : '-', titleFont, regularFont, boldFont),
                          pw.SizedBox(height: 14),
                          _certRow('Harga Bid Menang', 'Rp $fmtAmount', titleFont, regularFont, boldFont),
                          pw.SizedBox(height: 14),
                          _certRow('Tanggal Transaksi', fmtDate, titleFont, regularFont, boldFont),
                          pw.SizedBox(height: 14),
                          _certRow('ID Pembayaran', '#$fmtId', titleFont, regularFont, boldFont),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 30),

                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: pw.BoxDecoration(
                        color: const PdfColor.fromInt(0xFFF3E5D0),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'Selamat! Anda telah berhasil memenangkan lelang',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 12,
                              color: const PdfColor.fromInt(0xFF6D4C2E),
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            'dan resmi menjadi pemilik karya seni ini.\n'
                            'Terima kasih telah berpartisipasi dalam PaluGada Art Auction.',
                            style: pw.TextStyle(
                              font: regularFont,
                              fontSize: 10,
                              color: const PdfColor.fromInt(0xFF8D6E63),
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    pw.Spacer(),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              'Hormat Kami,',
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 11,
                                color: const PdfColor.fromInt(0xFF8D6E63),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Tim PaluGada',
                              style: pw.TextStyle(
                                font: cursiveFont,
                                fontSize: 28,
                                color: const PdfColor.fromInt(0xFF6D4C2E),
                              ),
                            ),
                            pw.Container(
                              width: 140,
                              height: 1,
                              color: const PdfColor.fromInt(0xFF8D6E63),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'PaluGada Art Auction',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 9,
                                color: const PdfColor.fromInt(0xFF8D6E63),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),

                    pw.Text(
                      'Dokumen ini diterbitkan secara digital oleh sistem PaluGada Art Auction',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 8,
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      // Simpan ke storage
      final dir = await getApplicationDocumentsDirectory();
      final safeTitle = artworkTitle
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .replaceAll(' ', '_')
          .toLowerCase();
      final file = File('${dir.path}/sertifikat_$safeTitle.pdf');
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      return null;
    }
  }

  static pw.Widget _certRow(
    String label,
    String value,
    pw.Font titleFont,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 140,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              font: regularFont,
              fontSize: 11,
              color: const PdfColor.fromInt(0xFF8D6E63),
            ),
          ),
        ),
        pw.Text(
          ': ',
          style: pw.TextStyle(
            font: regularFont,
            fontSize: 11,
            color: const PdfColor.fromInt(0xFF8D6E63),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 12,
              color: const PdfColor.fromInt(0xFF3E2723),
            ),
          ),
        ),
      ],
    );
  }

  static String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}
