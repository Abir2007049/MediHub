import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/medicine_test_service.dart';

class PrescriptionScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final String doctorEmail;
  final String doctorName;
  final String doctorSpecialization;

  const PrescriptionScreen({
    Key? key,
    required this.appointment,
    required this.doctorEmail,
    required this.doctorName,
    required this.doctorSpecialization,
  }) : super(key: key);

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _followUpFeeController = TextEditingController(text: '300');
  final TextEditingController _customMedicineController = TextEditingController();
  final TextEditingController _customTestController = TextEditingController();

  List<Map<String, String>> _selectedMedicines = [];
  List<String> _selectedTests = [];
  String? _followUpDate;
  bool _hasFollowUp = false;
  bool _isSaving = false;
  bool _prescriptionSaved = false;
  bool _isLoadingMedicines = true;
  bool _isLoadingTests = true;

  // Dynamic lists fetched from API
  List<Map<String, String>> _commonMedicines = [];
  List<String> _commonTests = [];

  final List<String> _followUpDays = [
    '3 days', '5 days', '1 week', '2 weeks', '1 month', '2 months', '3 months',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingPrescription();
    _loadMedicinesAndTests();
  }

  /// Fetch medicines and tests from API
  Future<void> _loadMedicinesAndTests() async {
    try {
      final medicines = await MedicineTestService.fetchMedicines();
      final tests = await MedicineTestService.fetchTests();
      
      if (mounted) {
        setState(() {
          _commonMedicines = medicines;
          _commonTests = tests;
          _isLoadingMedicines = false;
          _isLoadingTests = false;
        });
      }
    } catch (e) {
      print('Error loading medicines and tests: $e');
      if (mounted) {
        setState(() {
          _isLoadingMedicines = false;
          _isLoadingTests = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _followUpFeeController.dispose();
    _customMedicineController.dispose();
    _customTestController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingPrescription() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'prescription_${widget.appointment['timestamp']}';
    final savedJson = prefs.getString(key);
    if (savedJson != null) {
      final data = jsonDecode(savedJson) as Map<String, dynamic>;
      setState(() {
        _selectedMedicines = (data['medicines'] as List)
            .map((e) => Map<String, String>.from(e))
            .toList();
        _selectedTests = List<String>.from(data['tests'] ?? []);
        _notesController.text = data['notes'] ?? '';
        _hasFollowUp = data['hasFollowUp'] ?? false;
        _followUpDate = data['followUpDate'];
        _followUpFeeController.text = data['followUpFee']?.toString() ?? '300';
        _prescriptionSaved = true;
      });
    }
  }

  Future<void> _savePrescription() async {
    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final key = 'prescription_${widget.appointment['timestamp']}';

    final prescription = {
      'timestamp': DateTime.now().toIso8601String(),
      'doctorEmail': widget.doctorEmail,
      'doctorName': widget.doctorName,
      'patientName': widget.appointment['patientName'],
      'patientMobile': widget.appointment['patientMobile'],
      'medicines': _selectedMedicines,
      'tests': _selectedTests,
      'notes': _notesController.text.trim(),
      'hasFollowUp': _hasFollowUp,
      'followUpDate': _followUpDate,
      'followUpFee': _hasFollowUp ? _followUpFeeController.text.trim() : null,
    };

    await prefs.setString(key, jsonEncode(prescription));

    // Also save a flag on the appointment in patient history
    final patientMobile = widget.appointment['patientMobile'] ?? '';
    if (patientMobile.isNotEmpty) {
      final patientHistoryJson = prefs.getString('patient_history_$patientMobile');
      if (patientHistoryJson != null) {
        final List<dynamic> history = jsonDecode(patientHistoryJson);
        for (var appt in history) {
          if (appt['timestamp'] == widget.appointment['timestamp']) {
            appt['hasPrescription'] = true;
            appt['followUpDate'] = _followUpDate;
            appt['followUpFee'] = _hasFollowUp ? _followUpFeeController.text.trim() : null;
          }
        }
        await prefs.setString('patient_history_$patientMobile', jsonEncode(history));
      }
    }

    setState(() {
      _isSaving = false;
      _prescriptionSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prescription saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addMedicineFromDropdown(Map<String, String> medicine) {
    if (!_selectedMedicines.any((m) => m['name'] == medicine['name'])) {
      setState(() {
        _selectedMedicines.add(Map<String, String>.from(medicine));
      });
    }
  }

  void _addCustomMedicine() {
    final name = _customMedicineController.text.trim();
    if (name.isEmpty) return;
    if (!_selectedMedicines.any((m) => m['name'] == name)) {
      setState(() {
        _selectedMedicines.add({'name': name, 'dose': '', 'timing': ''});
      });
    }
    _customMedicineController.clear();
  }

  void _addCustomTest() {
    final name = _customTestController.text.trim();
    if (name.isEmpty) return;
    if (!_selectedTests.contains(name)) {
      setState(() => _selectedTests.add(name));
    }
    _customTestController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Prescription'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_prescriptionSaved)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.check_circle, color: Colors.white),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            _buildSectionCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      (appt['patientName'] ?? 'P').substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appt['patientMobile'] ?? '',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildChip(appt['selectedDay'] ?? '', Colors.green),
                            const SizedBox(width: 8),
                            _buildChip('Serial #${appt['serialNumber']}', Colors.orange),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Doctor Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.doctorName}  •  ${widget.doctorSpecialization}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── MEDICINES ──────────────────────────────────────────
            _buildSectionTitle('💊 Medicines', Colors.blue.shade700),
            const SizedBox(height: 10),

            // Dropdown to add medicine
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoadingMedicines)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.blue.shade600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('Loading medicines...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              )),
                        ],
                      ),
                    )
                  else
                    DropdownButtonFormField<Map<String, String>>(
                      decoration: InputDecoration(
                        labelText: 'Add from common medicines',
                        prefixIcon: Icon(Icons.medication, color: Colors.blue.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      hint: const Text('Select medicine'),
                      isExpanded: true,
                      items: _commonMedicines.map((med) {
                        return DropdownMenuItem<Map<String, String>>(
                          value: med,
                          child: Text(
                            '${med['name']} ${med['dose']} — ${med['timing']}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) _addMedicineFromDropdown(val);
                      },
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customMedicineController,
                          decoration: InputDecoration(
                            hintText: 'Custom medicine name',
                            prefixIcon: const Icon(Icons.edit, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addCustomMedicine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Selected Medicines List
            if (_selectedMedicines.isNotEmpty) ...[
              const SizedBox(height: 10),
              ..._selectedMedicines.asMap().entries.map((entry) {
                final i = entry.key;
                final med = entry.value;
                return _buildMedicineCard(med, i);
              }),
            ] else ...[
              const SizedBox(height: 8),
              _buildEmptyHint('No medicines added yet'),
            ],

            const SizedBox(height: 20),

            // ── TESTS ──────────────────────────────────────────────
            _buildSectionTitle('🧪 Diagnostic Tests', Colors.purple.shade700),
            const SizedBox(height: 10),

            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoadingTests)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.purple.shade600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('Loading tests...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              )),
                        ],
                      ),
                    )
                  else
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Add from common tests',
                        prefixIcon: Icon(Icons.science, color: Colors.purple.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purple.shade400, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      hint: const Text('Select test'),
                      isExpanded: true,
                      items: _commonTests.map((test) {
                        return DropdownMenuItem<String>(
                          value: test,
                          child: Text(
                            test,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null && !_selectedTests.contains(val)) {
                          setState(() => _selectedTests.add(val));
                        }
                      },
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customTestController,
                          decoration: InputDecoration(
                            hintText: 'Custom test name',
                            prefixIcon: const Icon(Icons.edit, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addCustomTest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Selected Tests
            if (_selectedTests.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildSectionCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedTests.map((test) {
                    return Chip(
                      label: Text(test, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.purple.shade50,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => _selectedTests.remove(test)),
                      side: BorderSide(color: Colors.purple.shade200),
                    );
                  }).toList(),
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              _buildEmptyHint('No tests added yet'),
            ],

            const SizedBox(height: 20),

            // ── DOCTOR'S NOTES ────────────────────────────────────
            _buildSectionTitle('📝 Doctor\'s Notes', Colors.orange.shade700),
            const SizedBox(height: 10),
            _buildSectionCard(
              child: TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Diagnosis, advice, special instructions...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange.shade400, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── FOLLOW-UP ─────────────────────────────────────────
            _buildSectionTitle('🔄 Follow-Up Appointment', Colors.teal.shade700),
            const SizedBox(height: 10),

            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Schedule Follow-up',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _hasFollowUp ? 'Patient will be notified' : 'No follow-up scheduled',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    value: _hasFollowUp,
                    activeColor: Colors.teal,
                    onChanged: (val) => setState(() => _hasFollowUp = val),
                  ),
                  if (_hasFollowUp) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Follow-up after',
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.teal.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      value: _followUpDate,
                      hint: const Text('Select duration'),
                      items: _followUpDays.map((d) {
                        return DropdownMenuItem(value: d, child: Text(d));
                      }).toList(),
                      onChanged: (val) => setState(() => _followUpDate = val),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _followUpFeeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Follow-up Consultation Fee (৳)',
                        prefixIcon: Icon(Icons.attach_money, color: Colors.teal.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.teal.shade700, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Patient will pay ৳${_followUpFeeController.text.isEmpty ? "?" : _followUpFeeController.text} for the follow-up visit',
                              style: TextStyle(fontSize: 12, color: Colors.teal.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _savePrescription,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save_alt),
                label: Text(_isSaving ? 'Saving...' : _prescriptionSaved ? 'Update Prescription' : 'Save Prescription'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard(Map<String, String> med, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blue.shade700,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if ((med['dose'] ?? '').isNotEmpty || (med['timing'] ?? '').isNotEmpty)
                  Text(
                    '${med['dose'] ?? ''}  •  ${med['timing'] ?? ''}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
            onPressed: () => setState(() => _selectedMedicines.removeAt(index)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEmptyHint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontStyle: FontStyle.italic),
      ),
    );
  }
}
