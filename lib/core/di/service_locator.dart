import 'package:get_it/get_it.dart';
import 'package:medihub/core/services/local_notification_service.dart';
import 'package:medihub/features/appointments/data/repositories/appointment_repository.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:medihub/features/appointments/presentation/cubit/booking_cubit.dart';
import 'package:medihub/features/auth/data/services/supabase_auth_service.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/doctor/data/repositories/doctor_repository.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_list_cubit.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_profile_cubit.dart';
import 'package:medihub/features/prescription/data/repositories/prescription_repository.dart';
import 'package:medihub/features/prescription/presentation/cubit/prescription_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (!sl.isRegistered<LocalNotificationService>()) {
    sl.registerLazySingleton<LocalNotificationService>(
      () => LocalNotificationService(),
    );
  }

  if (!sl.isRegistered<SupabaseAuthService>()) {
    sl.registerLazySingleton<SupabaseAuthService>(() => SupabaseAuthService());
  }

  if (!sl.isRegistered<DoctorRepository>()) {
    sl.registerLazySingleton<DoctorRepository>(() => DoctorRepository());
  }

  if (!sl.isRegistered<AppointmentRepository>()) {
    sl.registerLazySingleton<AppointmentRepository>(
      () => AppointmentRepository(),
    );
  }

  if (!sl.isRegistered<PrescriptionRepository>()) {
    sl.registerLazySingleton<PrescriptionRepository>(
      () => PrescriptionRepository(),
    );
  }

  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerFactory<AuthCubit>(
      () => AuthCubit(
        auth: sl<SupabaseAuthService>(),
        doctorRepo: sl<DoctorRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<DoctorListCubit>()) {
    sl.registerFactory<DoctorListCubit>(
      () => DoctorListCubit(repo: sl<DoctorRepository>()),
    );
  }

  if (!sl.isRegistered<DoctorProfileCubit>()) {
    sl.registerFactory<DoctorProfileCubit>(
      () => DoctorProfileCubit(
        repo: sl<DoctorRepository>(),
        auth: sl<SupabaseAuthService>(),
      ),
    );
  }

  if (!sl.isRegistered<AppointmentsCubit>()) {
    sl.registerFactory<AppointmentsCubit>(
      () => AppointmentsCubit(
        appointmentRepo: sl<AppointmentRepository>(),
        prescriptionRepo: sl<PrescriptionRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<BookingCubit>()) {
    sl.registerFactory<BookingCubit>(
      () => BookingCubit(
        appointmentRepo: sl<AppointmentRepository>(),
        doctorRepo: sl<DoctorRepository>(),
        notifications: sl<LocalNotificationService>(),
      ),
    );
  }

  if (!sl.isRegistered<PrescriptionCubit>()) {
    sl.registerFactory<PrescriptionCubit>(
      () => PrescriptionCubit(repo: sl<PrescriptionRepository>()),
    );
  }
}
