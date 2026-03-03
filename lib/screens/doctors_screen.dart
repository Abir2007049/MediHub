import 'package:flutter/material.dart';

class DoctorsScreen extends StatelessWidget {
  final String? searchQuery;
  final bool showSuggestions;

  const DoctorsScreen({Key? key, this.searchQuery, this.showSuggestions = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy doctor data for UI demonstration
    final doctors = [
      {'name': 'Dr. Ayesha Rahman', 'specialization': 'Cardiologist', 'distance': '1.2 km'},
      {'name': 'Dr. Imran Hossain', 'specialization': 'Dermatologist', 'distance': '2.5 km'},
      {'name': 'Dr. Nusrat Jahan', 'specialization': 'Pediatrician', 'distance': '0.8 km'},
      {'name': 'Dr. Tanvir Ahmed', 'specialization': 'Orthopedic', 'distance': '3.1 km'},
    ];

    final filteredDoctors = searchQuery == null || searchQuery!.isEmpty
        ? doctors
        : doctors.where((doc) =>
            doc['name']!.toLowerCase().contains(searchQuery!.toLowerCase()) ||
            doc['specialization']!.toLowerCase().contains(searchQuery!.toLowerCase())
          ).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (showSuggestions)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Suggestions for you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
        ...filteredDoctors.map((doc) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.15),
                  child: const Icon(Icons.person, color: Colors.green),
                ),
                title: Text(doc['name']!),
                subtitle: Text('${doc['specialization']} • ${doc['distance']}'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // TODO: Show doctor profile/details
                  },
                  child: const Text('View'),
                ),
              ),
            )),
        if (filteredDoctors.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text('No doctors found.')),
          ),
      ],
    );
  }
}
