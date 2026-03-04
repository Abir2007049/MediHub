import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientPrescriptionScreen extends StatefulWidget {
  final Map<String, dynamic> prescription;
  final Map<String, dynamic> appointment;

  const PatientPrescriptionScreen({
    Key? key,
    required this.prescription,
    required this.appointment,
  }) : super(key: key);

  @override
  State<PatientPrescriptionScreen> createState() => _PatientPrescriptionScreenState();
}

class _PatientPrescriptionScreenState extends State<PatientPrescriptionScreen> {
  bool _followUpBooked = false;

  @override
  void initState() {
    super.initState();
    _loadFollowUpStatus();
  }

  Future<void> _loadFollowUpStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = widget.appointment['timestamp'] ?? '';
    final key = 'followup_booked_$timestamp';
    setState(() {
      _followUpBooked = prefs.getBool(key) ?? false;
    });
  }

  Future<void> _bookFollowUp(String paymentMethod) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = widget.appointment['timestamp'] ?? '';
    final key = 'followup_booked_$timestamp';
    await prefs.setBool(key, true);
    
    setState(() {
      _followUpBooked = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Follow-up appointment booked! Payment: $paymentMethod'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showFollowUpSheet(BuildContext context) {
    final fee = widget.prescription['followUpFee'] ?? 0;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payment, color: Colors.green.shade600),
                const SizedBox(width: 12),
const Text(
                  'Select Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Follow-up Fee: ৳$fee',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
            const Divider(height: 24),
            _paymentOption(ctx, 'Bkash', Icons.phone_android, Colors.pink),
            _paymentOption(ctx, 'Nagad', Icons.phone_android, Colors.orange),
            _paymentOption(ctx, 'Rocket', Icons.phone_android, Colors.purple),
            _paymentOption(ctx, 'Cash', Icons.money, Colors.green),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(
      BuildContext ctx, String method, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(ctx);
        _bookFollowUp(method);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(method,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }


  // ── PDF generation ─────────────────────────────────────────────────────────
  Future<pw.Document> _buildPdf() async {
    final pdf = pw.Document();
    final medicines = (widget.prescription['medicines'] as List? ?? [])
        .map((e) => Map<String, String>.from(e))
        .toList();
    final tests = List<String>.from(widget.prescription['tests'] ?? []);
    final notes = widget.prescription['notes'] ?? '';
    final hasFollowUp = widget.prescription['hasFollowUp'] == true;
    final dateStr = DateFormat('dd MMM yyyy').format(DateTime.parse(widget.appointment['timestamp']));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (ctx) => [
          // ── Header ──────────────────────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: PdfColors.green700,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('MediHub',
                        style: pw.TextStyle(
                            fontSize: 26,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.SizedBox(height: 4),
                    pw.Text('Medical Prescription',
                        style: const pw.TextStyle(
                            fontSize: 12, color: PdfColors.white)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Date: $dateStr',
                        style: const pw.TextStyle(
                            fontSize: 11, color: PdfColors.white)),
                    pw.SizedBox(height: 4),
                    pw.Text('Serial #${widget.appointment['serialNumber']}',
                        style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 18),

          // ── Doctor / Patient info ────────────────────────────────────
          pw.Row(
            children: [
              pw.Expanded(
                child: _pdfInfoBox('Doctor', [
                  widget.prescription['doctorName'] ?? widget.appointment['doctorName'] ?? 'N/A',
                  widget.appointment['specialization'] ?? '',
                ]),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _pdfInfoBox('Patient', [
                  widget.prescription['patientName'] ?? widget.appointment['patientName'] ?? 'N/A',
                  widget.appointment['patientMobile'] ?? '',
                ]),
              ),
            ],
          ),

          pw.SizedBox(height: 18),

          // ── Medicines ───────────────────────────────────────────────
          if (medicines.isNotEmpty) ...[
            _pdfSectionHeader('Medicines'),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(0.5),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(2.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.green50),
                  children: ['#', 'Medicine', 'Dose', 'Timing']
                      .map((h) => pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: pw.Text(h,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 11,
                                    color: PdfColors.green900)),
                          ))
                      .toList(),
                ),
                ...medicines.asMap().entries.map((e) => pw.TableRow(
                      children: [
                        '${e.key + 1}',
                        e.value['name'] ?? '',
                        e.value['dose'] ?? '',
                        e.value['timing'] ?? '',
                      ]
                          .map((cell) => pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                child: pw.Text(cell,
                                    style: const pw.TextStyle(fontSize: 11)),
                              ))
                          .toList(),
                    )),
              ],
            ),
            pw.SizedBox(height: 16),
          ],

          // ── Tests ───────────────────────────────────────────────────
          if (tests.isNotEmpty) ...[
            _pdfSectionHeader('Investigations / Tests'),
            pw.SizedBox(height: 8),
            ...tests.asMap().entries.map((e) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(children: [
                    pw.Text('${e.key + 1}.  ',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text(e.value,
                        style: const pw.TextStyle(fontSize: 11)),
                  ]),
                )),
            pw.SizedBox(height: 16),
          ],

          // ── Notes ───────────────────────────────────────────────────
          if (notes.isNotEmpty) ...[
            _pdfSectionHeader('Doctor\'s Notes'),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Text(notes,
                  style: const pw.TextStyle(fontSize: 11)),
            ),
            pw.SizedBox(height: 16),
          ],

          // ── Follow-up ───────────────────────────────────────────────
          if (hasFollowUp) ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.green700, width: 1),
              ),
              child: pw.Row(
                children: [
                  pw.Text('Follow-up recommended: ',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                          color: PdfColors.green900)),
                  pw.Text(
                      'In ${widget.prescription['followUpDate'] ?? ""}  •  '
                      'Fee ৳${widget.prescription['followUpFee'] ?? ""}',
                      style: pw.TextStyle(
                          fontSize: 11, color: PdfColors.green900)),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
          ],

          // ── Footer ──────────────────────────────────────────────────
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 6),
          pw.Text(
            'This prescription was issued via MediHub. Always consult your doctor before making any medication changes.',
            style: pw.TextStyle(
                fontSize: 9,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey600),
          ),
        ],
      ),
    );
    return pdf;
  }

  pw.Widget _pdfInfoBox(String title, List<String> lines) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: PdfColors.green800)),
          pw.SizedBox(height: 4),
          ...lines.where((l) => l.isNotEmpty).map(
                (l) => pw.Text(l,
                    style: const pw.TextStyle(fontSize: 11)),
              ),
        ],
      ),
    );
  }

  pw.Widget _pdfSectionHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.green700,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(text,
          style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 12)),
    );
  }

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final pdf = await _buildPdf();
      final bytes = await pdf.save();

      Directory? dir;
      try {
        if (Platform.isAndroid) dir = await getDownloadsDirectory();
      } catch (_) {}
      dir ??= await getApplicationDocumentsDirectory();

      final filename =
          'MediHub_Prescription_${widget.appointment['serialNumber']}_${(widget.prescription['doctorName'] ?? 'Doctor').toString().replaceAll(' ', '_')}.pdf';
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
              onPressed: () =>
                  Printing.sharePdf(bytes: bytes, filename: filename),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    final pdf = await _buildPdf();
    final bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          'MediHub_Prescription_${widget.appointment['serialNumber']}.pdf',
    );
  }

  // ── UI ──────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final medicines = (widget.prescription['medicines'] as List? ?? [])
        .map((e) => Map<String, String>.from(e))
        .toList();
    final tests = List<String>.from(widget.prescription['tests'] ?? []);
    final notes = (widget.prescription['notes'] ?? '').toString();
    final hasFollowUp = widget.prescription['hasFollowUp'] == true;
    final dateStr = DateFormat('dd MMM yyyy')
        .format(DateTime.parse(widget.appointment['timestamp']));
    final doctorName =
        widget.prescription['doctorName'] ?? widget.appointment['doctorName'] ?? 'Doctor';
    final specialization = widget.appointment['specialization'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Prescription'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade500, Colors.green.shade700],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_hospital,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      const Text('MediHub',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('#${widget.appointment['serialNumber']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Medical Prescription',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(dateStr,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Doctor & Patient info ────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _infoCard(
                    icon: Icons.medical_services,
                    title: 'Doctor',
                    lines: [doctorName, specialization],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _infoCard(
                    icon: Icons.person,
                    title: 'Patient',
                    lines: [
                      widget.prescription['patientName'] ??
                          widget.appointment['patientName'] ??
                          'N/A',
                      widget.appointment['patientMobile'] ?? '',
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Medicines ────────────────────────────────────────────
            if (medicines.isNotEmpty) ...[
              _sectionHeader('Medicines', Icons.medication),
              const SizedBox(height: 10),
              ...medicines.asMap().entries.map((entry) {
                final i = entry.key;
                final m = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade100),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6)
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: Text('${i + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['name'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(
                              '${m['dose'] ?? ''}  •  ${m['timing'] ?? ''}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],

            // ── Tests ────────────────────────────────────────────────
            if (tests.isNotEmpty) ...[
              _sectionHeader('Investigations / Tests', Icons.biotech),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tests
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.green.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  size: 14,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(t,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade800,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ── Doctor's Notes ───────────────────────────────────────
            if (notes.isNotEmpty) ...[
              _sectionHeader('Doctor\'s Notes', Icons.note_alt),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Text(notes,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        height: 1.5)),
              ),
              const SizedBox(height: 16),
            ],

            // ── Follow-up ────────────────────────────────────────────
            if (hasFollowUp) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _followUpBooked
                      ? Colors.grey.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _followUpBooked
                          ? Colors.grey.shade300
                          : Colors.green.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event_repeat,
                            color: _followUpBooked
                                ? Colors.grey
                                : Colors.green.shade700,
                            size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _followUpBooked
                                    ? 'Follow-up Already Booked'
                                    : 'Follow-up Recommended',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _followUpBooked
                                        ? Colors.grey.shade700
                                        : Colors.green.shade800,
                                    fontSize: 13),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'In ${widget.prescription['followUpDate'] ?? ""}  •  Fee ৳${widget.prescription['followUpFee'] ?? ""}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _followUpBooked
                                        ? Colors.grey.shade500
                                        : Colors.green.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!_followUpBooked) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showFollowUpSheet(context),
                          icon: const Icon(Icons.event_available, size: 18),
                          label: const Text('Book Follow-up Appointment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Download / Share buttons ─────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _sharePdf(context),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade400),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadPdf(context),
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800)),
      ],
    );
  }

  Widget _infoCard(
      {required IconData icon,
      required String title,
      required List<String> lines}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green.shade600, size: 14),
              const SizedBox(width: 5),
              Text(title,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ...lines.where((l) => l.isNotEmpty).map(
                (l) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(l,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
        ],
      ),
    );
  }
}
