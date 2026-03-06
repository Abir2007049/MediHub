import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/doctor_repository.dart';
import '../../services/supabase_auth_service.dart';
import 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final DoctorRepository _repo;

  DoctorProfileCubit({DoctorRepository? repo})
    : _repo = repo ?? DoctorRepository(),
      super(DoctorProfileInitial());

  Future<void> loadProfile([String? userId]) async {
    final id = userId ?? SupabaseAuthService.instance.currentUser?.id;
    if (id == null) {
      emit(DoctorProfileError('Not logged in'));
      return;
    }
    emit(DoctorProfileLoading());
    try {
      final profile = await _repo.getDoctorById(id);
      if (profile != null) {
        emit(DoctorProfileLoaded(profile));
      } else {
        emit(DoctorProfileError('Profile not found'));
      }
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final currentState = state;
    final userId = SupabaseAuthService.instance.currentUser?.id;
    if (userId == null) {
      emit(DoctorProfileError('Not logged in'));
      return;
    }
    emit(DoctorProfileSaving());
    try {
      final updated = await _repo.updateDoctorProfile(userId, data);
      emit(DoctorProfileSaved(updated));
      // Re-emit as loaded so widgets see the new profile
      emit(DoctorProfileLoaded(updated));
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
      // Restore previous state on error
      if (currentState is DoctorProfileLoaded) {
        emit(currentState);
      }
    }
  }
}
