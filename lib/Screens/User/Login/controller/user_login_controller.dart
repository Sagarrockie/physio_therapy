import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../Services/secureStorage.dart';
import '../../../../Util_Helper/util.dart';
import '../../HomePage/view/user_home_page.dart';

class LoginController extends ChangeNotifier {
  final SecureStorage secureStorage = SecureStorage();
  final String apiUrl = 'http://yhmysore.in/api/therapy/index.php';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();

  Future<void> signIn(
      String userName, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    String errorMessage = "Please try Again";

    final response = await http.post(Uri.parse(apiUrl), body: {
      'tag': "login",
      'user': userName,
      'password': password,
    });

    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final int error = responseBody['error'];

      if (responseBody['message'] != null) {
        errorMessage = responseBody['message'];
      }

      if (error == 0) {
        await secureStorage.writeSecureData("uid", responseBody['uid']);
        await secureStorage.writeSecureData("uname", responseBody['username']);
        await secureStorage.writeSecureData("uage", responseBody['age']);
        await secureStorage.writeSecureData(
            "uaddress", responseBody['address']);
        await secureStorage.writeSecureData("umobile", responseBody['mobile']);
        await secureStorage.writeSecureData("ugender", responseBody['gender']);
        await secureStorage.writeSecureData("ulink", responseBody['doclink']);

        Util.getFlashBar(context, errorMessage);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserHomePage()),
        );
      } else if (error == 1) {
        _isLoading = false;
        Util.getFlashBar(context, errorMessage);
        notifyListeners();
      }
    }
  }
}
