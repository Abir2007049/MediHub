import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:medihub/features/prescription/presentation/cubit/prescription_cubit.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/models/prescription.dart';
import 'package:medihub/features/prescription/presentation/widgets/prescription_header.dart';
import 'package:medihub/features/prescription/presentation/widgets/patient_info_card.dart';
import 'package:medihub/features/prescription/presentation/widgets/medicines_list.dart';
import 'package:medihub/features/prescription/presentation/widgets/diagnostic_tests_list.dart';
import 'package:medihub/features/prescription/presentation/widgets/prescription_notes.dart';
import 'package:medihub/features/prescription/presentation/widgets/follow_up_section.dart';

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
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _primary => _colors.primary;

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
      fallbackPrescription: _prescription,
    );

    setState(() {
      _prescription = _prescription.copyWith(followUpBooked: true);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Follow-up booked!'), backgroundColor: _primary),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Prescription'),
        backgroundColor: _colors.surface,
        foregroundColor: _primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: _primary),
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
              PrescriptionHeader(prescription: p, appointment: a),
              const SizedBox(height: 20),
              PatientInfoCard(prescription: p, appointment: a),
              const SizedBox(height: 20),
              MedicinesList(medicines: p.medicines),
              DiagnosticTestsList(tests: p.tests),
              PrescriptionNotes(notes: p.notes),
              FollowUpSection(prescription: p, onBookFollowUp: _bookFollowUp),
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
                    foregroundColor: _primary,
                    side: BorderSide(
                      color: _primary.withOpacity(0.5),
                      width: 1,
                    ),
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
}
