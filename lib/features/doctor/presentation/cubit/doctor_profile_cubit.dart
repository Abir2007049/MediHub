import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/core/di/service_locator.dart';
import 'package:medihub/features/doctor/data/repositories/doctor_repository.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final DoctorRepository _repo;
  final AuthCubit _authCubit;
  late final StreamSubscription _authSub;

  DoctorProfileCubit({DoctorRepository? repo, AuthCubit? authCubit})
    : _repo = repo ?? sl<DoctorRepository>(),
      _authCubit = authCubit ?? sl<AuthCubit>(),
      super(DoctorProfileInitial()) {
    _syncWithAuthState(_authCubit.state);
    _authSub = _authCubit.stream.listen(_syncWithAuthState);
  }

  void _syncWithAuthState(AuthState authState) {
    if (authState is AuthenticatedAsDoctor) {
      emit(DoctorProfileLoaded(authState.profile));
    } else if (authState is AuthUnauthenticated) {
      emit(DoctorProfileInitial());
    }
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }

  Future<void> loadProfile([String? userId]) async {
    final currentState = _authCubit.state;
    if (userId == null && currentState is AuthenticatedAsDoctor) {
      emit(DoctorProfileLoaded(currentState.profile));
      return;
    }

    final id = userId ?? _authCubit.currentUserId;
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
    final userId = _authCubit.currentUserId;
    if (userId == null) {
      emit(DoctorProfileError('Not logged in'));
      return;
    }
    emit(DoctorProfileSaving());
    try {
      final updated = await _repo.updateDoctorProfile(userId, data);

      // Update AuthCubit state to keep the single source of truth in sync
      _authCubit.setDoctorAuthenticated(updated);

      emit(DoctorProfileSaved(updated));
      emit(DoctorProfileLoaded(updated));
    } catch (e) {
      emit(DoctorProfileError(e.toString()));
      if (currentState is DoctorProfileLoaded) {
        emit(currentState);
      }
    }
  }
}
