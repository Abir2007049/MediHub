import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medihub/features/appointments/presentation/cubit/booking_cubit.dart';
import 'package:medihub/features/appointments/presentation/cubit/booking_state.dart';
import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/models/doctor_schedule.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final DoctorProfile doctor;

  const AppointmentBookingScreen({super.key, required this.doctor});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  ColorScheme get _colors => Theme.of(context).colorScheme;
  Color get _primary => _colors.primary;
  Color get _primaryContainer => _colors.primaryContainer;

  String? _selectedDay;
  int? _selectedSerial;

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().loadSchedule(widget.doctor.id);
  }

  // ── Time helpers ──

  List<String> _calculateTimeSlots(
    String timeRange,
    int totalSeats,
    List<int> booked,
  ) {
    try {
      final parts = timeRange.split('-');
      if (parts.length != 2) return [];
      final start = _parseTime(parts[0].trim());
      final end = _parseTime(parts[1].trim());
      if (start == null || end == null) return [];

      final totalMinutes = end.difference(start).inMinutes;
      if (totalMinutes <= 0) return [];
      final slotMinutes = totalMinutes / totalSeats;

      return List.generate(totalSeats, (i) {
        final slot = start.add(Duration(minutes: (slotMinutes * i).round()));
        return _formatTime(slot);
      });
    } catch (_) {
      return [];
    }
  }

  DateTime? _parseTime(String t) {
    try {
      final lower = t.toLowerCase().replaceAll(' ', '');
      final isPM = lower.contains('pm');
      final isAM = lower.contains('am');
      final cleaned = lower.replaceAll('am', '').replaceAll('pm', '').trim();
      final parts = cleaned.split(':');
      var hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      if (isPM && hour < 12) hour += 12;
      if (isAM && hour == 12) hour = 0;
      return DateTime(2024, 1, 1, hour, minute);
    } catch (_) {
      return null;
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12
        ? dt.hour - 12
        : dt.hour == 0
        ? 12
        : dt.hour;
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  String? _getApproximateTime(String timeRange, int totalSeats, int serial) {
    final slots = _calculateTimeSlots(timeRange, totalSeats, []);
    if (serial > 0 && serial <= slots.length) {
      return slots[serial - 1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: _colors.surface,
        foregroundColor: _primary,
        elevation: 0,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookingLoadingSchedule || state is BookingInitial) {
            return Center(child: CircularProgressIndicator(color: _primary));
          }
          if (state is BookingError) {
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
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<BookingCubit>().loadSchedule(d.id),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is BookingScheduleLoaded) {
            return _buildBody(d, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(DoctorProfile d, BookingScheduleLoaded state) {
    final schedules = state.schedules;
    final bookedMap = state.bookedSerials;

    if (schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No schedule available for this doctor',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // Current schedule
    DoctorSchedule? currentSchedule;
    if (_selectedDay != null) {
      currentSchedule = schedules
          .where((s) => s.dayOfWeek == _selectedDay)
          .firstOrNull;
    }
    final booked = _selectedDay != null
        ? (bookedMap[_selectedDay] ?? <int>[])
        : <int>[];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor summary card
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _primaryContainer,
                    backgroundImage:
                        d.profileImage != null && d.profileImage!.isNotEmpty
                        ? NetworkImage(d.profileImage!)
                        : null,
                    child: d.profileImage == null || d.profileImage!.isEmpty
                        ? Icon(Icons.person, size: 30, color: _primary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.fullName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          d.specialization ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '৳${d.consultationFee}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: _primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Day selector
            Text(
              'Select Day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: schedules.map((s) {
                final isSelected = _selectedDay == s.dayOfWeek;
                return ChoiceChip(
                  label: Text(s.dayOfWeek),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedDay = s.dayOfWeek;
                      _selectedSerial = null;
                    });
                  },
                  selectedColor: _primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? _primary : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Time info
            if (currentSchedule != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _colors.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: _primary),
                    const SizedBox(width: 8),
                    Text(
                      '${currentSchedule.timeRange}  •  ${currentSchedule.totalSeats} seats',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Serial grid
              Text(
                'Select Serial',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: currentSchedule.totalSeats,
                itemBuilder: (context, index) {
                  final serial = index + 1;
                  final isBooked = booked.contains(serial);
                  final isSelected = _selectedSerial == serial;

                  return GestureDetector(
                    onTap: isBooked
                        ? null
                        : () => setState(() => _selectedSerial = serial),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.red.shade100
                            : isSelected
                            ? _primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isBooked
                              ? Colors.red.shade300
                              : isSelected
                              ? _primary
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: _primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$serial',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isBooked
                                  ? Colors.red.shade400
                                  : isSelected
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                          if (isBooked)
                            Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.red.shade400,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendDot(Colors.white, 'Available'),
                  const SizedBox(width: 16),
                  _legendDot(_primary, 'Selected'),
                  const SizedBox(width: 16),
                  _legendDot(Colors.red.shade100, 'Booked'),
                ],
              ),
            ],

            if (_selectedDay == null)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 50,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select a day to see available serials',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Continue button
            if (_selectedSerial != null && currentSchedule != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final approxTime = _getApproximateTime(
                      currentSchedule!.timeRange,
                      currentSchedule.totalSeats,
                      _selectedSerial!,
                    );
                    context.push(
                      '/patient/doctor-profile/book/payment',
                      extra: {
                        'doctor': widget.doctor,
                        'selectedDay': _selectedDay!,
                        'selectedSerialNumber': _selectedSerial!,
                        'approximateTime': approxTime,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Continue to Payment  •  Serial #$_selectedSerial',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade400, width: 0.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
