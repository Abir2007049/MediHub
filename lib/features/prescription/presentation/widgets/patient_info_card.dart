import 'package:flutter/material.dart';
import 'package:medihub/models/appointment.dart';
import 'package:medihub/models/prescription.dart';

class PatientInfoCard extends StatelessWidget {
  final Prescription prescription;
  final Appointment appointment;

  const PatientInfoCard({
    super.key,
    required this.prescription,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(Icons.person, color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prescription.patientName ??
                      appointment.patientName ??
                      'Patient',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (prescription.patientMobile != null ||
                    appointment.patientMobile != null)
                  Text(
                    prescription.patientMobile ??
                        appointment.patientMobile ??
                        '',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
