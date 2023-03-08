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
          if (snapshot.connectionState == ConnectionState.done) {
            box = snapshot.data;
            print("snp data ${box}");
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return singleTaskTile();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget singleTaskTile() {
    // Task newTask =
    //     new Task(content: "Go for a trip", timestamp: DateTime.now(), done: false);
    //     box?.add(newTask.toMap());
    // print("new task to map=${newTask.toMap()}");

    List tasks = box!.values.toList();
    // print("tasks=${tasks}");

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var task = Task.fromMap(tasks[index]);
        return ListTile(
            title: Text(
              task.content,
              style: TextStyle(
                  decoration: task.done ? TextDecoration.lineThrough : null,
                  fontSize: 20),
            ),
            subtitle: Text(task.timestamp.toString()),
            trailing: task.done
                ? Icon(Icons.check_box_outlined, color: Colors.red[500])
                : Icon(Icons.check_box_outline_blank_outlined,
                    color: Colors.red[500]));
      },
    );
  }
}
