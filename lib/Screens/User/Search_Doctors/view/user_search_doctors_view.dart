import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Services/secureStorage.dart';
import '../controller/user_search_doctors_controller.dart';
import '../model/user_search_doctor_model.dart';

class SearchDoctors extends ConsumerStatefulWidget {
  const SearchDoctors({super.key});

  @override
  _SearchDoctorsState createState() => _SearchDoctorsState();
}

class _SearchDoctorsState extends ConsumerState<SearchDoctors> {
  TextEditingController searchDoctorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(doctorControllerProvider.notifier).fetchDoctors("");
  }

  @override
  Widget build(BuildContext context) {
    final doctors = ref.watch(doctorControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search for Practitioners',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchDoctorController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 5,
                  color: Colors.blue.shade900,
                ),
              ),
              hintText: "Search Keyword",
              hintStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  ref
                      .read(doctorControllerProvider.notifier)
                      .fetchDoctors(searchDoctorController.text);
                },
              ),
            ),
            onSubmitted: (value) {
              ref.read(doctorControllerProvider.notifier).fetchDoctors(value);
            },
          ),
          doctors.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Center(
                      child: Text(
                    "No Doctors found",
                    style: TextStyle(color: Colors.white),
                  )),
                )
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(context, doctors[index], index);
                    },
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor, index) {
    return doctor.rate != ""
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.docName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Specialization : ${doctor.specialization}",
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          "Experience in Years : ${doctor.experience}",
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _showDatePicker(context, doctor);
                          },
                          child: const Text('Book an Appointment'),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: List.generate(
                            int.parse(doctor.rate),
                            (index) => const Icon(Icons.star,
                                color: Colors.yellowAccent),
                          ),
                        ),
                        const SizedBox(height: 10),
                        IconButton(
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.blue,
                            size: 50,
                          ),
                          onPressed: () {
                            _makePhoneCall(doctor.docMobile);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  void _showDatePicker(BuildContext context, Doctor doctor) async {
    SecureStorage secureStorage = SecureStorage();
    String uid = await secureStorage.readSecureData("uid");
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);
    String initialTimeString =
        '${initialTime.hour.toString().padLeft(2, '0')}${initialTime.minute.toString().padLeft(2, '0')}';

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.parse("2000-01-01 $initialTimeString")),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        if (selectedTime.hour < 9 || selectedTime.hour > 21) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Invalid Time'),
                content: const Text('Please select a time between 9 AM and 9 PM.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }

        String referralInfo = ''; // To store referral information

        // Show referral information dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Enter Referral Information'),
              content: TextField(
                onChanged: (value) {
                  referralInfo = value;
                },
                decoration: const InputDecoration(labelText: 'Referral'),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(doctorControllerProvider.notifier).bookAppointment(
                        context,
                        uid,
                        doctor,
                        selectedDate,
                        selectedTime,
                        referralInfo);
                  },
                  child: const Text('Book Appointment'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
