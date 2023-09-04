import 'GanttTask.dart';

class GanttChart {
  final String id;
  final String name;
  final List<GanttTask> tasks;

  const GanttChart({required this.id, required this.name, required this.tasks});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  String getChartName() {
    return this.name;
  }
}
