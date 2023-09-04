// ** This handles displaying the To-Do items on the Reminders page*/

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Task.dart';
import '../Models/GanttChart.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final dynamic onTaskChanged;
  final dynamic setScene;
  final dynamic removeTask;

  TaskItem({
    required this.task,
    required this.onTaskChanged,
    required this.setScene,
    required this.removeTask,
  }) : super(key: ObjectKey(task));

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) {
      return const TextStyle(color: Color.fromARGB(255, 0, 0, 0));
    }

    return const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          GestureDetector(
            onTap: () => removeTask(task),
            child: Card(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0)),
                elevation: 3,
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.delete_outlined,
                    color: Color.fromARGB(255, 225, 69, 97),
                  ),
                )),
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: GestureDetector(
          onTap: () => onTaskChanged(task),
          child: Card(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0)),
              elevation: 3,
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(15),
                child: Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.goal.isNotEmpty
                            ? task.goal.toUpperCase()
                            : 'To-Do Item',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(2)),
                      Text(
                        task.time,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 30,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(2)),
                      Text(
                        task.name,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(2)),
                      Text(
                        // task.chart.getChartName(), //TODO: is it not saving?
                        // task.chart.name,
                        task.chart, //Should display the chart name
                        style: const TextStyle(
                          color: Color.fromARGB(255, 53, 53, 53),
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ]),
              ))),
    );
  }
}
