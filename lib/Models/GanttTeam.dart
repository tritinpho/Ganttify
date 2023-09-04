

class GanttTeamMember {
  final String id;
  final String name;
  final String team;


  const GanttTeamMember({
    required this.id,
    required this.name,
    required this.team
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'team': team
    };
  }
}

class GanttTeam {
  final String id;
  final String name;
  final List<GanttTeamMember> members;


  const GanttTeam({
    required this.id,
    required this.name,
    required this.members
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

  
  List<Map<String, dynamic>> toMembersMap() {
    return List.generate(members.length, (i) {
      return {
        'id': members[i].id,
        'name': members[i].name,
        'team': id
      };
    });
  }
}