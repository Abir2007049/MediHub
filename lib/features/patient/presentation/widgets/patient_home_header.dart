import 'package:flutter/material.dart';
import 'package:medihub/features/patient/presentation/widgets/quick_stat_card.dart';

class PatientHomeHeader extends StatelessWidget {
  final int doctorCount;
  final int specCount;
  final double averageRating;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const PatientHomeHeader({
    super.key,
    required this.doctorCount,
    required this.specCount,
    required this.averageRating,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colorScheme.primaryContainer.withOpacity(0.3),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Your Doctor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Book appointments easily',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search doctors, specializations...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade400),
                        onPressed: () => onSearchChanged(''),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: QuickStatCard(
                  value: '$doctorCount',
                  label: 'Doctors',
                  icon: Icons.people_outline,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickStatCard(
                  value: '$specCount',
                  label: 'Specialists',
                  icon: Icons.local_hospital_outlined,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickStatCard(
                  value: averageRating > 0
                      ? averageRating.toStringAsFixed(1)
                      : '--',
                  label: 'Rating',
                  icon: Icons.star_outline,
                  color: Colors.amber.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
