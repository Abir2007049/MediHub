import 'package:flutter/material.dart';
import 'package:medihub/models/prescription.dart';

class FollowUpSection extends StatelessWidget {
  final Prescription prescription;
  final VoidCallback onBookFollowUp;

  const FollowUpSection({
    super.key,
    required this.prescription,
    required this.onBookFollowUp,
  });

  @override
  Widget build(BuildContext context) {
    if (!prescription.hasFollowUp) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_repeat, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                'Follow-up Required',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          if (prescription.followUpDate != null) ...[
            const SizedBox(height: 8),
            Text(
              'Date: ${prescription.followUpDate}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
          if (prescription.followUpFee != null) ...[
            const SizedBox(height: 4),
            Text(
              'Fee: ৳${prescription.followUpFee}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
          const SizedBox(height: 12),
          if (!prescription.followUpBooked)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onBookFollowUp,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: const Text('Book Follow-up'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Follow-up Booked',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
