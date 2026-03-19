import 'package:flutter/material.dart';
import 'package:medihub/models/doctor_profile.dart';
import 'package:medihub/features/patient/presentation/widgets/doctor_card.dart';

class DoctorSearchDelegate extends SearchDelegate<DoctorProfile?> {
  final List<DoctorProfile> doctors;
  final Map<String, double> doctorRatings;

  DoctorSearchDelegate({required this.doctors, required this.doctorRatings});

  @override
  String get searchFieldLabel => 'Search doctors, specializations...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) return null;
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filterDoctors();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No doctors found for "$query"',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return DoctorCard(
          doctor: results[index],
          index: index,
          doctorRatings: doctorRatings,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Type to search for doctors',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    final suggestions = _filterDoctors();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return DoctorCard(
          doctor: suggestions[index],
          index: index,
          doctorRatings: doctorRatings,
        );
      },
    );
  }

  List<DoctorProfile> _filterDoctors() {
    final lowerQuery = query.toLowerCase();
    return doctors.where((d) {
      return d.fullName.toLowerCase().contains(lowerQuery) ||
          (d.specialization?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}
