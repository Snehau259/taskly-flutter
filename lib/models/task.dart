import 'package:flutter/foundation.dart';

class Task {
  String content;
  bool done;
  DateTime timestamp;

  Task({required this.content, required this.timestamp, required this.done});

  Map toMap() {
    return {"content": content, "done": done, "date": timestamp};
  }

  factory Task.fromMap(Map map)
  {
     return Task(content: map["content"], timestamp: map["date"], done: map["done"]);
  }
}
