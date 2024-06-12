import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/secureStorage.dart';
import '../model/doctor_profile_model.dart';

final doctorControllerProvider =
    StateNotifierProvider<DoctorController, Doctor?>((ref) {
  return DoctorController();
});

class DoctorController extends StateNotifier<Doctor?> {
  DoctorController() : super(null) {
    getUserDetails();
  }

  SecureStorage secureStorage = SecureStorage();

  Future<void> getUserDetails() async {
    final docname = await secureStorage.readSecureData("docname");
    final qualification = await secureStorage.readSecureData("qualification");
    final experience = await secureStorage.readSecureData("experience");
    final mobile = await secureStorage.readSecureData("mobile");
    final specialization = await secureStorage.readSecureData("specialization");
    final docusername = await secureStorage.readSecureData("docusername");

    state = Doctor(
      docid: '', // Assuming docid is not stored securely; adjust as needed
      docname: docname ?? 'Doctor Name',
      qualification: qualification ?? 'Qualification',
      experience: experience ?? 'Experience',
      docmobile: mobile ?? 'Phone number',
      specialization: specialization ?? 'Specialization',
      docusername: docusername ?? 'Username',
      status: '', // Assuming status is not stored securely; adjust as needed
    );
  }
}
