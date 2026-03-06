import 'package:flutter_bloc/flutter_bloc.dart';
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
      final doctors = await _repo.getAllDoctors();
      final specializations = await _repo.getAllSpecializations();
      final locations = await _repo.getAllLocations();
      emit(
        DoctorListLoaded(
          doctors: doctors,
          specializations: specializations,
          locations: locations,
        ),
      );
    } catch (e) {
      emit(DoctorListError(e.toString()));
    }
  }
}
