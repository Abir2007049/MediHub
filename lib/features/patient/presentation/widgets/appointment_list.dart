import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/features/patient/presentation/widgets/appointment_card.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> list;
  final AppointmentsLoaded state;
  final String isEmptyMessage;

  const AppointmentList({
    super.key,
    required this.list,
    required this.state,
    required this.isEmptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              isEmptyMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final authState = context.read<AuthCubit>().state;
        String? pid;
        if (authState is AuthenticatedAsPatient) {
          pid = authState.profile.id;
        } else {
          pid = context.read<AuthCubit>().currentUserId;
        }
        if (pid != null) {
          await context.read<AppointmentsCubit>().loadPatientAppointments(pid);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final a = list[index];
          final prescription = a.id != null ? state.prescriptions[a.id!] : null;
          return AppointmentCard(
            appointment: a,
            hasPrescription: prescription != null,
          );
        },
      ),
    );
  }
}
