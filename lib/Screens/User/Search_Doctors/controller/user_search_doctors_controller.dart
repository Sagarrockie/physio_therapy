import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../model/user_search_doctor_model.dart';

final doctorControllerProvider = StateNotifierProvider<DoctorController, List<Doctor>>((ref) {
  return DoctorController();
});

class DoctorController extends StateNotifier<List<Doctor>> {
  DoctorController() : super([]);

  Future<void> fetchDoctors(String specialization) async {
    const String apiUrl = 'http://yhmysore.in/api/therapy/index.php';
    final response = await http.post(Uri.parse(apiUrl), body: {
      'tag': 'find',
      'specialization': specialization,
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      state = responseBody.map((data) => Doctor.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch doctors');
    }
  }

  Future<void> bookAppointment(
      BuildContext context,
      String uid,
      Doctor doctor,
      DateTime selectedDate,
      TimeOfDay selectedTime,
      String referralInfo,
      ) async {
    String formattedDate = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    String formattedTime = "${selectedTime.hour}.${selectedTime.minute}";
    const String apiUrl = 'http://yhmysore.in/api/therapy/index.php';
    final response = await http.post(Uri.parse(apiUrl), body: {
      'tag': 'appointment',
      'uid': uid,
      'docid': doctor.docId,
      'date': formattedDate,
      'slot': formattedTime,
      'referred': referralInfo,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      int error = responseBody['error'];
      String message = responseBody['message'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(error == 0 ? 'Appointment Booked!' : 'Error'),
            content: Text(message),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to book appointment. Please try again.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
