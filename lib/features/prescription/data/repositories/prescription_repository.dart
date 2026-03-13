import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medihub/models/prescription.dart';
import 'package:medihub/models/medicine.dart';

class PrescriptionRepository {
  final _client = Supabase.instance.client;

  Future<Prescription?> getByAppointmentId(String appointmentId) async {
    final data = await _client
        .from('prescriptions')
        .select()
        .eq('appointment_id', appointmentId)
        .maybeSingle();
    return data != null ? Prescription.fromJson(data) : null;
  }

  Future<Prescription> createPrescription({
    required String appointmentId,
    required String doctorId,
    required String patientId,
    String? doctorName,
    String? doctorSpecialization,
    String? patientName,
    String? patientMobile,
    List<Medicine> medicines = const [],
    List<String> tests = const [],
    String? notes,
    bool hasFollowUp = false,
    String? followUpDate,
    String? followUpFee,
  }) async {
    final result = await _client
        .from('prescriptions')
        .insert({
          'appointment_id': appointmentId,
          'doctor_id': doctorId,
          'patient_id': patientId,
          'doctor_name': doctorName,
          'doctor_specialization': doctorSpecialization,
          'patient_name': patientName,
          'patient_mobile': patientMobile,
          'medicines': medicines.map((m) => m.toJson()).toList(),
          'tests': tests,
          'notes': notes,
          'has_follow_up': hasFollowUp,
          'follow_up_date': followUpDate,
          'follow_up_fee': followUpFee,
        })
        .select()
        .single();
    return Prescription.fromJson(result);
  }

  Future<Prescription> updatePrescription(
    String id, {
    List<Medicine>? medicines,
    List<String>? tests,
    String? notes,
    bool? hasFollowUp,
    String? followUpDate,
    String? followUpFee,
  }) async {
    final data = <String, dynamic>{};
    if (medicines != null) {
      data['medicines'] = medicines.map((m) => m.toJson()).toList();
    }
    if (tests != null) data['tests'] = tests;
    if (notes != null) data['notes'] = notes;
    if (hasFollowUp != null) data['has_follow_up'] = hasFollowUp;
    if (followUpDate != null) data['follow_up_date'] = followUpDate;
    if (followUpFee != null) data['follow_up_fee'] = followUpFee;

    final result = await _client
        .from('prescriptions')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return Prescription.fromJson(result);
  }

  Future<void> markFollowUpBooked(String id) async {
    await _client
        .from('prescriptions')
        .update({'follow_up_booked': true})
        .eq('id', id);
  }

  /// Fetch prescriptions for multiple appointments at once.
  Future<Map<String, Prescription>> getPrescriptionsForAppointments(
    List<String> appointmentIds,
  ) async {
    if (appointmentIds.isEmpty) return {};
    final data = await _client
        .from('prescriptions')
        .select()
        .inFilter('appointment_id', appointmentIds);
    final map = <String, Prescription>{};
    for (final row in data) {
      final p = Prescription.fromJson(row);
      map[p.appointmentId] = p;
    }
    return map;
  }
}

