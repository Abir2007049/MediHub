import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/features/patient/presentation/widgets/appointment_list.dart';

class PatientHistoryScreen extends StatefulWidget {
  const PatientHistoryScreen({super.key});

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen>
    with SingleTickerProviderStateMixin {
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _primary => _colors.primary;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final authState = context.read<AuthCubit>().state;
    String? patientId;
    if (authState is AuthenticatedAsPatient) {
      patientId = authState.profile.id;
    } else {
      patientId = context.read<AuthCubit>().currentUserId;
    }
    if (patientId != null) {
      context.read<AppointmentsCubit>().loadPatientAppointments(patientId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Appointments'),
        backgroundColor: _colors.surface,
        foregroundColor: _primary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: _primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _primary,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {
          if (state is AppointmentsLoading || state is AppointmentsInitial) {
            return Center(child: CircularProgressIndicator(color: _primary));
          }
          if (state is AppointmentsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          if (state is AppointmentsLoaded) {
            final now = DateTime.now();
            final appointments = state.appointments.whereType<Appointment>();
            final upcoming = appointments
                .where(
                  (a) =>
                      a.status == 'confirmed' &&
                      (a.slotTime?.isAfter(now) ?? true),
                )
                .toList();
            final past = appointments
                .where(
                  (a) =>
                      a.status != 'confirmed' ||
                      (a.slotTime != null && a.slotTime!.isBefore(now)),
                )
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                AppointmentList(
                  list: upcoming,
                  state: state,
                  isEmptyMessage: 'No upcoming appointments',
                ),
                AppointmentList(
                  list: past,
                  state: state,
                  isEmptyMessage: 'No past appointments',
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
