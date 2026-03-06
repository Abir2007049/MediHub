import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DoctorHistoryScreen extends StatefulWidget {
  final String doctorEmail;
  final String doctorName;
  final String doctorSpecialization;

  const DoctorHistoryScreen({
    Key? key,
    required this.doctorEmail,
    this.doctorName = '',
    this.doctorSpecialization = '',
  }) : super(key: key);

  @override
  State<DoctorHistoryScreen> createState() => _DoctorHistoryScreenState();
}

class _DoctorHistoryScreenState extends State<DoctorHistoryScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _hasSlotPassed(Map<String, dynamic> appt) {
    final slotStr = appt['slotTime'];
    if (slotStr == null) return true;
    try {
      return DateTime.now().isAfter(DateTime.parse(slotStr));
    } catch (_) {
      return true;
    }
  }

  List<Map<String, dynamic>> get _pastAppointments =>
      _appointments.where((a) => _hasSlotPassed(a)).toList();

  List<Map<String, dynamic>> get _upcomingAppointments =>
      _appointments.where((a) => !_hasSlotPassed(a)).toList();

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'doctor_history_${widget.doctorEmail}';
    final historyJson = prefs.getString(key);

    List<Map<String, dynamic>> loaded = [];
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      loaded = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    // Seed demo patients if none exist
    if (loaded.isEmpty) {
      loaded = _generateDemoPatients();
      await prefs.setString(key, jsonEncode(loaded));
    }

    loaded.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    setState(() {
      _appointments = loaded;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _generateDemoPatients() {
    final now = DateTime.now();
    return [
      {
        'timestamp': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'slotTime': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'selectedDay': _dayName(now),
        'serialNumber': 3,
        'approximateTime': '4:20 PM',
        'consultationFee': 600,
        'paymentMethod': 'bKash',
        'patientName': 'Rahim Uddin',
        'patientMobile': '01711223344',
        'doctorEmail': widget.doctorEmail,
        'specialization': widget.doctorSpecialization,
        'location': 'Dhaka',
      },
      {
        'timestamp': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'slotTime': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'selectedDay': _dayName(now),
        'serialNumber': 7,
        'approximateTime': '5:10 PM',
        'consultationFee': 600,
        'paymentMethod': 'Cash',
        'patientName': 'Nasrin Akter',
        'patientMobile': '01899887766',
        'doctorEmail': widget.doctorEmail,
        'specialization': widget.doctorSpecialization,
        'location': 'Dhaka',
      },
      {
        'timestamp': now.add(const Duration(hours: 2)).toIso8601String(),
        'slotTime': now.add(const Duration(hours: 2)).toIso8601String(),
        'selectedDay': _dayName(now),
        'serialNumber': 12,
        'approximateTime': '6:00 PM',
        'consultationFee': 600,
        'paymentMethod': 'Nagad',
        'patientName': 'Karim Hossain',
        'patientMobile': '01622334455',
        'doctorEmail': widget.doctorEmail,
        'specialization': widget.doctorSpecialization,
        'location': 'Dhaka',
      },
      {
        'timestamp': now.subtract(const Duration(days: 3)).toIso8601String(),
        'slotTime': now.subtract(const Duration(days: 3)).toIso8601String(),
        'selectedDay': 'Saturday',
        'serialNumber': 5,
        'approximateTime': '4:40 PM',
        'consultationFee': 600,
        'paymentMethod': 'bKash',
        'patientName': 'Fatema Begum',
        'patientMobile': '01533445566',
        'doctorEmail': widget.doctorEmail,
        'specialization': widget.doctorSpecialization,
        'location': 'Dhaka',
      },
      {
        'timestamp': now.subtract(const Duration(days: 7)).toIso8601String(),
        'slotTime': now.subtract(const Duration(days: 7)).toIso8601String(),
        'selectedDay': 'Monday',
        'serialNumber': 2,
        'approximateTime': '4:10 PM',
        'consultationFee': 600,
        'paymentMethod': 'Cash',
        'patientName': 'Arif Islam',
        'patientMobile': '01944556677',
        'doctorEmail': widget.doctorEmail,
        'specialization': widget.doctorSpecialization,
        'location': 'Chittagong',
      },
    ];
  }

  String _dayName(DateTime dt) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dt.weekday - 1];
  }

  Future<Map<String, dynamic>?> _loadPrescription(
    Map<String, dynamic> appt,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'prescription_${appt['timestamp']}';
    final json = prefs.getString(key);
    if (json != null) return Map<String, dynamic>.from(jsonDecode(json));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              text:
                  'Consulted (${_isLoading ? "…" : _pastAppointments.length})',
            ),
            Tab(
              text:
                  'Upcoming (${_isLoading ? "…" : _upcomingAppointments.length})',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : TabBarView(
              controller: _tabController,
              children: [
                _pastAppointments.isEmpty
                    ? _buildEmptyState('No consulted patients yet')
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _pastAppointments.length,
                        itemBuilder: (context, i) => _buildPatientCard(
                          _pastAppointments[i],
                          isPast: true,
                        ),
                      ),
                _upcomingAppointments.isEmpty
                    ? _buildEmptyState('No upcoming appointments')
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _upcomingAppointments.length,
                        itemBuilder: (context, i) => _buildPatientCard(
                          _upcomingAppointments[i],
                          isPast: false,
                        ),
                      ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 90, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> appt, {required bool isPast}) {
    final DateTime dt = DateTime.parse(appt['timestamp']);
    final String fDate = '${dt.day}/${dt.month}/${dt.year}';

    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadPrescription(appt),
      builder: (context, snap) {
        final hasPrescription = snap.data != null;
        final prescription = snap.data;
        final hasFollowUp = prescription?['hasFollowUp'] == true;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: hasPrescription
                ? Border.all(color: Colors.green.shade300, width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPast
                        ? [Colors.green.shade500, Colors.green.shade700]
                        : [Colors.green.shade300, Colors.green.shade500],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Text(
                        (appt['patientName'] ?? 'P')
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isPast
                              ? Colors.green.shade700
                              : Colors.green.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appt['patientName'] ?? 'Patient',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.white70,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                appt['patientMobile'] ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (hasPrescription)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 12),
                            SizedBox(width: 3),
                            Text(
                              'Rx Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // ── Details ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _infoChip(
                          Icons.calendar_today,
                          appt['selectedDay'] ?? 'N/A',
                          Colors.green.shade700,
                        ),
                        const SizedBox(width: 6),
                        _infoChip(
                          Icons.access_time,
                          appt['approximateTime'] ?? 'N/A',
                          Colors.green.shade600,
                        ),
                        const SizedBox(width: 6),
                        _infoChip(
                          Icons.tag,
                          '#${appt['serialNumber']}',
                          Colors.green.shade500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '৳${appt['consultationFee']}  •  ${appt['paymentMethod'] ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isPast ? 'Visited: $fDate' : 'Booked: $fDate',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Follow-up badge
                    if (hasPrescription && hasFollowUp) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_repeat,
                              color: Colors.green.shade700,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Follow-up in ${prescription?['followUpDate'] ?? ""}  •  ৳${prescription?['followUpFee'] ?? ""}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // ── Prescription Action ───────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await context.push(
                            '/doctor/history/prescription',
                            extra: {
                              'appointment': appt,
                              'doctorEmail': widget.doctorEmail,
                              'doctorName': widget.doctorName,
                              'doctorSpecialization':
                                  widget.doctorSpecialization,
                            },
                          );
                          setState(() {});
                        },
                        icon: Icon(
                          hasPrescription
                              ? Icons.edit_note
                              : Icons.medical_services,
                          size: 16,
                        ),
                        label: Text(
                          hasPrescription ? 'Edit Prescription' : 'Prescribe',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasPrescription
                              ? Colors.green.shade700
                              : Colors.green.shade500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
