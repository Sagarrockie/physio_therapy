import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../Services/secureStorage.dart';
import '../../../../Util_Helper/util.dart';
import '../../Home Page/view/doctor_home_page.dart';
import '../model/register_model.dart';

final doctorControllerProvider =
    ChangeNotifierProvider((ref) => DoctorController());

class DoctorController extends ChangeNotifier {
  bool isLoading = false;
  SecureStorage secureStorage = SecureStorage();
  final String apiUrl = 'http://yhmysore.in/api/therapy/index.php';

  Future<void> registerDoctor(BuildContext context, Doctor doctor) async {
    isLoading = true;
    notifyListeners();

    // Check if username is already taken
    final checkUserResponse = await http.post(
      Uri.parse(apiUrl),
      body: {
        'tag': 'chkdoc',
        'docuser': doctor.userName,
      },
    );

    if (checkUserResponse.statusCode == 200) {
      final Map<String, dynamic> checkUserResponseBody =
          json.decode(checkUserResponse.body);

      if (checkUserResponseBody['error'] == 1) {
        isLoading = false;
        notifyListeners();
        Util.getFlashBar(context, checkUserResponseBody['message']);
        return;
      }
    } else {
      Util.getFlashBar(context, "Failed to check username");
      isLoading = false;
      notifyListeners();
      return;
    }

    // Proceed with doctor registration
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'tag': "docregister",
        'docname': doctor.name,
        'qualification': doctor.qualification,
        'exp': doctor.experience,
        'mobile': doctor.mobile,
        'spec': doctor.specialization,
        'docusername': doctor.userName,
        'password': doctor.password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final int error = responseBody['error'];
      String errorMessage = responseBody['message'] ?? "Please try Again";

      if (responseBody['docname'] != null) {
        secureStorage.writeSecureData('docname', responseBody['docname']);
      }
      if (responseBody['docid'] != null) {
        secureStorage.writeSecureData('docid', responseBody['docid']);
      }
      if (responseBody['specialization'] != null) {
        secureStorage.writeSecureData(
            'specialization', responseBody['specialization']);
      }

      if (error == 0) {
        Util.getFlashBar(context, errorMessage);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const DoctorHomePage()));
      } else if (error == 1) {
        Util.getFlashBar(context, errorMessage);
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
