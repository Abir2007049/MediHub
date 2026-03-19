import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:medihub/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool hasPrescription;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.hasPrescription,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final primaryContainer = colorScheme.primaryContainer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: hasPrescription && appointment.id != null
              ? () {
                  final state = context.read<AppointmentsCubit>().state;
                  if (state is AppointmentsLoaded) {
                    final p = state.prescriptions[appointment.id!];
                    if (p != null) {
                      context.push(
                        '/patient/history/prescription',
                        extra: {'prescription': p, 'appointment': appointment},
                      );
                    }
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: primaryContainer.withOpacity(0.5),
                      child: Icon(Icons.person, color: primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName ?? 'Doctor',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            appointment.specialization ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(
                      status: appointment.status,
                      primary: primary,
                      primaryContainer: primaryContainer,
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _DetailItem(
                      icon: Icons.calendar_today,
                      text: appointment.selectedDay,
                    ),
                    const SizedBox(width: 16),
                    _DetailItem(
                      icon: Icons.confirmation_number,
                      text: 'Serial #${appointment.serialNumber}',
                    ),
                    if (appointment.approximateTime != null) ...[
                      const SizedBox(width: 16),
                      _DetailItem(
                        icon: Icons.access_time,
                        text: appointment.approximateTime!,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _DetailItem(
                      icon: Icons.location_on,
                      text: appointment.location ?? '',
                    ),
                    const Spacer(),
                    Text(
                      '৳${appointment.consultationFee}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                if (hasPrescription) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.description,
                          size: 14,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'View Prescription',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (appointment.isFollowUp) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.replay,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Follow-up',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final Color primary;
  final Color primaryContainer;

  const _StatusChip({
    required this.status,
    required this.primary,
    required this.primaryContainer,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;
    switch (status) {
      case 'confirmed':
        bg = primaryContainer.withOpacity(0.5);
        fg = primary;
        border = primary.withOpacity(0.2);
        break;
      case 'completed':
        bg = Colors.blue.shade50.withOpacity(0.5);
        fg = Colors.blue.shade700;
        border = Colors.blue.shade200;
        break;
      case 'cancelled':
        bg = Colors.red.shade50.withOpacity(0.5);
        fg = Colors.red.shade700;
        border = Colors.red.shade200;
        break;
      default:
        bg = Colors.grey.shade50;
        fg = Colors.grey.shade700;
        border = Colors.grey.shade300;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        status.substring(0, 1).toUpperCase() + status.substring(1),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      ],
    );
  }
}
