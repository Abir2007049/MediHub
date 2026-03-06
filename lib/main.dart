import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'blocs/auth/auth_cubit.dart';
import 'blocs/doctor_list/doctor_list_cubit.dart';
import 'blocs/doctor_profile/doctor_profile_cubit.dart';
import 'blocs/appointments/appointments_cubit.dart';
import 'blocs/booking/booking_cubit.dart';
import 'blocs/prescription/prescription_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'SUPABASE_URL',
    anonKey: 'SUPABASE_KEY',
  );

  runApp(const MediHubApp());
}

class MediHubApp extends StatelessWidget {
  const MediHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => DoctorListCubit()),
        BlocProvider(create: (_) => DoctorProfileCubit()),
        BlocProvider(create: (_) => AppointmentsCubit()),
        BlocProvider(create: (_) => BookingCubit()),
        BlocProvider(create: (_) => PrescriptionCubit()),
      ],
      child: MaterialApp.router(
        title: 'MediHub',
        theme: getAppTheme(),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
