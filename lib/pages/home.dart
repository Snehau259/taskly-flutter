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
    print("task content from main home=${taskContent}");
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Taskly",style: TextStyle(fontSize: 30),),
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
              onChanged: (value) {
                taskContent = value;
              },
              onSubmitted: (value) {
             
                setState(() {
                  Navigator.pop(_context);
                 
                });
                print("taskContent from show dialog ${taskContent}");
                if (taskContent != null) {
                  Task newTask = new Task(
                      content: taskContent!,
                      timestamp: DateTime.now(),
                      done: false);
                  box?.add(newTask.toMap());
                }
              },
            ),
          );
        });
  }

  Widget viewTaskLists() {
    return FutureBuilder(
        future: Hive.openBox('tasks'),
        builder: (BuildContext _context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
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

    List tasks = box!.values.toList();
    print("tasks=${tasks}");

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
                  color: Colors.red[500]),
          onTap: () {
            setState(() {
              task.done = !task.done;
              box?.putAt(index, task.toMap());
            });
          },
          onLongPress: () {
            box?.deleteAt(index);
            setState(() {});
          },
        );
      },
    );
  }
}
