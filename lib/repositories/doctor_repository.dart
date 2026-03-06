import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor_profile.dart';
import '../models/doctor_schedule.dart';
import '../models/review.dart';

class DoctorRepository {
  final _client = Supabase.instance.client;

  // ── Doctor profiles ──────────────────────────────────────────

  Future<List<DoctorProfile>> getAllDoctors() async {
    final data = await _client.from('doctors').select().order('full_name');
    return data.map((e) => DoctorProfile.fromJson(e)).toList();
  }

  Future<DoctorProfile?> getDoctorById(String userId) async {
    final data = await _client
        .from('doctors')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return data != null ? DoctorProfile.fromJson(data) : null;
  }

  Future<DoctorProfile> updateDoctorProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final result = await _client
        .from('doctors')
        .update(data)
        .eq('id', userId)
        .select()
        .single();
    return DoctorProfile.fromJson(result);
  }

  Future<List<String>> getAllSpecializations() async {
    final data = await _client.from('doctors').select('specialization');
    final specs = data
        .map((e) => e['specialization'] as String?)
        .where((s) => s != null && s.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    specs.sort();
    return specs;
  }

  Future<List<String>> getAllLocations() async {
    final data = await _client.from('doctors').select('location');
    final locs = data
        .map((e) => e['location'] as String?)
        .where((s) => s != null && s.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    locs.sort();
    return locs;
  }

  // ── Doctor schedules ─────────────────────────────────────────

  Future<List<DoctorSchedule>> getDoctorSchedules(String doctorId) async {
    final data = await _client
        .from('doctor_schedules')
        .select()
        .eq('doctor_id', doctorId);
    return data.map((e) => DoctorSchedule.fromJson(e)).toList();
  }

  Future<void> upsertSchedule({
    required String doctorId,
    required String dayOfWeek,
    required String timeRange,
    required int totalSeats,
  }) async {
    await _client.from('doctor_schedules').upsert({
      'doctor_id': doctorId,
      'day_of_week': dayOfWeek,
      'time_range': timeRange,
      'total_seats': totalSeats,
    }, onConflict: 'doctor_id,day_of_week');
  }

  // ── Reviews ──────────────────────────────────────────────────

  Future<List<Review>> getDoctorReviews(String doctorId) async {
    final data = await _client
        .from('reviews')
        .select()
        .eq('doctor_id', doctorId)
        .order('created_at', ascending: false);
    return data.map((e) => Review.fromJson(e)).toList();
  }

  Future<double> getDoctorAverageRating(String doctorId) async {
    final data = await _client
        .from('reviews')
        .select('rating')
        .eq('doctor_id', doctorId);
    if (data.isEmpty) return 0.0;
    final sum = data.fold<double>(
      0,
      (acc, e) => acc + (e['rating'] as num).toDouble(),
    );
    return sum / data.length;
  }

  Future<int> getDoctorReviewCount(String doctorId) async {
    final data = await _client
        .from('reviews')
        .select('id')
        .eq('doctor_id', doctorId);
    return data.length;
  }

  Future<Review> submitReview({
    required String doctorId,
    required String patientId,
    required String patientName,
    required double rating,
    String? comment,
  }) async {
    final result = await _client
        .from('reviews')
        .insert({
          'doctor_id': doctorId,
          'patient_id': patientId,
          'patient_name': patientName,
          'rating': rating,
          'comment': comment,
        })
        .select()
        .single();
    return Review.fromJson(result);
  }
}
