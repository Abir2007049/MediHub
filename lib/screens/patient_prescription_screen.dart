import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../blocs/prescription/prescription_cubit.dart';
import '../models/appointment.dart';
import '../models/prescription.dart';

class PatientPrescriptionScreen extends StatefulWidget {
  final Prescription prescription;
  final Appointment appointment;

  const PatientPrescriptionScreen({
    super.key,
    required this.prescription,
    required this.appointment,
  });

  @override
  State<PatientPrescriptionScreen> createState() =>
      _PatientPrescriptionScreenState();
}

class _PatientPrescriptionScreenState extends State<PatientPrescriptionScreen> {
  late Prescription _prescription;

  @override
  void initState() {
    super.initState();
    _prescription = widget.prescription;
  }

  Future<void> _bookFollowUp() async {
    if (_prescription.id == null) return;

    await context.read<PrescriptionCubit>().markFollowUpBooked(
      _prescription.id!,
    );

    setState(() {
      _prescription = _prescription.copyWith(followUpBooked: true);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Follow-up booked!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _downloadPdf() async {
    final doc = pw.Document();
    final p = _prescription;
    final a = widget.appointment;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.green, width: 2),
              ),
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
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green800,
                      ),
                    ),
                    pw.Text(
                      'Medical Prescription',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      'Serial: #${a.serialNumber}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Doctor & Patient info
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Doctor',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green800,
                      ),
                    ),
                    pw.Text(p.doctorName ?? a.doctorName ?? 'N/A'),
                    pw.Text(p.doctorSpecialization ?? a.specialization ?? ''),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Patient',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green800,
                      ),
                    ),
                    pw.Text(p.patientName ?? a.patientName ?? 'N/A'),
                    pw.Text(p.patientMobile ?? a.patientMobile ?? ''),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Medicines
          if (p.medicines.isNotEmpty) ...[
            pw.Text(
              'Medicines',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              headers: ['#', 'Medicine', 'Dose', 'Timing'],
              data: p.medicines.asMap().entries.map((e) {
                final m = e.value;
                return ['${e.key + 1}', m.name, m.dose, m.timing];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.green50,
              ),
              border: pw.TableBorder.all(color: PdfColors.grey300),
              cellPadding: const pw.EdgeInsets.all(6),
            ),
            pw.SizedBox(height: 16),
          ],

          // Tests
          if (p.tests.isNotEmpty) ...[
            pw.Text(
              'Diagnostic Tests',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
            pw.SizedBox(height: 8),
            ...p.tests.map(
              (t) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  children: [
                    pw.Text(
                      '• ',
                      style: const pw.TextStyle(color: PdfColors.green800),
                    ),
                    pw.Text(t),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 16),
          ],

          // Notes
          if (p.notes != null && p.notes!.isNotEmpty) ...[
            pw.Text(
              'Notes',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(p.notes!),
            pw.SizedBox(height: 16),
          ],

          // Follow-up
          if (p.hasFollowUp) ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.orange),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Follow-up',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.orange800,
                    ),
                  ),
                  if (p.followUpDate != null)
                    pw.Text('Date: ${p.followUpDate}'),
                  if (p.followUpFee != null) pw.Text('Fee: ৳${p.followUpFee}'),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => doc.save(),
      name: 'Prescription_${a.patientName ?? "patient"}_${a.selectedDay}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _prescription;
    final a = widget.appointment;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Prescription'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: Colors.green.shade700),
            tooltip: 'Download PDF',
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade800],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.medical_services,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.doctorName ?? a.doctorName ?? 'Doctor',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            p.doctorSpecialization ?? a.specialization ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          a.selectedDay,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Serial #${a.serialNumber}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Patient info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.person, color: Colors.blue.shade700),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.patientName ?? a.patientName ?? 'Patient',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (p.patientMobile != null ||
                              a.patientMobile != null)
                            Text(
                              p.patientMobile ?? a.patientMobile ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Medicines
              if (p.medicines.isNotEmpty) ...[
                _sectionTitle('Medicines'),
                ...p.medicines.map(
                  (m) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.medication,
                            size: 20,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (m.dose.isNotEmpty || m.timing.isNotEmpty)
                                Text(
                                  '${m.dose}  ${m.timing}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Tests
              if (p.tests.isNotEmpty) ...[
                _sectionTitle('Diagnostic Tests'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: p.tests
                      .map(
                        (t) => Chip(
                          label: Text(t),
                          backgroundColor: Colors.blue.shade50,
                          side: BorderSide(color: Colors.blue.shade200),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Notes
              if (p.notes != null && p.notes!.isNotEmpty) ...[
                _sectionTitle('Notes'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    p.notes!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Follow-up
              if (p.hasFollowUp) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.event_repeat,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Follow-up Required',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                      if (p.followUpDate != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Date: ${p.followUpDate}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                      if (p.followUpFee != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Fee: ৳${p.followUpFee}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (!p.followUpBooked)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _bookFollowUp,
                            icon: const Icon(Icons.calendar_today, size: 18),
                            label: const Text('Book Follow-up'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Follow-up Booked',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              // Download button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _downloadPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text(
                    'Download as PDF',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green.shade700,
                    side: BorderSide(color: Colors.green.shade600, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}
