import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/features/appointments/data/repositories/appointment_repository.dart';
import 'package:medihub/features/doctor/data/repositories/doctor_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final AppointmentRepository _appointmentRepo;
  final DoctorRepository _doctorRepo;

  BookingCubit({
    AppointmentRepository? appointmentRepo,
    DoctorRepository? doctorRepo,
  }) : _appointmentRepo = appointmentRepo ?? AppointmentRepository(),
       _doctorRepo = doctorRepo ?? DoctorRepository(),
       super(BookingInitial());

  Future<void> loadSchedule(String doctorId) async {
    emit(BookingLoadingSchedule());
    try {
      final schedules = await _doctorRepo.getDoctorSchedules(doctorId);
      final bookedSerials = <String, List<int>>{};

      for (final s in schedules) {
        final booked = await _appointmentRepo.getBookedSerials(
          doctorId,
          s.dayOfWeek,
        );
        bookedSerials[s.dayOfWeek] = booked;
      }

      emit(
        BookingScheduleLoaded(
          schedules: schedules,
          bookedSerials: bookedSerials,
        ),
      );
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> confirmBooking({
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
    bool isFollowUp = false,
    String? parentAppointmentId,
  }) async {
    emit(BookingConfirming());
    try {
      final appointment = await _appointmentRepo.createAppointment(
        patientId: patientId,
        doctorId: doctorId,
        patientName: patientName,
        patientMobile: patientMobile,
        doctorName: doctorName,
        specialization: specialization,
        location: location,
        selectedDay: selectedDay,
        serialNumber: serialNumber,
        approximateTime: approximateTime,
        consultationFee: consultationFee,
        paymentMethod: paymentMethod,
        slotTime: DateTime.now(),
        isFollowUp: isFollowUp,
        parentAppointmentId: parentAppointmentId,
      );
      emit(BookingConfirmed(appointment));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}


