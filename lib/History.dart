//TODO: This page is blank, backend will be responsible for filling it once charts are created

import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:focus/GanttChartView.dart';
import 'package:focus/Models/GanttChart.dart';
import 'Models/ModelStore.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? overlay;

    print('This is the History page.'); //TODO: delete
    return overlay ??
        Scaffold(
            body: Column(
          children: [
            Expanded(
                child: Stack(alignment: Alignment.center, children: [
              //** Label at top of page */
              AlignPositioned(
                dy: -550,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 70,
                  width: 350,
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Chart History',
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
              //** List of past charts */
              //TODO: add clickability
              AlignPositioned(
                  dy: -365,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 180,
                    child: ModelStore.instance.charts!.isEmpty
                        ? const Center(
                            child:
                                const Text('No charts have been created yet.'))
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
                                          borderRadius: const BorderRadius.all(
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
                                            //TODO: alter the below, it's meant for stateful widget but history is stateless(?)
                                            // setState(() {
                                            //   overlay = Scaffold(
                                            //       appBar: AppBar(
                                            //         backgroundColor:
                                            //             const Color
                                            //                     .fromARGB(
                                            //                 255,
                                            //                 222,
                                            //                 222,
                                            //                 222),
                                            //         title: Text(
                                            //             e.value.name,
                                            //             style: TextStyle(
                                            //                 color: const Color
                                            //                         .fromARGB(
                                            //                     255,
                                            //                     26,
                                            //                     26,
                                            //                     26))),
                                            //         actions: <Widget>[
                                            //           IconButton(
                                            //             icon: Icon(
                                            //                 Icons.close),
                                            //             onPressed: () {
                                            //               setState(() {
                                            //                 overlay =
                                            //                     null;
                                            //               });
                                            //             },
                                            //           ),
                                            //         ],
                                            //         leading: Container(),
                                            //       ),
                                            //       body: GanttChartView(
                                            //           chart: e.value));
                                            // });
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
            ]))
          ],
        ));
  }
}
