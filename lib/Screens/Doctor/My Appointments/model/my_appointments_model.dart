class Doctor {
  final String name;
  final String specialization;

  Doctor(this.name, this.specialization);
}

class Appointment {
  final Doctor doctor;
  final String date;
  final String appid;
  final String? link;
  final String? username;

  Appointment(this.doctor, this.date, this.appid, this.link, this.username);
}
