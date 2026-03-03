import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'patient_prescription_screen.dart';

class PatientHistoryScreen extends StatefulWidget {
  final String patientMobile;
  const PatientHistoryScreen({Key? key, required this.patientMobile}) : super(key: key);

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'patient_history_${widget.patientMobile}';
    String? historyJson = prefs.getString(key);

    // Seed demo data for the demo patient account
    if (historyJson == null && widget.patientMobile == '01712345678') {
      await _seedDemoHistory(prefs, key);
      historyJson = prefs.getString(key);
    }

    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      setState(() {
        _appointments = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        _appointments.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seedDemoHistory(SharedPreferences prefs, String key) async {
    final now = DateTime.now();

    // Appointment 1: 7 days ago — chest specialist
    final ts1 = now.subtract(const Duration(days: 7)).toIso8601String();
    final appt1 = {
      'timestamp': ts1,
      'slotTime': ts1,
      'selectedDay': 'Saturday',
      'serialNumber': 4,
      'approximateTime': '4:40 PM',
      'consultationFee': 800,
      'paymentMethod': 'bKash',
      'patientMobile': '01712345678',
      'patientName': 'Demo Patient',
      'doctorName': 'Dr. Mahmud Hasan',
      'doctorEmail': 'demo.doctor@medihub.com',
      'specialization': 'Chest & Medicine',
      'location': 'Dhaka',
    };

    // Prescription for appt1 — includes follow-up
    final prescription1 = {
      'timestamp': ts1,
      'doctorName': 'Dr. Mahmud Hasan',
      'doctorSpecialization': 'Chest & Medicine',
      'patientName': 'Demo Patient',
      'patientMobile': '01712345678',
      'medicines': [
        {'name': 'Azithromycin', 'dose': '500mg', 'timing': 'Once daily — 5 days'},
        {'name': 'Salbutamol', 'dose': '2.5mg', 'timing': 'Inhale when needed'},
        {'name': 'Cetirizine', 'dose': '10mg', 'timing': 'At night'},
      ],
      'tests': ['Chest X-Ray', 'CBC'],
      'notes': 'Avoid cold drinks. Rest properly. Return if breathing difficulty increases.',
      'hasFollowUp': true,
      'followUpDate': '2 weeks',
      'followUpFee': '400',
    };
    await prefs.setString('prescription_$ts1', jsonEncode(prescription1));

    // Appointment 2: 2 days ago — general check-up, no follow-up
    final ts2 = now.subtract(const Duration(days: 2)).toIso8601String();
    final appt2 = {
      'timestamp': ts2,
      'slotTime': ts2,
      'selectedDay': 'Thursday',
      'serialNumber': 9,
      'approximateTime': '5:30 PM',
      'consultationFee': 500,
      'paymentMethod': 'Nagad',
      'patientMobile': '01712345678',
      'patientName': 'Demo Patient',
      'doctorName': 'Dr. Rina Parvin',
      'doctorEmail': 'rina.parvin@medihub.com',
      'specialization': 'General Medicine',
      'location': 'Chittagong',
    };

    await prefs.setString(key, jsonEncode([appt1, appt2]));
  }

  Future<Map<String, dynamic>?> _loadPrescription(String timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('prescription_$timestamp');
    if (json != null) return Map<String, dynamic>.from(jsonDecode(json));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Appointment History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _appointments.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) =>
                      _buildAppointmentCard(_appointments[index]),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text('No Appointments Yet',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('Your appointment history will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appt) {
    final DateTime dt = DateTime.parse(appt['timestamp']);
    final String fDate = '${dt.day}/${dt.month}/${dt.year}';
    final String fTime =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    final bool isFollowUp = appt['isFollowUp'] == true;

    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadPrescription(appt['timestamp']),
      builder: (context, snap) {
        final prescription = snap.data;
        final hasFollowUp = prescription != null && prescription['hasFollowUp'] == true;
        final followUpBooked = appt['followUpBooked'] == true;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: hasFollowUp && !followUpBooked
                ? Border.all(color: Colors.green.shade300, width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFollowUp
                        ? [Colors.green.shade300, Colors.green.shade500]
                        : [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Text(
                        (appt['doctorName'] ?? 'D').substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isFollowUp) ...[
                                Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('Follow-up',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                              Flexible(
                                child: Text(
                                  appt['doctorName'] ?? 'Doctor',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              appt['specialization'] ?? 'Specialist',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.local_hospital,
                        color: Colors.white70, size: 26),
                  ],
                ),
              ),

              // â”€â”€ Details â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  children: [
                    _detailRow(Icons.calendar_today, 'Day',
                        appt['selectedDay'] ?? 'N/A'),
                    const SizedBox(height: 10),
                    _detailRow(Icons.access_time, 'Approx. Time',
                        appt['approximateTime'] ?? 'N/A'),
                    const SizedBox(height: 10),
                    _detailRow(Icons.confirmation_number, 'Serial',
                        '#${appt['serialNumber']}'),
                    const SizedBox(height: 10),
                    _detailRow(Icons.location_on, 'Location',
                        appt['location'] ?? 'N/A'),
                    const SizedBox(height: 10),
                    _detailRow(Icons.payments, 'Fee',
                        'à§³${appt['consultationFee']}'),
                    const Divider(height: 22),

                    // Date / status row
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Booked: $fDate at $fTime',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green.shade600, size: 14),
                              const SizedBox(width: 4),
                              Text('Confirmed',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Follow-up indicator (read-only)
                    if (hasFollowUp && !isFollowUp) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: followUpBooked
                              ? Colors.grey.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: followUpBooked
                                  ? Colors.grey.shade300
                                  : Colors.green.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.event_repeat,
                                size: 14,
                                color: followUpBooked
                                    ? Colors.grey
                                    : Colors.green.shade700),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                followUpBooked
                                    ? 'Follow-up already booked'
                                    : 'Doctor recommended a follow-up — open prescription to book',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: followUpBooked
                                        ? Colors.grey
                                        : Colors.green.shade800,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Prescription button
                    if (prescription != null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PatientPrescriptionScreen(
                                  prescription: prescription,
                                  appointment: appt,
                                ),
                              ),
                            );
                            _loadAppointments();
                          },
                          icon: const Icon(Icons.medication_liquid, size: 18),
                          label: const Text('View & Download Prescription'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty,
                                size: 16, color: Colors.grey.shade400),
                            const SizedBox(width: 8),
                            Text('No prescription yet',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.green.shade600, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade600)),
              const SizedBox(height: 1),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

