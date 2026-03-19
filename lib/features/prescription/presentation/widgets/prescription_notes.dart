import 'package:flutter/material.dart';
import 'package:medihub/features/prescription/presentation/widgets/medicines_list.dart';

class PrescriptionNotes extends StatelessWidget {
  final String? notes;

  const PrescriptionNotes({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes == null || notes!.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Notes'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            notes!,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
