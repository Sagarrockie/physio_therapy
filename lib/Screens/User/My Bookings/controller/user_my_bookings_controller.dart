import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/readerrevenuesubscriptionlinking/v1.dart';
import 'package:http/http.dart' as http;
import 'package:newphysio/Screens/User/My%20Bookings/model/user_my_bookings_model.dart';
import '../../../../Services/secureStorage.dart';

final appointmentControllerProvider =
    StateNotifierProvider<AppointmentController, List<Appointment>>(
  (ref) => AppointmentController(
      ref.read as Reader, ref.watch(navigatorKeyProvider)),
);

final navigatorKeyProvider =
    Provider<GlobalKey<NavigatorState>>((_) => GlobalKey<NavigatorState>());

class AppointmentController extends StateNotifier<List<Appointment>> {
  final Reader _read;
  final GlobalKey<NavigatorState> _navigatorKey;
  final String baseUrl = 'http://yhmysore.in/api/therapy/index.php';
  SecureStorage secureStorage = SecureStorage();

  AppointmentController(this._read, this._navigatorKey) : super([]);

  Future<void> fetchAppointments() async {
    var uid = await secureStorage.readSecureData("uid");
    try {
      final confirmedAppointments =
          await _fetchAppointments(uid, 'myconfirmedapp');
      final pendingAppointments = await _fetchAppointments(uid, 'mypendingapp');

      state = [...confirmedAppointments, ...pendingAppointments];
    } catch (e) {
      print(e);
      _showError(e.toString());
    }
  }

  Future<List<Appointment>> _fetchAppointments(String uid, String tag) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'tag': tag,
        'uid': uid,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data
          .map((appointment) => Appointment(
                appointment['appid'],
                Doctor(appointment['docid'], appointment['referredby'],
                    appointment['doctorName'] ?? "Doctor Name"),
                customDateTimeParse(appointment['date']),
                appointment['slot'],
                appointment['status'],
              ))
          .toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  DateTime customDateTimeParse(String date) {
    var parts = date.split('-').map((i) => int.parse(i)).toList();
    return DateTime(parts[0], parts[1], parts[2]);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(_navigatorKey.currentContext!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> submitFeedback(Appointment appointment, int rating) async {
    var uid = await secureStorage.readSecureData("uid");
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'tag': 'feedback',
        'uid': uid,
        'docid': appointment.doctor.docid,
        'rating': rating.toString(),
        'date':
            '${appointment.date.year}-${appointment.date.month}-${appointment.date.day}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _showError(data["message"]);
    } else {
      _showError('Error occurred! Try again!');
    }
  }
}
