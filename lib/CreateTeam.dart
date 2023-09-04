import 'package:flutter/material.dart';
import 'Models/GanttTeam.dart';
import 'Models/ModelStore.dart';

class CreateTeam extends StatefulWidget {
  final Function onCreated;
  
  const CreateTeam({Key? key, required this.onCreated}) : super(key: key);

  @override
  State<CreateTeam> createState() => CreateTeamState();
}


class CreateTeamState extends State<CreateTeam> {
  TextEditingController nameController = TextEditingController();
  String name = '';


  void onCreate() async {
      final team = await ModelStore.instance.createTeam(name);
      widget.onCreated(team);
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
            addAutomaticKeepAlives: false,
            children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Team Name',
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
                      onCreate();
                    },
                    child: const Text('Create Team',
                        style: TextStyle(
                            color: Colors.black, fontSize: 24)),
                    style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    primary: Color.fromARGB(255, 255, 255, 255),
                    minimumSize: const Size(350, 100),
                  ))
                ),
            ],);
  }
} 