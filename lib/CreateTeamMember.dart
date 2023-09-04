import 'package:flutter/material.dart';
import 'Models/GanttTeam.dart';
import 'Models/ModelStore.dart';

class CreateTeamMember extends StatefulWidget {
  final Function onCreated;

  const CreateTeamMember({Key? key, required this.onCreated}) : super(key: key);

  @override
  State<CreateTeamMember> createState() => CreateTeamMemberState();
}

class CreateTeamMemberState extends State<CreateTeamMember> {
  TextEditingController nameController = TextEditingController();
  String name = '';
  GanttTeam? selected;

  void onCreate() async {
    final member = await ModelStore.instance.createTeamMember(selected!, name);
    widget.onCreated(member);
  }

  @override
  Widget build(BuildContext context) {
    if (ModelStore.instance.teams!.isEmpty) {
      return Center(child: Text('No Teams Created Yet!'));
    }

    return ListView(
      addAutomaticKeepAlives: false,
      children: <Widget>[
        //** Dropdown for selecting team from teams already saved */
        Container(
          padding: EdgeInsets.all(20),
          child: DropdownButtonFormField<GanttTeam>(
              decoration: InputDecoration(labelText: 'Select Team'),
              value: selected,
              onChanged: (GanttTeam? value) {
                setState(() {
                  selected = value;
                });
              },
              items: ModelStore.instance.teams!.entries
                  .map((e) => DropdownMenuItem<GanttTeam>(
                      value: e.value, child: Text(e.value.name)))
                  .toList()),
        ),
        //** Text field with user name */
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: nameController,
            autocorrect: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Member Name',
            ),
            onChanged: (text) {
              setState(() {
                name = text;
              });
            },
          ),
        ),
        //** Button for adding member */
        Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
                onPressed: () {
                  onCreate();
                },
                child: const Text('Add Member',
                    style: TextStyle(color: Colors.black, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  primary: Color.fromARGB(255, 255, 255, 255),
                  minimumSize: const Size(350, 100),
                ))),
      ],
    );
  }
}
