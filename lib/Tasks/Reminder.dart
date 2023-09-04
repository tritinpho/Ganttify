//** This is the 'reminders' page on the bottom nav bar. */
// Here you can add reminders for gantt chart tasks along with time and the gantt chart title
// TODO: Add push notifications for these, also save to local system and figure out how to load them
// TODO: Instead of just typing out the task name, chart title, etc, maybe change up the order of these entries and have them come as a dropdown that lets you select from charts already made

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Task.dart';
import 'TaskItem.dart';
import 'Repository.dart';
import 'ReminderStore.dart';
import 'package:intl/intl.dart';

import '../Models/GanttTeam.dart';
import '../Models/GanttChart.dart';
import '../Models/ModelStore.dart';

class Reminder extends StatefulWidget {
  final Function setScene;
  const Reminder(this.setScene, {Key? key}) : super(key: key);

  @override
  ReminderState createState() => ReminderState();
}

class ReminderState extends State<Reminder> {
  TextEditingController nameController = TextEditingController();
  String name = '';
  GanttTeam? selected_team;
  GanttChart? selected_chart;
  String? chart_string = "";
  DateTimeRange? selected_range;

  String dateTimeString = "05/21 10:30 pm"; //default time
  // String dateString = "";"
  // String timeString = "";

  final Repository repository = Repository();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final TextEditingController _textFieldController3 = TextEditingController();

  List<Task> _tasks = <Task>[];

  void onCreate() async {
    final chart = await ModelStore.instance.createChart(name);
    widget.setScene(0);
  }

  _TaskListState() {
    _getTasksFromRepository();
  }

  _getTasksFromRepository() async {
    List<Task> tasks = await Repository.instance.getTasks();
    tasks.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));

    setState(() {
      _tasks = tasks;
    });
  }

  removeTask(Task task) {
    List<Task> tasks = _tasks;
    tasks.remove(task);

    setState(() {
      _tasks = tasks;
    });

    Repository.instance.saveTasks(_tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reminders',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      children: _tasks
                          .map((Task task) {
                            return TaskItem(
                              task: task,
                              onTaskChanged: _handleTaskChange,
                              setScene: widget.setScene,
                              removeTask: removeTask,
                            );
                          })
                          .where((t) => !t.task.checked)
                          .toList(),
                    ),
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      children: _tasks
                          .map((Task task) {
                            return TaskItem(
                              task: task,
                              onTaskChanged: _handleTaskChange,
                              setScene: widget.setScene,
                              removeTask: removeTask,
                            );
                          })
                          .where((t) => t.task.checked)
                          .toList(),
                    ),
                  ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayNewDialog(),
          tooltip: 'Add task',
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.green,
          )),
    );
  }

  void _handleTaskChange(Task task) {
    setState(() {
      task.checked = !task.checked;
    });
    Repository.instance.saveTasks(_tasks);
    _getTasksFromRepository();
  }

  //reordered the way the fields are entered
  //TODO: also change the variable types
  Future<void> _addTaskItem(
      String chartName, String reminderTask, String dateTime) async {
    //** uses the repository to store */
    setState(() {
      _tasks.add(Task(
          name: reminderTask,
          time: dateTime,
          chart: chartName,
          goal: "",
          checked: false,
          dateAdded: DateTime.now()));
    });
    _textFieldController.clear();
    _textFieldController2.clear();
    _textFieldController3.clear();

    Repository.instance.saveTasks(_tasks);

    //** Uses ReminderStore (database) to store */
    final task = await ReminderStore.instance
        .createTask(chartName, reminderTask, dateTime);
    // widget.onCreated(task); //TODO: Don't need this?
  }

  Future<void> _displayNewDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Reminder'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // TextField(
                //   controller: _textFieldController3,
                //   decoration:
                //       const InputDecoration(hintText: 'Gantt Chart Title'),
                // ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: DropdownButtonFormField<GanttChart>(
                      decoration: InputDecoration(labelText: 'Select Chart'),
                      value: selected_chart,
                      onChanged: (GanttChart? value) {
                        setState(() {
                          // selected_chart = value.name as GanttChart?;
                          chart_string = value?.name;
                        });
                      },
                      items: ModelStore.instance.charts!.entries
                          .map((e) => DropdownMenuItem<GanttChart>(
                              value: e.value, child: Text(e.value.name)))
                          .toList()),
                ),
                //TODO: Consider adding dropdown for the chart tasks
                TextField(
                  controller: _textFieldController,
                  decoration:
                      const InputDecoration(hintText: 'Gantt Chart Task'),
                ),

                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoButton.filled(
                      child: Text("Schedule"),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 200,
                                child: CupertinoDatePicker(
                                  backgroundColor: Colors.white,
                                  mode: CupertinoDatePickerMode.dateAndTime,
                                  onDateTimeChanged: (dateTime) {
                                    setState(() {
                                      dateTimeString =
                                          DateFormat('MM/dd h:mm a')
                                              .format(dateTime);

                                      print(
                                          "dateTimestring: " + dateTimeString);
                                      // dateTimeString = dateTime.toString();
                                    });
                                  },
                                ),
                              );
                            });
                      },
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTaskItem(
                    chart_string!, _textFieldController2.text, dateTimeString);
              },
            ),
          ],
        );
      },
    );
  }
}
