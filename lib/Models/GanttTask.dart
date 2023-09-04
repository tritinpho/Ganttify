import 'package:flutter/material.dart';

import 'GanttTeam.dart';

class GanttTask {
  final String id;
  final String name;
  final String chart;
  final GanttTeam team;
  final DateTimeRange dates;
  final bool isComplete;

  const GanttTask({
    required this.id,
    required this.name,
    required this.team,
    required this.chart,
    required this.dates,
    required this.isComplete
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'team': team.id,
      'chart': chart,
      'start_date': dates.start.toIso8601String(),
      'end_date': dates.end.toIso8601String(),
      'is_complete': isComplete
    };
  }
}