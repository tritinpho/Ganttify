//TODO: Figure out the bugs on this page
//TODO: This page could use some kind of 'back'/exit button

import 'package:flutter/material.dart';
import 'Models/GanttTeam.dart';
import 'Models/GanttChart.dart';
import 'Models/ModelStore.dart';

class CreateGanttTask extends StatefulWidget {
  final Function onCreated;

  const CreateGanttTask({Key? key, required this.onCreated}) : super(key: key);

  @override
  State<CreateGanttTask> createState() => CreateGanttTaskState();
}

class CreateGanttTaskState extends State<CreateGanttTask> {
  TextEditingController nameController = TextEditingController();
  String name = '';
  GanttTeam? selected_team;
  GanttChart? selected_chart;
  DateTimeRange? selected_range;

  void onCreate() async {
    final task = await ModelStore.instance
        .createTask(selected_chart!, name, selected_team!, selected_range!);
    widget.onCreated(task);
  }

  _selectDate(BuildContext context) async {
    final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 99999)));
    if (range != null && selected_range != range) {
      setState(() {
        selected_range = range;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModelStore.instance.charts!.isEmpty) {
      return Center(child: Text('No Charts Created Yet!'));
    }

    return ListView(
      addAutomaticKeepAlives: false,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: DropdownButtonFormField<GanttTeam>(
              decoration: InputDecoration(labelText: 'Select Team'),
              value: selected_team,
              onChanged: (GanttTeam? value) {
                setState(() {
                  selected_team = value;
                });
              },
              items: ModelStore.instance.teams!.entries
                  .map((e) => DropdownMenuItem<GanttTeam>(
                      value: e.value, child: Text(e.value.name)))
                  .toList()),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: DropdownButtonFormField<GanttChart>(
              decoration: InputDecoration(labelText: 'Select Chart'),
              value: selected_chart,
              onChanged: (GanttChart? value) {
                setState(() {
                  selected_chart = value;
                });
              },
              items: ModelStore.instance.charts!.entries
                  .map((e) => DropdownMenuItem<GanttChart>(
                      value: e.value, child: Text(e.value.name)))
                  .toList()),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: nameController,
            autocorrect: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Task Item Name',
            ),
            onChanged: (text) {
              setState(() {
                name = text;
              });
            },
          ),
        ),
        Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: const Text('Set Task Timeframe...',
                    style: TextStyle(color: Colors.black, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  primary: Color.fromARGB(255, 255, 255, 255),
                  minimumSize: const Size(350, 100),
                ))),
        Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
                onPressed: () {
                  onCreate();
                },
                child: const Text('Add Task',
                    style: TextStyle(color: Colors.black, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  primary: Color.fromARGB(255, 12, 235, 209),
                  minimumSize: const Size(350, 100),
                ))),
      ],
    );
  }
}
