import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificatePdfGenerator {
  static Future<Uint8List> generateCertificatePdf({
    required String studentName,
    required String courseTitle,
    required String issueDate,
    required String credentialCode,
  }) async {
    final pdf = pw.Document();

    final goldColor = PdfColor.fromHex('#D4AF37');
    final cardBg = PdfColor.fromHex('#1A1D1D');
    final textMuted = PdfColor.fromHex('#94A3B8');
    final primaryGold = PdfColor.fromHex('#F59E0B');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Container(
            width: double.infinity,
            height: double.infinity,
            padding: const pw.EdgeInsets.all(28),
            decoration: pw.BoxDecoration(
              color: cardBg,
              borderRadius: pw.BorderRadius.circular(16),
              border: pw.Border.all(color: goldColor, width: 3),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // Top Header Badge
                pw.Column(
                  children: [
                    pw.Text(
                      'EDUFLOW CERTIFIED ACADEMY',
                      style: pw.TextStyle(
                        color: primaryGold,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2.5,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'CERTIFICATE OF COMPLETION',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                // Center Recipient
                pw.Column(
                  children: [
                    pw.Text(
                      'This certificate is proudly awarded to',
                      style: pw.TextStyle(
                        color: textMuted,
                        fontSize: 13,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      studentName,
                      style: pw.TextStyle(
                        color: primaryGold,
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      width: 320,
                      height: 1.5,
                      color: goldColor,
                    ),
                    pw.SizedBox(height: 14),
                    pw.Text(
                      'for successfully achieving 100% mastery and completing all coursework in',
                      style: pw.TextStyle(
                        color: textMuted,
                        fontSize: 12,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      courseTitle,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Bottom Footer (Issue Date & Credential Verification)
                pw.Container(
                  padding: const pw.EdgeInsets.only(top: 14),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.grey700, width: 0.8),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'ISSUE DATE',
                            style: pw.TextStyle(
                              color: textMuted,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            issueDate,
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            'OFFICIALLY VERIFIED',
                            style: pw.TextStyle(
                              color: primaryGold,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            'EduFlow Online Learning Platform',
                            style: pw.TextStyle(
                              color: textMuted,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'CREDENTIAL ID',
                            style: pw.TextStyle(
                              color: textMuted,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            credentialCode,
                            style: pw.TextStyle(
                              color: primaryGold,
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> downloadOrPrintCertificate({
    required String studentName,
    required String courseTitle,
    required String issueDate,
    required String credentialCode,
  }) async {
    final pdfBytes = await generateCertificatePdf(
      studentName: studentName,
      courseTitle: courseTitle,
      issueDate: issueDate,
      credentialCode: credentialCode,
    );

    await Printing.layoutPdf(
      name: 'EduFlow_Certificate_${credentialCode.replaceAll(' ', '_')}.pdf',
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}
