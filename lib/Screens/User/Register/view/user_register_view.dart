import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../../Common_Widgets/common_text_field_widget.dart';
import '../../Login/view/user_login_view.dart';
import '../controller/user_register_controller.dart';
import '../model/user_register_model.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 35, right: 35, top: 80),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100.0)),
                        child: Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/user.png'),
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 20),
                        child: Center(
                          child: Text(
                            'Physio Finder',
                            style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 35,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Text(
                            'User Register',
                            style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: nameController,
                        hintText: "Name",
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: addressController,
                        hintText: "Address",
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: mobileController,
                        hintText: "Phone number",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[6-9]\d{0,9}$'))
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: ageController,
                        hintText: "Age",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,2}$'))
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: genderController,
                        hintText: "Gender",
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          const Text("Click Below Icon to Upload Medical History",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          IconButton(
                            onPressed: () => ref
                                .read(registerControllerProvider.notifier)
                                .pickAndUploadFile(),
                            icon: const Icon(Icons.upload_file,
                                color: Colors.white, size: 100),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w700),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xff4c505b),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.blue)
                                : IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      final user = User(
                                        name: nameController.text,
                                        mobile: mobileController.text,
                                        password: passwordController.text,
                                        address: addressController.text,
                                        gender: genderController.text,
                                        age: ageController.text,
                                      );
                                      ref
                                          .read(registerControllerProvider
                                              .notifier)
                                          .registerUser(user, context);
                                    },
                                    icon: const Icon(Icons.arrow_forward),
                                  ),
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyLogin()));
                          },
                          child: const Text(
                            'Already Have An Account? Sign In',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
