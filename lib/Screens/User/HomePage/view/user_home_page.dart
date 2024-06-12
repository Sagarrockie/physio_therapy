import 'package:flutter/material.dart';
import '../../../Common_Screens/About Page/about_page_view.dart';
import '../../../Common_Screens/Landing Page/landing_page_view.dart';
import '../../Excercising_Videos/excercising_videos.dart';
import '../../My Bookings/view/user_my_bookings_view.dart';
import '../../Search_Doctors/view/user_search_doctors_view.dart';
import '../../user_profile/user_profile.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const UserProfilePage(),
    const MyBookingsScreen(),
    const SearchDoctors(),
    ExerciseVideoPage(),
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
          title:
              const Text('User`s Portal', style: TextStyle(color: Colors.blue)),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: Theme(
          data: ThemeData.dark().copyWith(
            canvasColor: Colors.black,
            primaryColor: Colors.blue,
            textTheme:
                const TextTheme(bodySmall: TextStyle(color: Colors.white)),
          ),
          child: BottomNavigationBar(
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
                icon: Icon(Icons.search),
                label: 'Search Doctors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_collection_outlined),
                label: 'Exercising Videos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
