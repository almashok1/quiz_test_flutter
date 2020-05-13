import 'dart:io';

import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final File file;
  Search({this.file});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var foundQuestions = List<Widget>();
  TextEditingController _controller;
  var list;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    list = widget.file.readAsLinesSync();
    _findQuestions();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Color(0xFF1C1428).withOpacity(0.9),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white70,
        backgroundColor: Colors.deepPurple[900],
        onPressed: () {
          _findQuestions();
          _controller.text = '';
        }, 
        child: Center(
          child: Text("Все")
        )
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1428),
        title: TextField(
          style: TextStyle(color: Colors.white),
          controller: _controller,
            onChanged: (value) {
              _findQuestions(value);
            },
            onSubmitted: (value) {
              _findQuestions(value);
            },
            autofocus: true,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none, hintText: 'Поиск...'),
          ),
      ),
        body: Container(
      child: ListView.builder(
        itemBuilder: (context, index) => foundQuestions[index],
        itemCount: foundQuestions.length,
      ),
    ));
  }

  _findQuestions([String text]) {
    foundQuestions = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].contains('<question>')) {
        if (text == null) {
          foundQuestions.add(
            Card(
              color: Colors.deepPurple[900].withOpacity(0.5),
              child: ListTile(
                title: Text(
                  list[i].replaceFirst("<question>", "").trim(),
                  style: TextStyle(color: Colors.white)
                ),
                subtitle: Text(
                  i+1<list.length ? list[i+1].replaceFirst("<variant>", "").trim() : "НЕТ ДАННЫХ",
                  style: TextStyle(color: Colors.green[400], fontSize: 15.0)
                ),
              )
            )
          );
        }
        else if (list[i].trim().toLowerCase().contains(text.toLowerCase())) {
          foundQuestions.add(
            Card(
              color: Colors.deepPurple[900].withOpacity(0.5),
              child: ListTile(
                title: Text(
                  list[i].replaceFirst("<question>", "").trim(),
                  style: TextStyle(color: Colors.white)
                ),
                subtitle: Text(
                  i+1<list.length ? list[i+1].replaceFirst("<variant>", "").trim() : "НЕТ ДАННЫХ",
                  style: TextStyle(color: Colors.green[400], fontSize: 15.0)
                ),
              )
            )
          );
        }
      }
    }
    setState(() {});
  }
}
