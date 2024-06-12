import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../Services/secureStorage.dart';
import '../Model/login_model.dart';

class AuthController extends ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();
  final String apiUrl = 'http://yhmysore.in/api/therapy/index.php';
  bool isLoading = false;

  Future<void> signIn(String docUserName, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'tag': "doclogin",
        'docusername': docUserName,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final error = responseBody['error'];
        final errorMessage = responseBody['message'] ?? "Please try again";

        if (error == 0) {
          saveUserData(responseBody);
        } else {
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      throw Exception("An error occurred. Please try again.");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void saveUserData(Map<String, dynamic> responseBody) {
    final doctor = DoctorModel.fromJson(responseBody);
    secureStorage.writeSecureData('docname', doctor.docname);
    secureStorage.writeSecureData('docid', doctor.docid);
    secureStorage.writeSecureData('experience', doctor.experience);
    secureStorage.writeSecureData('specialization', doctor.specialization);
    secureStorage.writeSecureData('qualification', doctor.qualification);
    secureStorage.writeSecureData('docmobile', doctor.docmobile);
    secureStorage.writeSecureData('docusername', doctor.docusername);
  }
}
