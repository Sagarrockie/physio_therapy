import 'package:flutter/material.dart';
import '../../../Common_Screens/About Page/about_page_view.dart';
import '../../../Common_Screens/Landing Page/landing_page_view.dart';
import '../../My Appointments/view/my_appointments_view.dart';
import '../../Profile/view/doctor_profile_view.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DoctorDetailsPage(),
    MyBookingsScreenDoc(),
    const AboutPage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandingPage(),
                      ));
                },
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ))
          ],
          title: const Text('Doctor`s Portal',
              style: TextStyle(color: Colors.blue)),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'My Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'About',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.event),
            //   label: 'My Appointments',
            // ),
          ],
        ),
      ),
    );
  }
}
