import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Services/secureStorage.dart';
import '../controller/my_appointments_controller.dart';
import '../model/my_appointments_model.dart';

class MyBookingsScreenDoc extends StatelessWidget {
  final SecureStorage secureStorage = SecureStorage();

  MyBookingsScreenDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'My Appointments',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final appointmentsController =
              watch.watch(appointmentsControllerProvider);
          final appointments = appointmentsController.appointments;
          final docname = appointmentsController.docname;

          return appointments.isEmpty
              ? const Center(
                  child: Text(
                    "No Appointments to accept",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    return _buildBookingCard(context, appointments[index],
                        docname, appointmentsController);
                  },
                );
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Appointment appointment,
      String docname, AppointmentsController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Doctor Name: $docname",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Referred By: ${appointment.doctor.name}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              if (appointment.username != null) ...[
                Text(
                  "Username: ${appointment.username}",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                "Date: ${appointment.date}",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              if (appointment.link != null) ...[
                GestureDetector(
                  onTap: () {
                    controller.launchURL(appointment.link!);
                  },
                  child: Text(
                    "Link : ${appointment.link!}",
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.confirmAppointment(appointment);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Confirm Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showCancelConfirmationDialog(
                          context, appointment, controller);
                    },
                    child: const Text(
                      'Cancel Appointment',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context,
      Appointment appointment, AppointmentsController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Cancel'),
          content: Text(
              'Do you want to cancel the appointment with ${appointment.doctor.name}?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                controller.cancelAppointment(appointment);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Appointment with ${appointment.doctor.name} on ${appointment.date} canceled.'),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
