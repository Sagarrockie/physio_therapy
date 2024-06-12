import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newphysio/Screens/User/My%20Bookings/model/user_my_bookings_model.dart';
import '../controller/user_my_bookings_controller.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(appointmentControllerProvider.notifier).fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final appointments = ref.watch(appointmentControllerProvider);
    final isLoading = appointments.isEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'My Bookings',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return _buildBookingCard(appointments[index]);
              },
            ),
    );
  }

  Widget _buildBookingCard(Appointment appointment) {
    Color statusColor = Colors.white;
    String statusText = "Unknown";

    if (appointment.status == "Y") {
      statusColor = Colors.green;
      statusText = "Confirmed";
    } else if (appointment.status == "N") {
      statusColor = Colors.red;
      statusText = "Pending";
    }

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
                'Appointment ID: ${appointment.appid}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Doctor ID: ${appointment.doctor.docid}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Doctor Name: ${appointment.doctor.name}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Referred By: ${appointment.doctor.referredby}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${appointment.date.year}-${appointment.date.month}-${appointment.date.day}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Slot: ${appointment.slot}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: $statusText',
                style: TextStyle(fontSize: 16, color: statusColor),
              ),
              const SizedBox(height: 16),
              if (appointment.status == "Y")
                ElevatedButton(
                  onPressed: () => _showFeedbackDialog(appointment),
                  child: const Text('Add Review'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog(Appointment appointment) async {
    double rating = 0; // Default rating value

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Rate the doctor:'),
                  Slider(
                    value: rating,
                    onChanged: (newRating) {
                      setState(() => rating = newRating);
                    },
                    divisions: 4,
                    label: rating.toString(),
                    min: 0,
                    max: 5,
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                ref
                    .read(appointmentControllerProvider.notifier)
                    .submitFeedback(appointment, rating.toInt());
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
