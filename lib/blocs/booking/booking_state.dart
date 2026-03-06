import '../../models/doctor_schedule.dart';
import '../../models/appointment.dart';

sealed class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoadingSchedule extends BookingState {}

class BookingScheduleLoaded extends BookingState {
  final List<DoctorSchedule> schedules;

  /// day_of_week → list of already-booked serial numbers
  final Map<String, List<int>> bookedSerials;

  BookingScheduleLoaded({required this.schedules, required this.bookedSerials});
}

class BookingConfirming extends BookingState {}

class BookingConfirmed extends BookingState {
  final Appointment appointment;
  BookingConfirmed(this.appointment);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}
