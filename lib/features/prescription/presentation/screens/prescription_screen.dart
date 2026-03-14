import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'package:medihub/features/prescription/presentation/cubit/prescription_cubit.dart';
import 'package:medihub/features/prescription/presentation/cubit/prescription_state.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/models/medicine.dart';
import 'package:medihub/features/prescription/data/services/medicine_test_service.dart';

class PrescriptionScreen extends StatefulWidget {
  final Appointment appointment;

  const PrescriptionScreen({super.key, required this.appointment});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _primary => _colors.primary;
  Color get _primaryContainer => _colors.primaryContainer;

  final List<Map<String, String>> _medicines = [];
  final List<String> _tests = [];
  final _notesController = TextEditingController();
  bool _hasFollowUp = false;
  final _followUpDateController = TextEditingController();
  final _followUpFeeController = TextEditingController();

  List<Map<String, String>> _availableMedicines = [];
  List<String> _availableTests = [];
  bool _loadingMedDb = true;
  String? _existingId;

  @override
  void initState() {
    super.initState();
    _loadMedicineDatabase();

    if (widget.appointment.id != null) {
      context.read<PrescriptionCubit>().loadByAppointmentId(
        widget.appointment.id!,
      );
    }
  }

  Future<void> _loadMedicineDatabase() async {
    try {
      final meds = await MedicineTestService.fetchMedicines();
      final tests = await MedicineTestService.fetchTests();
      if (mounted) {
        setState(() {
          _availableMedicines = meds;
          _availableTests = tests;
          _loadingMedDb = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMedDb = false);
    }
  }

  void _populateFromExisting(PrescriptionLoaded state) {
    final p = state.prescription;
    _existingId = p.id;
    _medicines.clear();
    for (final m in p.medicines) {
      _medicines.add({'name': m.name, 'dose': m.dose, 'timing': m.timing});
    }
    _tests.clear();
    _tests.addAll(p.tests);
    _notesController.text = p.notes ?? '';
    _hasFollowUp = p.hasFollowUp;
    _followUpDateController.text = p.followUpDate ?? '';
    _followUpFeeController.text = p.followUpFee ?? '';
  }

  void _addMedicine() {
    final nameC = TextEditingController();
    final doseC = TextEditingController();
    final timingC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Medicine'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<String>(
                optionsBuilder: (value) {
                  if (value.text.isEmpty) return const Iterable.empty();
                  return _availableMedicines
                      .map((m) => m['name'] ?? '')
                      .where(
                        (n) =>
                            n.toLowerCase().contains(value.text.toLowerCase()),
                      );
                },
                fieldViewBuilder: (ctx, controller, focusNode, onSubmitted) {
                  nameC.text = controller.text;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Medicine Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (v) => nameC.text = v,
                  );
                },
                onSelected: (val) => nameC.text = val,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: doseC,
                decoration: InputDecoration(
                  labelText: 'Dose (e.g. 1+0+1)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timingC,
                decoration: InputDecoration(
                  labelText: 'Timing (e.g. After meal)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameC.text.trim().isNotEmpty) {
                setState(() {
                  _medicines.add({
                    'name': nameC.text.trim(),
                    'dose': doseC.text.trim(),
                    'timing': timingC.text.trim(),
                  });
                });
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primary),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addTest() {
    final testC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Test'),
        content: Autocomplete<String>(
          optionsBuilder: (value) {
            if (value.text.isEmpty) return const Iterable.empty();
            return _availableTests.where(
              (t) => t.toLowerCase().contains(value.text.toLowerCase()),
            );
          },
          fieldViewBuilder: (ctx, controller, focusNode, onSubmitted) {
            testC.text = controller.text;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Test Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => testC.text = v,
            );
          },
          onSelected: (val) => testC.text = val,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (testC.text.trim().isNotEmpty) {
                setState(() => _tests.add(testC.text.trim()));
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primary),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _savePrescription() {
    final a = widget.appointment;

    // Get doctor info from auth cubit
    String? doctorName;
    String? doctorSpec;
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthenticatedAsDoctor) {
      doctorName = authState.profile.fullName;
      doctorSpec = authState.profile.specialization;
    }

    final medModels = _medicines
        .map(
          (m) => Medicine(
            name: m['name'] ?? '',
            dose: m['dose'] ?? '',
            timing: m['timing'] ?? '',
          ),
        )
        .toList();

    context.read<PrescriptionCubit>().savePrescription(
      appointmentId: a.id!,
      doctorId: a.doctorId,
      patientId: a.patientId,
      doctorName: doctorName ?? a.doctorName,
      doctorSpecialization: doctorSpec ?? a.specialization,
      patientName: a.patientName,
      patientMobile: a.patientMobile,
      medicines: medModels,
      tests: _tests,
      notes: _notesController.text.trim(),
      hasFollowUp: _hasFollowUp,
      followUpDate: _followUpDateController.text.trim().isNotEmpty
          ? _followUpDateController.text.trim()
          : null,
      followUpFee: _followUpFeeController.text.trim().isNotEmpty
          ? _followUpFeeController.text.trim()
          : null,
      existingId: _existingId,
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _followUpDateController.dispose();
    _followUpFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.appointment;

    return BlocConsumer<PrescriptionCubit, PrescriptionState>(
      listener: (context, state) {
        if (state is PrescriptionLoaded && _existingId == null) {
          _populateFromExisting(state);
        }
        if (state is PrescriptionSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Prescription saved!'),
              backgroundColor: _primary,
            ),
          );
        }
        if (state is PrescriptionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Prescription'),
            backgroundColor: _colors.surface,
            foregroundColor: _primary,
            elevation: 0,
            actions: [
              if (state is PrescriptionSaving)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _primary,
                    ),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: _savePrescription,
                  icon: Icon(Icons.save, color: _primary),
                  label: Text('Save', style: TextStyle(color: _primary)),
                ),
            ],
          ),
          body: state is PrescriptionLoading
              ? Center(child: CircularProgressIndicator(color: _primary))
              : _buildBody(a),
        );
      },
    );
  }

  Widget _buildBody(Appointment a) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: _primaryContainer,
                        child: Icon(Icons.person, color: _primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.patientName ?? 'Patient',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (a.patientMobile != null)
                              Text(
                                a.patientMobile!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        'Serial #${a.serialNumber}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${a.selectedDay} • ${a.approximateTime ?? ''}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Medicines section
            _sectionHeader('Medicines', _addMedicine),
            if (_medicines.isEmpty)
              _emptyHint('No medicines added yet')
            else
              ..._medicines.asMap().entries.map((e) {
                final i = e.key;
                final m = e.value;
                return Container(
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
                          color: _primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.medication,
                          size: 20,
                          color: _primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if ((m['dose'] ?? '').isNotEmpty ||
                                (m['timing'] ?? '').isNotEmpty)
                              Text(
                                '${m['dose']}  ${m['timing']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.red.shade400,
                        ),
                        onPressed: () => setState(() => _medicines.removeAt(i)),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 20),

            // Tests section
            _sectionHeader('Tests', _addTest),
            if (_tests.isEmpty)
              _emptyHint('No tests added yet')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tests.asMap().entries.map((e) {
                  final i = e.key;
                  final t = e.value;
                  return Chip(
                    label: Text(t),
                    deleteIcon: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.red.shade400,
                    ),
                    onDeleted: () => setState(() => _tests.removeAt(i)),
                    backgroundColor: _colors.secondaryContainer,
                    side: BorderSide(color: _colors.outlineVariant),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),

            // Notes
            Text(
              'Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Additional notes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Follow-up toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Follow-up Required',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: _hasFollowUp,
                        onChanged: (v) => setState(() => _hasFollowUp = v),
                        activeThumbColor: _primary,
                      ),
                    ],
                  ),
                  if (_hasFollowUp) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _followUpDateController,
                      decoration: InputDecoration(
                        labelText: 'Follow-up Date',
                        hintText: 'e.g. After 2 weeks',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: _colors.surface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _followUpFeeController,
                      decoration: InputDecoration(
                        labelText: 'Follow-up Fee (৳)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: _colors.surface,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _savePrescription,
                icon: const Icon(Icons.save),
                label: Text(
                  _existingId != null
                      ? 'Update Prescription'
                      : 'Save Prescription',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
              ),
            ),

            if (_loadingMedDb)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: Text(
                    'Loading medicine database...',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: Icon(Icons.add, size: 18, color: _primary),
          label: Text('Add', style: TextStyle(color: _primary)),
        ),
      ],
    );
  }

  Widget _emptyHint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
      ),
    );
  }
}
