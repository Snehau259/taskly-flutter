import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  late double deviceWidth, deviceHeight;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: deviceWidth * 0.15,
        backgroundColor: Colors.cyan,
      ),
      body: ListView(children: [
        ListTile(
          title: Text(
            'Eat well',
            style:
                TextStyle(decoration: TextDecoration.lineThrough, fontSize: 20),
          ),
          subtitle: Text(DateTime.now().toString()),
          trailing: Icon(Icons.check_box_outline_blank_outlined,
              color: Colors.red[500]),
        )
      ]),
    );
  }
}
