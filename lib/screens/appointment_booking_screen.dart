import 'package:flutter/material.dart';
import 'payment_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const AppointmentBookingScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  String? _selectedDay;
  int? _selectedSerialNumber;

  // Demo schedule data - will be replaced with backend API
  final Map<String, Map<String, dynamic>> _weeklySchedule = {
    'Saturday': {
      'timeRange': '4:00 PM - 8:00 PM',
      'totalSeats': 40,
      'bookedSeats': [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39], // Demo: 20 booked
    },
    'Sunday': {
      'timeRange': '10:00 AM - 2:00 PM',
      'totalSeats': 30,
      'bookedSeats': [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30], // Demo: 15 booked
    },
    'Monday': {
      'timeRange': '2:00 PM - 6:00 PM',
      'totalSeats': 35,
      'bookedSeats': [1, 5, 9, 13, 17, 21, 25, 29, 33], // Demo: 9 booked
    },
    'Tuesday': {
      'timeRange': 'Closed',
      'totalSeats': 0,
      'bookedSeats': [],
    },
    'Wednesday': {
      'timeRange': '3:00 PM - 7:00 PM',
      'totalSeats': 25,
      'bookedSeats': [3, 7, 11, 15, 19, 23], // Demo: 6 booked
    },
    'Thursday': {
      'timeRange': '10:00 AM - 1:00 PM',
      'totalSeats': 20,
      'bookedSeats': [2, 6, 10, 14, 18], // Demo: 5 booked
    },
    'Friday': {
      'timeRange': 'Closed',
      'totalSeats': 0,
      'bookedSeats': [],
    },
  };

  // Calculate time subsections (10 patients per hour = 6 minutes per patient)
  List<Map<String, dynamic>> _calculateTimeSlots(String timeRange, int totalSeats) {
    if (timeRange == 'Closed' || totalSeats == 0) return [];

    final parts = timeRange.split(' - ');
    if (parts.length != 2) return [];

    // Parse start and end times
    final startTime = _parseTime(parts[0].trim());
    final endTime = _parseTime(parts[1].trim());

    if (startTime == null || endTime == null) return [];

    // Calculate total hours
    int totalMinutes = (endTime['hour']! - startTime['hour']!) * 60 +
        (endTime['minute']! - startTime['minute']!);

    // Each subsection is 1 hour (10 patients at 6 minutes each)
    final int patientsPerHour = 10;
    List<Map<String, dynamic>> subsections = [];

    int currentHour = startTime['hour']!;
    int currentMinute = startTime['minute']!;
    int serialStart = 1;

    while (serialStart <= totalSeats) {
      final nextHour = currentHour + 1;
      final serialEnd = (serialStart + patientsPerHour - 1).clamp(1, totalSeats);

      subsections.add({
        'timeLabel': '${_formatTime(currentHour, currentMinute)} - ${_formatTime(nextHour, currentMinute)}',
        'serialStart': serialStart,
        'serialEnd': serialEnd,
      });

      serialStart = serialEnd + 1;
      currentHour = nextHour;
    }

    return subsections;
  }

  Map<String, int>? _parseTime(String timeStr) {
    try {
      final regex = RegExp(r'(\d+):(\d+)\s*(AM|PM)', caseSensitive: false);
      final match = regex.firstMatch(timeStr);
      if (match == null) return null;

      int hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final period = match.group(3)!.toUpperCase();

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return {'hour': hour, 'minute': minute};
    } catch (e) {
      return null;
    }
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
  }

  String? getApproximateTime(int serialNumber, String timeRange, int totalSeats) {
    final subsections = _calculateTimeSlots(timeRange, totalSeats);
    for (var subsection in subsections) {
      if (serialNumber >= subsection['serialStart'] && serialNumber <= subsection['serialEnd']) {
        return subsection['timeLabel'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedSchedule = _selectedDay != null ? _weeklySchedule[_selectedDay!] : null;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Doctor Info Card - Compact Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade100, width: 2),
                  ),
                  child: widget.doctor['image'] != null
                      ? CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(widget.doctor['image']),
                        )
                      : CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.green.shade50,
                          child: const Icon(Icons.person, size: 28, color: Colors.green),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor['name'] ?? 'Doctor',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.doctor['specialization'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${widget.doctor['degree'] ?? 'MBBS'} - ${widget.doctor['medicalCollege'] ?? 'Medical College'}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Day Selector - Horizontal Scrollable
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Select Day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _weeklySchedule.length,
                    itemBuilder: (context, index) {
                      final day = _weeklySchedule.keys.elementAt(index);
                      final schedule = _weeklySchedule[day]!;
                      final isClosed = schedule['totalSeats'] == 0;
                      final isSelected = _selectedDay == day;
                      final totalSeats = schedule['totalSeats'] as int;
                      final bookedSeats = schedule['bookedSeats'] as List<int>;
                      final availableSeats = totalSeats - bookedSeats.length;

                      return GestureDetector(
                        onTap: isClosed ? null : () {
                          setState(() {
                            _selectedDay = day;
                            _selectedSerialNumber = null; // Reset selection
                          });
                        },
                        child: Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [Colors.green.shade400, Colors.green.shade600],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isSelected ? null : (isClosed ? Colors.grey.shade100 : Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green.shade700
                                  : (isClosed ? Colors.grey.shade300 : Colors.green.shade200),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isClosed ? Icons.cancel_outlined : Icons.calendar_today_rounded,
                                color: isSelected
                                    ? Colors.white
                                    : (isClosed ? Colors.grey : Colors.green),
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                day.substring(0, 3),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : (isClosed ? Colors.grey : Colors.black87),
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (!isClosed)
                                Text(
                                  '$availableSeats slots',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                  ),
                                ),
                              if (isClosed)
                                Text(
                                  'Closed',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Time Slots Section
          Expanded(
            child: _selectedDay == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select a day to view available slots',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Schedule Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green.shade50, Colors.green.shade100],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.schedule,
                                  color: Colors.green,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedDay!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectedSchedule!['timeRange'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegendItem(Colors.green.shade100, Colors.green, 'Available'),
                            const SizedBox(width: 24),
                            _buildLegendItem(Colors.red.shade100, Colors.red, 'Booked'),
                            const SizedBox(width: 24),
                            _buildLegendItem(Colors.green.shade500, Colors.green.shade900, 'Selected'),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Time Slots Grid
                        _buildTimeSlotsGrid(selectedSchedule),
                      ],
                    ),
                  ),
          ),
          
          // Confirm Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedSerialNumber != null && _selectedDay != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$_selectedDay - Serial #$_selectedSerialNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                if (getApproximateTime(
                                      _selectedSerialNumber!,
                                      selectedSchedule!['timeRange'],
                                      selectedSchedule['totalSeats'],
                                    ) !=
                                    null)
                                  Text(
                                    'Approx: ${getApproximateTime(_selectedSerialNumber!, selectedSchedule['timeRange'], selectedSchedule['totalSeats'])}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _selectedDay != null && _selectedSerialNumber != null
                        ? () {
                            final approximateTime = getApproximateTime(
                              _selectedSerialNumber!,
                              selectedSchedule!['timeRange'],
                              selectedSchedule['totalSeats'],
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                  doctor: widget.doctor,
                                  selectedDay: _selectedDay!,
                                  selectedSerialNumber: _selectedSerialNumber!,
                                  approximateTime: approximateTime,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Confirm & Proceed to Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color bgColor, Color borderColor, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotsGrid(Map<String, dynamic> schedule) {
    final totalSeats = schedule['totalSeats'] as int;
    final bookedSeats = schedule['bookedSeats'] as List<int>;
    final timeRange = schedule['timeRange'] as String;
    
    final subsections = _calculateTimeSlots(timeRange, totalSeats);

    if (subsections.isEmpty && totalSeats > 0) {
      // Fallback simple grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemCount: totalSeats,
        itemBuilder: (context, index) {
          final serialNumber = index + 1;
          final isBooked = bookedSeats.contains(serialNumber);
          final isSelected = _selectedSerialNumber == serialNumber;

          return _buildSerialButton(serialNumber, isBooked, isSelected);
        },
      );
    }

    // Subsections with time labels
    return Column(
      children: subsections.map((subsection) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade500],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    subsection['timeLabel'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Serial ${subsection['serialStart']}-${subsection['serialEnd']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Serial Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemCount: subsection['serialEnd'] - subsection['serialStart'] + 1,
              itemBuilder: (context, index) {
                final serialNumber = subsection['serialStart'] + index;
                final isBooked = bookedSeats.contains(serialNumber);
                final isSelected = _selectedSerialNumber == serialNumber;

                return _buildSerialButton(serialNumber, isBooked, isSelected);
              },
            ),
            
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSerialButton(int serialNumber, bool isBooked, bool isSelected) {
    return GestureDetector(
      onTap: isBooked
          ? null
          : () {
              setState(() {
                _selectedSerialNumber = serialNumber;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.green.shade400, Colors.green.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isBooked
              ? Colors.red.shade100
              : (isSelected ? null : Colors.green.shade50),
          border: Border.all(
            color: isBooked
                ? Colors.red.shade400
                : (isSelected ? Colors.green.shade700 : Colors.green.shade300),
            width: isSelected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                serialNumber.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isBooked
                      ? Colors.red.shade900
                      : (isSelected ? Colors.white : Colors.green.shade900),
                  fontSize: 16,
                ),
              ),
              if (isBooked)
                Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.red.shade900,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
