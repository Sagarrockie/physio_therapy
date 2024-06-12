import 'package:flutter/material.dart';
import 'package:googleapis/readerrevenuesubscriptionlinking/v1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Services/secureStorage.dart';
import '../model/my_appointments_model.dart';

final appointmentsControllerProvider =
    ChangeNotifierProvider((ref) => AppointmentsController(ref.read as Reader));

class AppointmentsController extends ChangeNotifier {
  final Reader _read;
  final SecureStorage secureStorage = SecureStorage();
  String docname = "";
  List<Appointment> appointments = [];
  final String apiUrl = 'http://yhmysore.in/api/therapy/index.php';

  AppointmentsController(this._read);

  Future<void> fetchAppointments() async {
    String docid = await secureStorage.readSecureData("docid");
    String tempDocName = await secureStorage.readSecureData("docname");
    docname = tempDocName;

    final response = await http.post(Uri.parse(apiUrl), body: {
      'tag': 'getappointments',
      'docid': docid,
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      appointments = data.map((item) {
        return Appointment(
          Doctor(item['referredby'] ?? '', ''),
          item['date'] ?? '',
          item['appid'] ?? '',
          item['link'], // Nullable
          item['username'], // Nullable
        );
      }).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to fetch appointments');
    }
  }

  Future<void> confirmAppointment(Appointment appointment) async {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'tag': 'confirmappointment',
      'appid': appointment.appid,
    });

    if (response.statusCode == 200) {
      await fetchAppointments(); // Refresh appointments after confirmation
      final data = json.decode(response.body);
      if (data["error"] == 0) {
        return Future.value();
      } else {
        throw Exception(data["message"]);
      }
    } else {
      throw Exception('Failed to confirm appointment');
    }
  }

  Future<void> cancelAppointment(Appointment appointment) async {
    appointments.remove(appointment);
    notifyListeners();
    // Perform API call or local storage update if required
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
