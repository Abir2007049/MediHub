import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class AppointmentTicketScreen extends StatelessWidget {
  final Map<String, dynamic> appointmentData;

  const AppointmentTicketScreen({Key? key, required this.appointmentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime bookingTime = DateTime.parse(appointmentData['timestamp']);
    final String formattedDate = DateFormat('dd MMM yyyy').format(bookingTime);
    final String formattedTime = DateFormat('hh:mm a').format(bookingTime);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Appointment Ticket'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Ticket',
            onPressed: () => _sharePdf(context),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download PDF',
            onPressed: () => _downloadPdf(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Ticket Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.local_hospital, color: Colors.white, size: 50),
                        const SizedBox(height: 12),
                        const Text(
                          'MediHub',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'APPOINTMENT CONFIRMATION',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Badge - Serial Number
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.confirmation_number, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Serial #${appointmentData['serialNumber']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Patient & Doctor Info
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      children: [
                        // Patient Info
                        _buildSectionTitle('Patient Information', Icons.person),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.account_circle,
                          label: 'Name',
                          value: appointmentData['patientName'] ?? 'N/A',
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          icon: Icons.phone,
                          label: 'Mobile',
                          value: appointmentData['patientMobile'] ?? 'N/A',
                          color: Colors.blue,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Doctor Info
                        _buildSectionTitle('Doctor Information', Icons.local_hospital),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.medical_services,
                          label: 'Doctor',
                          value: appointmentData['doctorName'] ?? 'N/A',
                          color: Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          icon: Icons.school,
                          label: 'Specialization',
                          value: appointmentData['specialization'] ?? 'N/A',
                          color: Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: appointmentData['location'] ?? 'N/A',
                          color: Colors.green,
                        ),

                        const SizedBox(height: 24),

                        // Appointment Details
                        _buildSectionTitle('Appointment Details', Icons.calendar_today),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.event,
                          label: 'Day',
                          value: appointmentData['selectedDay'] ?? 'N/A',
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          icon: Icons.access_time,
                          label: 'Approximate Time',
                          value: appointmentData['approximateTime'] ?? 'N/A',
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          icon: Icons.attach_money,
                          label: 'Consultation Fee',
                          value: '৳${appointmentData['consultationFee']}',
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoCard(
                          icon: Icons.payment,
                          label: 'Payment Method',
                          value: appointmentData['paymentMethod'] ?? 'N/A',
                          color: Colors.purple,
                        ),

                        const SizedBox(height: 24),

                        // Status & Booking Time
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200, width: 2),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade600, size: 30),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CONFIRMED',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Booked on: $formattedDate at $formattedTime',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
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

                  // Dashed Separator
                  CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DashedLinePainter(),
                  ),

                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                        const SizedBox(height: 8),
                        Text(
                          'Please arrive 15 minutes before your appointment time',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Keep this ticket for reference',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _sharePdf(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadPdf(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade600, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final pdf = await _generatePdf();
      final bytes = await pdf.save();

      // Determine save directory: prefer Downloads, fallback to app documents
      Directory? dir;
      try {
        if (Platform.isAndroid) {
          dir = await getDownloadsDirectory();
        }
      } catch (_) {}
      dir ??= await getApplicationDocumentsDirectory();

      final filename =
          'MediHub_Ticket_${appointmentData['serialNumber']}.pdf';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved: $filename'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Share',
              textColor: Colors.white,
              onPressed: () => Printing.sharePdf(
                bytes: bytes,
                filename: filename,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final pdf = await _generatePdf();
      
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'MediHub_Appointment_${appointmentData['serialNumber']}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();
    final DateTime bookingTime = DateTime.parse(appointmentData['timestamp']);
    final String formattedDate = DateFormat('dd MMM yyyy').format(bookingTime);
    final String formattedTime = DateFormat('hh:mm a').format(bookingTime);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.green,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'MediHub',
                          style: pw.TextStyle(
                            fontSize: 32,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Appointment Confirmation',
                          style: const pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.white,
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.orange,
                        borderRadius: pw.BorderRadius.circular(20),
                      ),
                      child: pw.Text(
                        'Serial #${appointmentData['serialNumber']}',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Patient Information
              _buildPdfSection('Patient Information', [
                _buildPdfRow('Name', appointmentData['patientName'] ?? 'N/A'),
                _buildPdfRow('Mobile', appointmentData['patientMobile'] ?? 'N/A'),
              ]),

              pw.SizedBox(height: 20),

              // Doctor Information
              _buildPdfSection('Doctor Information', [
                _buildPdfRow('Doctor', appointmentData['doctorName'] ?? 'N/A'),
                _buildPdfRow('Specialization', appointmentData['specialization'] ?? 'N/A'),
                _buildPdfRow('Location', appointmentData['location'] ?? 'N/A'),
              ]),

              pw.SizedBox(height: 20),

              // Appointment Details
              _buildPdfSection('Appointment Details', [
                _buildPdfRow('Day', appointmentData['selectedDay'] ?? 'N/A'),
                _buildPdfRow('Approximate Time', appointmentData['approximateTime'] ?? 'N/A'),
                _buildPdfRow('Consultation Fee', '৳${appointmentData['consultationFee']}'),
                _buildPdfRow('Payment Method', appointmentData['paymentMethod'] ?? 'N/A'),
              ]),

              pw.SizedBox(height: 30),

              // Status
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.green100,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.green, width: 2),
                ),
                child: pw.Row(
                  children: [
                    pw.Text(
                      '✓ CONFIRMED',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green900,
                      ),
                    ),
                    pw.Spacer(),
                    pw.Text(
                      'Booked on: $formattedDate at $formattedTime',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 10),
              pw.Text(
                'Please arrive 15 minutes before your appointment time.',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey700,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Generated by MediHub - Your Healthcare Partner',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildPdfSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(children: children),
        ),
      ],
    );
  }

  pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Text(
            ': ',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
