import 'package:flutter/material.dart';
import 'Models/GanttChart.dart';
import 'Models/ModelStore.dart';

class CreateChart extends StatefulWidget {
  final Function onCreated;
  
  const CreateChart({Key? key, required this.onCreated}) : super(key: key);

  @override
  State<CreateChart> createState() => CreateChartState();
}


class CreateChartState extends State<CreateChart> {
  TextEditingController nameController = TextEditingController();
  String name = '';


  void onCreate() async {
      final chart = await ModelStore.instance.createChart(name);
      widget.onCreated(chart);
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
                      labelText: 'Chart Name',
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
                    child: const Text('Create Chart',
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