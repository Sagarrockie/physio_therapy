import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/readerrevenuesubscriptionlinking/v1.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import '../../../../Services/secureStorage.dart';
import '../../../../Util_Helper/util.dart';
import '../../HomePage/view/user_home_page.dart';
import '../model/user_register_model.dart';

final registerControllerProvider =
    StateNotifierProvider<RegisterController, bool>((ref) {
  return RegisterController(ref.read as Reader);
});

class RegisterController extends StateNotifier<bool> {
  final Reader _read;
  drive.DriveApi? _driveApi;
  File? _selectedImageFile;
  String _link = '';
  final String apiUrl = 'http://yhmysore.in/api/therapy/index.php';
  SecureStorage secureStorage = SecureStorage();

  RegisterController(this._read) : super(false) {
    _authenticate();
  }

  Future<void> registerUser(User user, BuildContext context) async {
    state = true;
    final checkUserResponse = await http.post(
      Uri.parse(apiUrl),
      body: {
        'tag': 'chkuser',
        'user': user.name,
      },
    );

    if (checkUserResponse.statusCode == 200) {
      final checkUserResponseBody = json.decode(checkUserResponse.body);
      if (checkUserResponseBody['error'] == 1) {
        Util.getFlashBar(context, checkUserResponseBody['message']);
        state = false;
        return;
      }
    } else {
      Util.getFlashBar(context, "Failed to check username");
      state = false;
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'tag': "register",
        ...user.toJson(),
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final int error = responseBody['error'];
      String errorMessage = responseBody['message'] ?? "Please try Again";

      if (error == 0) {
        await secureStorage.writeSecureData("uid", "1");
        await secureStorage.writeSecureData("uname", user.name);
        await secureStorage.writeSecureData("uage", user.age);
        await secureStorage.writeSecureData("uaddress", user.address);
        await secureStorage.writeSecureData("umobile", user.mobile);
        await secureStorage.writeSecureData("ugender", user.gender);
        await secureStorage.writeSecureData("ulink", _link);
        Util.getFlashBar(context, errorMessage);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const UserHomePage()));
      } else {
        Util.getFlashBar(context, errorMessage);
      }
    } else {
      Util.getFlashBar(context, "Error");
    }

    state = false;
  }

  void _authenticate() async {
    final credentials = auth.ServiceAccountCredentials.fromJson({
//creds hidden from public repos
    });

    final scopes = [drive.DriveApi.driveFileScope];
    final client = await auth.clientViaServiceAccount(credentials, scopes);
    _driveApi = drive.DriveApi(client);
  }

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _selectedImageFile = File(result.files.single.path!);
      await uploadFileToGoogleDrive();
    }
  }

  Future<void> uploadFileToGoogleDrive() async {
    if (_selectedImageFile != null) {
      final filename = _selectedImageFile!.path.split('/').last;

      final media = drive.Media(
        Stream.fromIterable(
          _selectedImageFile!.readAsBytesSync().map((e) => [e]),
        ),
        _selectedImageFile!.lengthSync(),
      );

      final driveFile = drive.File()
        ..name = filename
        ..parents = ['1GAlenFjBtlyU6dEDruyRlrVpepOQj1B6'];

      try {
        final result =
            await _driveApi?.files.create(driveFile, uploadMedia: media);

        if (result?.webViewLink != null) {
          _link = result!.webViewLink!;
        } else if (result?.id != null) {
          _link =
              'https://drive.google.com/file/d/${result!.id}/view?usp=sharing';
        }

        if (_link.isNotEmpty) {
          print('File uploaded successfully!');
          print('File Link: $_link');
        }
      } catch (error) {
        print('Error uploading file: $error');
      }
    }
  }
}
