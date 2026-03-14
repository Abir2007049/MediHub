import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:medihub/features/auth/presentation/cubit/auth_state.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_profile_cubit.dart';
import 'package:medihub/features/doctor/presentation/cubit/doctor_profile_state.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:medihub/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:medihub/models/appointment.dart';

class DoctorHistoryScreen extends StatefulWidget {
  const DoctorHistoryScreen({super.key});

  @override
  State<DoctorHistoryScreen> createState() => _DoctorHistoryScreenState();
}

class _DoctorHistoryScreenState extends State<DoctorHistoryScreen>
    with SingleTickerProviderStateMixin {
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _primary => _colors.primary;
  Color get _primaryContainer => _colors.primaryContainer;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final doctorId = _getDoctorId();
    if (doctorId != null) {
      context.read<AppointmentsCubit>().loadDoctorAppointments(doctorId);
    }
  }

  String? _getDoctorId() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthenticatedAsDoctor) return authState.profile.id;
    // Fallback to profile cubit
    final profileState = context.read<DoctorProfileCubit>().state;
    if (profileState is DoctorProfileLoaded) return profileState.profile.id;
    return context.read<AuthCubit>().currentUserId;
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
        title: const Text('Patient Appointments'),
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
            final upcoming = state.appointments
                .where(
                  (a) =>
                      a.status == 'confirmed' &&
                      (a.slotTime?.isAfter(now) ?? true),
                )
                .toList();
            final past = state.appointments
                .where(
                  (a) =>
                      a.status != 'confirmed' ||
                      (a.slotTime != null && a.slotTime!.isBefore(now)),
                )
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildList(
                  upcoming,
                  state,
                  isEmpty: 'No upcoming appointments',
                ),
                _buildList(past, state, isEmpty: 'No past appointments'),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildList(
    List<Appointment> list,
    AppointmentsLoaded state, {
    required String isEmpty,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              isEmpty,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final doctorId = _getDoctorId();
        if (doctorId != null) {
          await context.read<AppointmentsCubit>().loadDoctorAppointments(
            doctorId,
          );
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final a = list[index];
          final hasPrescription =
              a.id != null && state.prescriptions.containsKey(a.id);
          return _buildAppointmentCard(a, hasPrescription);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment a, bool hasPrescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/doctor/history/prescription', extra: a);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: _primaryContainer,
                      child: Icon(Icons.person, color: _primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.patientName ?? 'Patient',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (a.patientMobile != null)
                            Text(
                              a.patientMobile!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    _statusChip(a.status),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _detailItem(Icons.calendar_today, a.selectedDay),
                    const SizedBox(width: 16),
                    _detailItem(
                      Icons.confirmation_number,
                      'Serial #${a.serialNumber}',
                    ),
                    if (a.approximateTime != null) ...[
                      const SizedBox(width: 16),
                      _detailItem(Icons.access_time, a.approximateTime!),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (hasPrescription)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 14, color: _primary),
                            const SizedBox(width: 4),
                            Text(
                              'Prescribed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_note,
                              size: 14,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Write Prescription',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    if (a.isFollowUp)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Follow-up',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'confirmed':
        bg = _primaryContainer;
        fg = _primary;
        break;
      case 'completed':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade700;
        break;
      case 'cancelled':
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.substring(0, 1).toUpperCase() + status.substring(1),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }

  Widget _detailItem(IconData icon, String text) {
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
