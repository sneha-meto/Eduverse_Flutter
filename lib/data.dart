class Notice {
  String facultyName;
  String date;
  String noticeText;
  Notice({this.facultyName, this.date, this.noticeText});
}

List<Notice> notices = [
  Notice(
      facultyName: "faculty1",
      date: "12-04-2021",
      noticeText: "End semester attendance is out"),
  Notice(
      facultyName: "faculty3",
      date: "13-04-2021",
      noticeText:
          "Fill registration forms by 5pm. Please note that students who have already registered need not register again."),
  Notice(
      facultyName: "faculty1",
      date: "15-04-2021",
      noticeText: "Afternoon classes stand cancelled"),
];

class Upcoming {
  String facultyName;
  String due;
  String task;
  Upcoming({this.facultyName, this.due, this.task});
}

List<Upcoming> tasks = [
  Upcoming(facultyName: "faculty2", due: '15-04-2021', task: "IP assignment 2"),
  Upcoming(facultyName: "faculty3", due: '15-04-2021', task: "KE assignment 2")
];

class Schedule {
  List<String> mon;
  List<String> tue;
  List<String> wed;
  List<String> thu;
  List<String> fri;
  Schedule({this.mon, this.tue, this.wed, this.thu, this.fri});
}

List<Schedule> schedules = [
  Schedule(mon: ["OS", "DAA", "SE", "IP", "OS LAB", "OS LAB"])
];
