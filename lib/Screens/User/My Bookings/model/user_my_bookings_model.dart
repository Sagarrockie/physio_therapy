class Doctor {
  final String docid;
  final String referredby;
  final String name;

  Doctor(this.docid, this.referredby, [this.name = "Doctor Name"]);
}

class Appointment {
  final String appid;
  final Doctor doctor;
  final DateTime date;
  final String slot;
  final String status;

  Appointment(this.appid, this.doctor, this.date, this.slot, this.status);
}
