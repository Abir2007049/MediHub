import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';

class AppointmentRepository {
  final _client = Supabase.instance.client;

  Future<List<Appointment>> getPatientAppointments(String patientId) async {
    final data = await _client
        .from('appointments')
        .select()
        .eq('patient_id', patientId)
        .order('created_at', ascending: false);
    return data.map((e) => Appointment.fromJson(e)).toList();
  }

  Future<List<Appointment>> getDoctorAppointments(String doctorId) async {
    final data = await _client
        .from('appointments')
        .select()
        .eq('doctor_id', doctorId)
        .order('created_at', ascending: false);
    return data.map((e) => Appointment.fromJson(e)).toList();
  }

  Future<Appointment> createAppointment({
    required String patientId,
    required String doctorId,
    String? patientName,
    String? patientMobile,
    String? doctorName,
    String? specialization,
    String? location,
    required String selectedDay,
    required int serialNumber,
    String? approximateTime,
    int consultationFee = 500,
    String? paymentMethod,
    DateTime? slotTime,
    bool isFollowUp = false,
    String? parentAppointmentId,
  }) async {
    final data = await _client
        .from('appointments')
        .insert({
          'patient_id': patientId,
          'doctor_id': doctorId,
          'patient_name': patientName,
          'patient_mobile': patientMobile,
          'doctor_name': doctorName,
          'specialization': specialization,
          'location': location,
          'selected_day': selectedDay,
          'serial_number': serialNumber,
          'approximate_time': approximateTime,
          'consultation_fee': consultationFee,
          'payment_method': paymentMethod,
          'slot_time': slotTime?.toIso8601String(),
          'is_follow_up': isFollowUp,
          'parent_appointment_id': parentAppointmentId,
        })
        .select()
        .single();
    return Appointment.fromJson(data);
  }

  Future<List<int>> getBookedSerials(
    String doctorId,
    String selectedDay,
  ) async {
    final data = await _client
        .from('appointments')
        .select('serial_number')
        .eq('doctor_id', doctorId)
        .eq('selected_day', selectedDay)
        .eq('status', 'confirmed');
    return data.map<int>((e) => e['serial_number'] as int).toList();
  }

  Future<void> updateAppointment(String id, Map<String, dynamic> data) async {
    await _client.from('appointments').update(data).eq('id', id);
  }
}
