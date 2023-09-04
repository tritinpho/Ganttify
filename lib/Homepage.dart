import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';
import 'GanttChartView.dart';
import 'Models/GanttChart.dart';
import 'CreateChart.dart';
import 'Models/ModelStore.dart';

import 'History.dart';
import 'Tasks/Reminder.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> with TickerProviderStateMixin {
  Widget? overlay;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return overlay ??
        Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //** Grey background image */
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //** Text: "Welcome" */
                    AlignPositioned(
                      dy: -550,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        width: 350,
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Welcome',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** Text: "Recent Charts" */
                    AlignPositioned(
                      dy: -500,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        width: 350,
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Your Charts',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** Text: "Getting Started" */
                    AlignPositioned(
                      dy: -275,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        width: 350,
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Getting Started',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** View Reminders Button */
                    AlignPositioned(
                      dy: -50,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 26, 26, 26)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(1, 3),
                              )
                            ]),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: const Text(
                              'View Reminders',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** View Chart History Button */
                    AlignPositioned(
                      dy: -150,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 26, 26, 26)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(1, 3),
                              )
                            ]),
                        child: Center(
                          child: GestureDetector(
                            //TODO: Loads the widget, does not load the logo or the bottom bar?
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const History()),
                              );
                            },
                            child: const Text(
                              'View Chart History',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** Create New Gantt Chart Button */
                    AlignPositioned(
                      dy: -250,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 26, 26, 26)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(1, 3),
                              )
                            ]),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                overlay =
                                    CreateChart(onCreated: (GanttChart chart) {
                                  setState(() {
                                    overlay = null;
                                  });
                                });
                              });
                            },
                            child: const Text(
                              'Create New Gantt Chart',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** USED TO DISPLAY THE CHARTS SO FAR */
                    AlignPositioned(
                        dy: -365,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 180,
                          child: ModelStore.instance.charts!.isEmpty
                              ? const Center(
                                  child: const Text(
                                      'No charts have been created yet.'))
                              : ListView(
                                  itemExtent: 200,
                                  scrollDirection: Axis.horizontal,
                                  children: ModelStore.instance.charts!.entries
                                      .map((e) => Container(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            height: 175,
                                            width: 175,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color.fromARGB(
                                                            255, 26, 26, 26)
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 4,
                                                    offset: const Offset(1, 3),
                                                  )
                                                ]),
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    overlay = Scaffold(
                                                        appBar: AppBar(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  222,
                                                                  222,
                                                                  222),
                                                          title: Text(
                                                              e.value.name,
                                                              style: TextStyle(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      26,
                                                                      26,
                                                                      26))),
                                                          actions: <Widget>[
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.close),
                                                              onPressed: () {
                                                                setState(() {
                                                                  overlay =
                                                                      null;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                          leading: Container(),
                                                        ),
                                                        body: GanttChartView(chart: e.value));
                                                  });
                                                },
                                                child: Text(
                                                  e.value.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.0,
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )))
                                      .toList(),
                                ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
