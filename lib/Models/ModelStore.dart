import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'GanttChart.dart';
import 'GanttTask.dart';
import 'GanttTeam.dart';

class ModelStore {
  bool dataLoaded = false;
  Database? database;
  Map<String, GanttTask>? _tasks;
  Map<String, GanttChart>? _charts;
  Map<String, GanttTeam>? _teams;

  final Uuid _uuid = const Uuid();

  Map<String, GanttTask>? get tasks => _tasks;
  Map<String, GanttChart>? get charts => _charts;
  Map<String, GanttTeam>? get teams => _teams;


  open() async {
    final path = join(await getDatabasesPath(), 'ganttify.db');
    // if (await databaseExists(path)) {
    //   await deleteDatabase(path);
    // }
    database = await openDatabase(path);
    await database!.transaction((txn) {
        return Future.wait(<Future>[txn.execute('''
                  CREATE TABLE IF NOT EXISTS teams (
                      id TEXT PRIMARY KEY,
                      name TEXT
                  );
                  '''),

          txn.execute('''
                  CREATE TABLE IF NOT EXISTS team_members (
                      id TEXT PRIMARY KEY,
                      name TEXT,
                      team TEXT,
                      FOREIGN KEY(team) REFERENCES team(id)
                  );
                  '''),


          txn.execute('''
                  CREATE TABLE IF NOT EXISTS charts (
                      id TEXT PRIMARY KEY,
                      name TEXT
                  );
                  '''),

          txn.execute('''
                  CREATE TABLE IF NOT EXISTS tasks (
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

    // load teams
    final List<Map<String, dynamic>> memberMap = await db.query('team_members');
    final Map<String, List<GanttTeamMember>> teamMembers = <String, List<GanttTeamMember>>{};
    for(var e in memberMap) {
      List<GanttTeamMember> mems = teamMembers[e['team']] ?? <GanttTeamMember>[];
      mems.add(GanttTeamMember(id: e['id'], name: e['name'], team: e['team']));
      teamMembers[e['team']] = mems;
    }
    final List<Map<String, dynamic>> teamMap = await db.query('teams');
    _teams = { for (var v in teamMap) v['id'] : GanttTeam(
      id: v['id'], 
      name: v['name'], 
      members: teamMembers[v['id']] ?? <GanttTeamMember>[]
    ) };


    // load charts + tasks
    _tasks = <String, GanttTask>{};
    final List<Map<String, dynamic>> taskMap = await db.query('tasks');
    final Map<String, List<GanttTask>> chartTasks = <String, List<GanttTask>>{};
    for (var e in taskMap) {
      var task = GanttTask(
        id: e['id'], 
        name: e['name'],
        team: _teams![e['team']]!,
        chart: e['chart'],
        dates: DateTimeRange(
          start: DateTime.parse(e['start_date']), 
          end: DateTime.parse(e['end_date'])
          ),
        isComplete: e['is_complete'] != 0 ? true : false
      );
      List<GanttTask> taskList = chartTasks[e['chart']] ?? <GanttTask>[];
      _tasks![task.id] = task;
      taskList.add(task);
      chartTasks[e['chart']] = taskList;
    }
    final List<Map<String, dynamic>> chartMap = await db.query('charts');
    _charts = { for (var v in chartMap) v['id'] : GanttChart(
      id: v['id'], 
      name: v['name'],
      tasks: chartTasks[v['id']] ?? <GanttTask>[]
    ) };

    dataLoaded = true;
  }


  Future<GanttTeam> createTeam(String name) async {
    final db = database!;
    final team = GanttTeam(
      id: _uuid.v4(), 
      name: name, 
      members: <GanttTeamMember>[]
    );
    await db.insert('teams', team.toMap());
    _teams![team.id] = team;
    return team;
  }

  Future<GanttTeamMember> createTeamMember(GanttTeam team, String name) async {
    final db = database!;
    final member = GanttTeamMember(id: _uuid.v4(), name: name, team: team.id);
    await db.insert('team_members', member.toMap());
    team.members.add(member);
    return member;
  }

  deleteTeam(GanttTeam team) async {
    final db = database!;
    final batch = db.batch();
    batch.delete('team_members', where: 'team = ?', whereArgs: [team.id]);
    batch.delete('teams', where: 'id = ?', whereArgs: [team.id]);
    await batch.commit(noResult: true);
    _teams!.remove(team.id);
  }

  deleteTeamMember(GanttTeamMember member) async {
    final db = database!;
    await db.delete('team_members', where: 'id = ?', whereArgs: [member.id]);
    _teams![member.team]!.members.remove(member);
  }


  Future<GanttChart> createChart(String name) async {
    final db = database!;
    final chart = GanttChart(id: _uuid.v4(), name: name, tasks: <GanttTask>[]);
    await db.insert('charts', chart.toMap());
    _charts![chart.id] = chart;
    return chart;
  }

  Future<GanttTask> createTask(GanttChart chart, String name, GanttTeam team, DateTimeRange dates) async {
    final db = database!;
    final task = GanttTask(
      id: _uuid.v4(), 
      name: name, 
      chart: chart.id,
      team: team, 
      dates: dates,
      isComplete: false
      );
      await db.insert('tasks', task.toMap());
      _tasks![task.id] = task;
      _charts![task.chart]!.tasks.add(task);
      return task;
  }



  // Singleton
  static final ModelStore _instance = ModelStore();
  static ModelStore get instance => _instance;
}
