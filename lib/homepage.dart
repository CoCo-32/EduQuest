import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'loginpage.dart';


class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Lesson Page'),
    Text('Assessment Page'),
    Text('Quiz Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ButtonStyle _buttonStyle(int index) {
    return ElevatedButton.styleFrom(
      backgroundColor: _selectedIndex == index ? Colors.blue : Colors.white70,
      foregroundColor: _selectedIndex == index ? Colors.white : Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduQuest', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              ElevatedButton(
                style: _buttonStyle(0),
                onPressed: () => _onItemTapped(0),
                child: const Text('Lessons'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: _buttonStyle(1),
                onPressed: () => _onItemTapped(1),
                child: const Text('Assessments'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: _buttonStyle(2),
                onPressed: () => _onItemTapped(2),
                child: const Text('Quiz'),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}