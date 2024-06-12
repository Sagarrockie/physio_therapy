import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Common_Widgets/common_text_field_widget.dart';
import '../../Login/View/login_view.dart';
import '../controller/register_controller.dart';
import '../model/register_model.dart';

class DocRegister extends ConsumerWidget {
  const DocRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(doctorControllerProvider);
    final nameController = TextEditingController();
    final qualificationController = TextEditingController();
    final experienceController = TextEditingController();
    final mobileController = TextEditingController();
    final specializationController = TextEditingController();
    final userNameController = TextEditingController();
    final passwordController = TextEditingController();

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
                                image: AssetImage('assets/doctor.jpeg'),
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
                            'Practitioner Register',
                            style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: nameController,
                        hintText: "Practitioner Name",
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: qualificationController,
                        hintText: "Qualification",
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: experienceController,
                        hintText: "Experience",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^\d{0,2}$')), // Allow only 2-digit numbers
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: mobileController,
                        hintText: "Phone number",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^[6-9]\d{0,9}$')), // Allow only valid phone numbers
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: specializationController,
                        hintText: "Specialization",
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: userNameController,
                        hintText: "User Name",
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
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
                            child: controller.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.blue,
                                  )
                                : IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      final doctor = Doctor(
                                        name: nameController.text,
                                        qualification:
                                            qualificationController.text,
                                        experience: experienceController.text,
                                        mobile: mobileController.text,
                                        specialization:
                                            specializationController.text,
                                        userName: userNameController.text,
                                        password: passwordController.text,
                                      );
                                      controller.registerDoctor(
                                          context, doctor);
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
                                  builder: (context) => MyDocLogin()),
                            );
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
