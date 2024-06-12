import 'package:flutter/material.dart';
import '../../../../Common_Widgets/common_text_field_widget.dart';
import '../../../../Util_Helper/util.dart';
import '../../Home Page/view/doctor_home_page.dart';
import '../../Register/view/register_view.dart';
import '../Controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = ChangeNotifierProvider((_) => AuthController());

class MyDocLogin extends ConsumerWidget {
  MyDocLogin({super.key});

  final TextEditingController dNameController = TextEditingController();
  final TextEditingController dPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildLoginForm(authController, context, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/doctor.jpeg'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: Text(
            'Physio Finder',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Text(
            'Practitioner Login',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(
      AuthController authController, BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomTextField(
          controller: dNameController,
          hintText: "Practitioner User Name",
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: dPasswordController,
          hintText: "Password",
          obscureText: true,
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sign in',
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xff4c505b),
              child: authController.isLoading
                  ? const CircularProgressIndicator(color: Colors.blue)
                  : IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        try {
                          await ref.read(authControllerProvider).signIn(
                              dNameController.text, dPasswordController.text);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DoctorHomePage()),
                          );
                        } catch (e) {
                          Util.getFlashBar(context, e.toString());
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DocRegister()),
              );
            },
            child: Text(
              'Dont Have An Account? Sign Up',
              textAlign: TextAlign.left,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.grey.shade300,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
