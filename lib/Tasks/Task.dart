//** This handles taking the info submitted from the TO-DO menu (reminders page) and saves the item to a list */

import 'dart:convert';

class Task {
  String name;
  String time;
  String chart;
  String goal = '';
  bool checked;
  DateTime dateAdded;

  Task({
    required this.name,
    required this.time,
    required this.chart,
    required this.checked,
    required this.dateAdded,
    goal,
  }) {
    this.goal = goal ?? '';
  }

//?? original version of task
  // Task(required String name, Map<dynamic, Object> map, {
  //   required this.name,
  //   required this.time,
  //   required this.chart,
  //   required this.checked,
  //   required this.dateAdded,
  //   goal,
  // }) {
  //   this.goal = goal ?? '';
  // }

  factory Task.fromJson(Map<String, dynamic> jsonData) {
    return Task(
      name: jsonData['name'],
      time: jsonData['time'],
      chart: jsonData['chart'],
      goal: jsonData['goal'],
      checked: jsonData['checked'],
      dateAdded: DateTime.parse(jsonData['dateAdded']),
    );
  }

  Map<String, dynamic> toMap(Task task) => {
        'name': task.name,
        'time': task.time,
        'chart': task.chart,
        'goal': task.goal,
        'checked': task.checked,
        'dateAdded': task.dateAdded.toIso8601String(),
      };

  static Map<String, dynamic> toMap2(Task task) => {
        'name': task.name,
        'time': task.time,
        'chart': task.chart,
        'goal': task.goal,
        'checked': task.checked,
        'dateAdded': task.dateAdded.toIso8601String(),
      };

  static String encode(List<Task> tasks) => json.encode(
        tasks.map<Map<String, dynamic>>((task) => Task.toMap2(task)).toList(),
      );

  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromJson(item))
          .toList();
}
