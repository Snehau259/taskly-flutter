import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly_app/models/task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  late double deviceWidth, deviceHeight;
  String? taskContent;
  Box? box;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[500],
        toolbarHeight: deviceHeight * 0.15,
      ),
      body: viewTaskLists(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () {
          addNewTask();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addNewTask() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: Text('Add task'),
            content: TextField(
              onSubmitted: (value) {
                setState(() {
                  taskContent = value;
                  // viewTasks();
                });
              },
              onChanged: (value) {},
            ),
          );
        });
  }

  Widget viewTaskLists() {
    return FutureBuilder(
        // future: Future.delayed(Duration(seconds: 2)),
        future: Hive.openBox('tasks'),
        builder: (BuildContext _context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            box = snapshot.data;
            print(box);
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return singleTaskTile();
            }
          } else {
            print(snapshot.connectionState);
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget singleTaskTile() {
    return ListView(
      children: [
        ListTile(
            title: Text(
              'Eat well000',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, fontSize: 20),
            ),
            subtitle: Text(DateTime.now().toString()),
            trailing: Icon(Icons.check_box_outline_blank_outlined,
                color: Colors.red[500]))
      ],
    );
  }
}
