import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/models/prescription.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const String _bookingChannelId = 'medihub_booking_updates';
  static const String _bookingChannelName = 'Booking Updates';
  static const String _bookingChannelDescription =
      'Booking confirmations and updates';

  static const String _reminderChannelId = 'medihub_appointment_reminders';
  static const String _reminderChannelName = 'Appointment Reminders';
  static const String _reminderChannelDescription =
      'Upcoming appointment and follow-up reminders';

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(settings: settings);
    await _requestPermissions();

    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  NotificationDetails get _bookingDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _bookingChannelId,
        _bookingChannelName,
        channelDescription: _bookingChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
  }

  NotificationDetails get _reminderDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _reminderChannelId,
        _reminderChannelName,
        channelDescription: _reminderChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
  }

  int _notificationId(String seed, {int offset = 0}) {
    final value = (seed.hashCode & 0x7fffffff) % 1000000000;
    return value + offset;
  }

  Future<void> notifyAppointmentBooked(Appointment appointment) async {
    await initialize();

    final seed =
        'appointment_${appointment.id ?? appointment.createdAt?.toIso8601String() ?? appointment.selectedDay}_${appointment.serialNumber}';
    final dateTime =
        appointment.slotTime ??
        estimateAppointmentDateTime(
          selectedDay: appointment.selectedDay,
          approximateTime: appointment.approximateTime,
        );

    final title = 'Appointment Confirmed';
    final body =
        'Serial #${appointment.serialNumber} with ${appointment.doctorName ?? 'doctor'} on ${appointment.selectedDay}${appointment.approximateTime != null ? ' at ${appointment.approximateTime}' : ''}.';

    await _plugin.show(
      id: _notificationId(seed),
      title: title,
      body: body,
      notificationDetails: _bookingDetails,
      payload: appointment.id,
    );

    if (dateTime != null) {
      await _scheduleAppointmentReminders(
        seed: seed,
        doctorName: appointment.doctorName,
        dateTime: dateTime,
      );
    }
  }

  Future<void> notifyFollowUpBooked(Prescription prescription) async {
    await initialize();

    final seed =
        'followup_${prescription.id ?? prescription.appointmentId}_${prescription.patientId}';
    final followUpDateTime = _parseFollowUpDate(prescription.followUpDate);

    final bookedBody = followUpDateTime != null
        ? 'Follow-up reminder set for ${DateFormat('dd MMM yyyy').format(followUpDateTime)}.'
        : 'Your follow-up has been marked as booked.';

    await _plugin.show(
      id: _notificationId(seed),
      title: 'Follow-up Booked',
      body: bookedBody,
      notificationDetails: _bookingDetails,
      payload: prescription.id,
    );

    if (followUpDateTime == null) return;

    final oneDayBefore = followUpDateTime.subtract(const Duration(days: 1));
    await _scheduleIfFuture(
      id: _notificationId(seed, offset: 1),
      title: 'Follow-up Tomorrow',
      body:
          'Your follow-up with ${prescription.doctorName ?? 'your doctor'} is tomorrow.',
      scheduledAt: DateTime(
        oneDayBefore.year,
        oneDayBefore.month,
        oneDayBefore.day,
        9,
      ),
      payload: prescription.id,
    );

    await _scheduleIfFuture(
      id: _notificationId(seed, offset: 2),
      title: 'Follow-up Today',
      body:
          'You have a follow-up with ${prescription.doctorName ?? 'your doctor'} today.',
      scheduledAt: DateTime(
        followUpDateTime.year,
        followUpDateTime.month,
        followUpDateTime.day,
        8,
      ),
      payload: prescription.id,
    );
  }

  DateTime? estimateAppointmentDateTime({
    required String selectedDay,
    String? approximateTime,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();

    final parsedDate = DateTime.tryParse(selectedDay);
    if (parsedDate != null) {
      final parsedTime = _parseTime(approximateTime);
      return DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedTime?.hour ?? 9,
        parsedTime?.minute ?? 0,
      );
    }

    final targetWeekday = _weekdayFromText(selectedDay);
    if (targetWeekday == null) return null;

    final parsedTime = _parseTime(approximateTime);
    final hour = parsedTime?.hour ?? 9;
    final minute = parsedTime?.minute ?? 0;

    var daysAhead = (targetWeekday - reference.weekday + 7) % 7;
    var candidate = DateTime(
      reference.year,
      reference.month,
      reference.day,
      hour,
      minute,
    ).add(Duration(days: daysAhead));

    if (!candidate.isAfter(reference.add(const Duration(minutes: 5)))) {
      candidate = candidate.add(const Duration(days: 7));
    }

    return candidate;
  }

  Future<void> _scheduleAppointmentReminders({
    required String seed,
    required DateTime dateTime,
    String? doctorName,
  }) async {
    await _scheduleIfFuture(
      id: _notificationId(seed, offset: 10),
      title: 'Appointment Tomorrow',
      body:
          'You have an appointment with ${doctorName ?? 'your doctor'} tomorrow.',
      scheduledAt: dateTime.subtract(const Duration(days: 1)),
      payload: seed,
    );

    await _scheduleIfFuture(
      id: _notificationId(seed, offset: 11),
      title: 'Appointment in 1 hour',
      body:
          'Your appointment with ${doctorName ?? 'your doctor'} starts in about 1 hour.',
      scheduledAt: dateTime.subtract(const Duration(hours: 1)),
      payload: seed,
    );
  }

  Future<void> _scheduleIfFuture({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) async {
    final now = DateTime.now();
    if (!scheduledAt.isAfter(now.add(const Duration(seconds: 5)))) {
      return;
    }

    final scheduledDate = tz.TZDateTime.from(scheduledAt, tz.local);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: _reminderDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  DateTime? _parseFollowUpDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final value = raw.trim();

    final iso = DateTime.tryParse(value);
    if (iso != null) return iso;

    final formats = <DateFormat>[
      DateFormat('dd/MM/yyyy'),
      DateFormat('d/M/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('d-M-yyyy'),
      DateFormat('dd MMM yyyy'),
      DateFormat('d MMM yyyy'),
      DateFormat('MMM d, yyyy'),
      DateFormat('MMMM d, yyyy'),
    ];

    for (final format in formats) {
      try {
        return format.parseStrict(value);
      } catch (_) {}
    }

    final lowered = value.toLowerCase();
    final relativeMatch = RegExp(
      r'(?:after\s*)?(\d+)\s*(day|days|week|weeks|month|months)',
    ).firstMatch(lowered);

    if (relativeMatch == null) return null;

    final amount = int.tryParse(relativeMatch.group(1) ?? '');
    final unit = relativeMatch.group(2);
    if (amount == null || amount <= 0 || unit == null) return null;

    if (unit.startsWith('day')) {
      return DateTime.now().add(Duration(days: amount));
    }

    if (unit.startsWith('week')) {
      return DateTime.now().add(Duration(days: amount * 7));
    }

    if (unit.startsWith('month')) {
      return DateTime.now().add(Duration(days: amount * 30));
    }

    return null;
  }

  DateTime? _parseTime(String? rawTime) {
    if (rawTime == null || rawTime.trim().isEmpty) return null;

    final normalized = rawTime.trim().toUpperCase();
    final formats = <DateFormat>[DateFormat('h:mm a'), DateFormat('h a')];

    for (final format in formats) {
      try {
        final parsed = format.parseStrict(normalized);
        return DateTime(2000, 1, 1, parsed.hour, parsed.minute);
      } catch (_) {}
    }

    final match = RegExp(
      r'^(\d{1,2})(?::(\d{2}))?\s*(AM|PM)$',
      caseSensitive: false,
    ).firstMatch(normalized);
    if (match == null) return null;

    var hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '0');
    final period = (match.group(3) ?? '').toUpperCase();

    if (hour == null || minute == null) return null;
    if (hour < 1 || hour > 12 || minute < 0 || minute > 59) return null;

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return DateTime(2000, 1, 1, hour, minute);
  }

  int? _weekdayFromText(String selectedDay) {
    final value = selectedDay.trim().toLowerCase();
    const mapping = <String, int>{
      'monday': DateTime.monday,
      'mon': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'tue': DateTime.tuesday,
      'tues': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'wed': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'thu': DateTime.thursday,
      'thur': DateTime.thursday,
      'thurs': DateTime.thursday,
      'friday': DateTime.friday,
      'fri': DateTime.friday,
      'saturday': DateTime.saturday,
      'sat': DateTime.saturday,
      'sunday': DateTime.sunday,
      'sun': DateTime.sunday,
    };
    return mapping[value];
  }

  @visibleForTesting
  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }
}
