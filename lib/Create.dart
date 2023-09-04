// TODO: Notes
//?? "team #" button is leading to 'CreateTask.dart', which has some bugs
//?? Also somewhat unclear:
//??    what the buttons on this page are meant to do,
//??    how to finish creating a chart
//??    What happens when you click on team #

import 'package:flutter/material.dart';
import 'package:focus/CreateTask.dart';
import 'CreateTeam.dart';
import 'CreateTeamMember.dart';
import 'CreateChart.dart';
import 'Models/GanttTeam.dart';
import 'Models/GanttChart.dart';
import 'Models/GanttTask.dart';
import 'Models/ModelStore.dart';

class Create extends StatefulWidget {
  Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController _textFieldController = TextEditingController();
  var count = 1;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: child ?? ListView(
          itemExtent: 100,
          addAutomaticKeepAlives: false,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
              onPressed: () {
                setState(() {
                  child = CreateTeam(onCreated: (GanttTeam team) {
                    setState(() {
                      child = null;
                    });
                  });
                });
              },
              child: const Text('New Team...',
                  style: TextStyle(
                      color: Colors.black, fontSize: 24)),
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              primary: const Color.fromARGB(255, 255, 255, 255),
              minimumSize: const Size(350, 100),
            ))),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
              onPressed: () {
                setState(() {
                  child = CreateTeamMember(onCreated: (GanttTeamMember member) {
                    setState(() {
                      child = null;
                    });
                  });
                });
              },
              child: const Text('New Team Member...',
                  style: TextStyle(
                      color: Colors.black, fontSize: 24)),
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              primary: const Color.fromARGB(255, 255, 255, 255),
              minimumSize: const Size(350, 100),
            ))),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
              onPressed: () {
                setState(() {
                  child = CreateChart(onCreated: (GanttChart chart) {
                    setState(() {
                      child = null;
                    });
                  });
                });
              },
              child: const Text('New Chart...',
                  style: TextStyle(
                      color: Colors.black, fontSize: 24)),
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              primary: const Color.fromARGB(255, 255, 255, 255),
              minimumSize: const Size(350, 100),
            ))),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
              onPressed: () {
                setState(() {
                  child = CreateGanttTask(onCreated: (GanttTask task) {
                    setState(() {
                      child = null;
                    });
                  });
                });
              },
              child: const Text('New Task...',
                  style: TextStyle(
                      color: Colors.black, fontSize: 24)),
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              primary: const Color.fromARGB(255, 255, 255, 255),
              minimumSize: const Size(350, 100),
            ))),
          ],
        )
      ),
    );
  }
}
