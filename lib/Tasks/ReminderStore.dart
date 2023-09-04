/** Based on modelstore, used to save reminders on database */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'Reminder.dart';
import 'Repository.dart';
import 'TaskItem.dart';
import 'Task.dart';

class ReminderStore {
  bool dataLoaded = false;
  Database? database;
  Map<String, Task>?
      _reminders; //only thing to save is the reminders, info inside is saved as a string or a reference (type: "GanttTeam")

  final Uuid _uuid = const Uuid();

  Map<String, Task>? get reminders => _reminders;

  open() async {
    final path = join(await getDatabasesPath(), 'ganttify.db');
    // if (await databaseExists(path)) {
    //   await deleteDatabase(path);
    // }
    database = await openDatabase(path);
    await database!.transaction((txn) {
      return Future.wait(<Future>[
        //?? In the sql database, GanttTasks are called 'Tasks' and 'Tasks' are called 'reminders'
        // TODO: Change columns
        txn.execute('''
                  CREATE TABLE IF NOT EXISTS reminders (    
                      id TEXT PRIMARY KEY,
                      name TEXT,
                      team TEXT,
                      chart TEXT,
                      start_date TEXT,
                      end_date TEXT,
                      is_complete BOOLEAN,
                      FOREIGN KEY(team) REFERENCES team(id),
                      FOREIGN KEY(chart) REFERENCES chart(id)
                  );
                  '''),
      ]);
    });
  }

  refresh() async {
    final db = database!;

    // load reminders from the database
    //TODO: change this and make it work
    // _reminders = <String, Task>{};
    // final List<Map<String, dynamic>> taskMap = await db.query('reminders');
    // final Map<String, List<Task>> chartTasks = <String, List<Task>>{};
    // for (var e in taskMap) {
    //   var reminder = Task(
    //     // id: e['id'],
    //     // name: e['name'],
    //     // team: _teams![e['team']]!,
    //     // chart: e['chart'],
    //     // dates: DateTimeRange(
    //     //     start: DateTime.parse(e['start_date']),
    //     //     end: DateTime.parse(e['end_date'])),
    //     // isComplete: e['is_complete']
    //     name: task.name,
    //     time: task.time,
    //     chart: task.chart,
    //     goal: task.goal,
    //     checked: task.checked,
    //     dateAdded: task.dateAdded.toIso8601String(),
    //   );
    //   List<Task> taskList =
    //       chartTasks[e['chart']] ?? <Task>[]; //TODO: check the references here
    //   _reminders![reminder.id] = reminder;
    //   taskList.add(reminder);
    //   chartTasks[e['chart']] = taskList;
    // }
    // dataLoaded = true;
  }

  //TODO: Modify to reflect creating a task

  //The parameters here are the one received from "Reminder.dart" (modal form)
  //TODO: change the variable types once they're changed in Reminder.dart
  Future<Task> createTask(
      String chartName, String reminderTask, String dateTime) async {
    final db = database!;
    final task = Task(
        name: reminderTask,
        time: "",
        chart: chartName,
        goal: "",
        checked: false,
        dateAdded: DateTime.now());
    await db.insert('reminders', task.toMap(task));
    // _reminders![task.id] = task;
    // _charts![task.chart]!.reminders.add(task);
    return task;
  }

  //TODO: Modify to reflect deleting a task
  // deleteTeamMember(GanttTeamMember member) async {
  //   final db = database!;
  //   await db.delete('team_members', where: 'id = ?', whereArgs: [member.id]);
  //   _teams![member.team]!.members.remove(member);
  // }

  // Singleton
  static final ReminderStore _instance = ReminderStore();
  static ReminderStore get instance => _instance;
}
