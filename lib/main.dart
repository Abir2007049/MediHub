import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'models/env.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/doctor/presentation/cubit/doctor_list_cubit.dart';
import 'features/doctor/presentation/cubit/doctor_profile_cubit.dart';
import 'features/appointments/presentation/cubit/appointments_cubit.dart';
import 'features/appointments/presentation/cubit/booking_cubit.dart';
import 'features/prescription/presentation/cubit/prescription_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);

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
