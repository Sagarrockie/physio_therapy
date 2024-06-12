import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/doctor_profile_controller.dart';

class DoctorDetailsPage extends ConsumerWidget {
  const DoctorDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctor = ref.watch(doctorControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: doctor == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
                    child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/doctor.jpeg'),
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    doctor.docname,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor.qualification,
                    style: const TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoctorInfoRow(
                            label: 'Experience', value: doctor.experience),
                        DoctorInfoRow(label: 'Mobile', value: doctor.docmobile),
                        DoctorInfoRow(
                            label: 'Specialization',
                            value: doctor.specialization),
                        DoctorInfoRow(
                            label: 'Username', value: doctor.docusername),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class DoctorInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const DoctorInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
