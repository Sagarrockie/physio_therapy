import 'package:flutter/material.dart';
import 'package:newphysio/Screens/User/Register/view/user_register_view.dart';
import 'package:provider/provider.dart';
import '../../../../Common_Widgets/common_text_field_widget.dart';
import '../../../../Common_Widgets/custom_button_widget.dart';
import '../controller/user_login_controller.dart';

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, loginController, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 35, right: 35, top: 80),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(100.0)),
                              child: Container(
                                height: 200,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/user.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 25, bottom: 20),
                              child: Center(
                                child: Text(
                                  'Physio Finder',
                                  style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Center(
                                child: Text(
                                  'User Login',
                                  style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            CustomTextField(
                              controller: loginController.signInEmailController,
                              hintText: 'User Name',
                            ),
                            const SizedBox(height: 30),
                            CustomTextField(
                              controller:
                                  loginController.signInPasswordController,
                              hintText: 'Password',
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
                                  child: loginController.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.blue)
                                      : IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            loginController.signIn(
                                              loginController
                                                  .signInEmailController.text,
                                              loginController
                                                  .signInPasswordController
                                                  .text,
                                              context,
                                            );
                                          },
                                          icon: const Icon(Icons.arrow_forward),
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: CustomButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const RegisterView()),
                                  );
                                },
                                icon: Icons.person_add,
                                text: 'Dont Have An Account? Sign Up',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
