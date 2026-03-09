import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/doctor_profile.dart';
import '../../repositories/doctor_repository.dart';
import 'doctor_list_state.dart';

class DoctorListCubit extends Cubit<DoctorListState> {
  final DoctorRepository _repo;

  DoctorListCubit({DoctorRepository? repo})
    : _repo = repo ?? DoctorRepository(),
      super(DoctorListInitial());

  Future<void> loadDoctors() async {
    emit(DoctorListLoading());
    try {
      final results = await Future.wait([
        _repo.getAllDoctors(),
        _repo.getAllSpecializations(),
        _repo.getAllLocations(),
        _repo.getAllDoctorRatings(),
      ]);
      emit(
        DoctorListLoaded(
          doctors: results[0] as List<DoctorProfile>,
          specializations: results[1] as List<String>,
          locations: results[2] as List<String>,
          doctorRatings: results[3] as Map<String, double>,
        ),
      );
    } catch (e) {
      emit(DoctorListError(e.toString()));
    }
  }
}
