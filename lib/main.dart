import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _timer;
  var _textArray = List(0);
  var _counter = 0;
  var _word = '';
  var _text = '';
  var _wordDurationMilliseconds = 150;
  var _ableToStart = false;
  var _nightMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _nightMode ? Colors.blueGrey[900] : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Paste text paragraph into the text field.',
                style: getTextStyle(_nightMode, 28),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Container(
                  color: _nightMode ? Colors.blueGrey[800] : Colors.blueGrey[200],
                  child: TextField(
                    style: _nightMode ? TextStyle(color: Colors.white) : TextStyle(color: Colors.black),
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    onChanged: (String text) {
                      _text = text;
                      ableToStart(true);
                    },
                    onEditingComplete: () => ableToStart(true),
                    onSubmitted: (String text) {
                      _text = text;
                      text = '';
                      ableToStart(true);
                    },
                  ),
                ),
              ),
            ],
          ),
          Text(
            _word,
            style: getTextStyle(_nightMode, 125),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Speed (ms)', style: getTextStyle(_nightMode, 12)),
              ),
              Container(
                color: Colors.black12,
                width: 40,
                child: TextField(
                  style: getTextStyle(_nightMode, 12),
                  keyboardType: TextInputType.number,
                  onChanged: (String text) => _wordDurationMilliseconds = int.parse(text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  child: Text('Start'),
                  color: Colors.green,
                  onPressed: _ableToStart ? () => onSubmit(_text) : null,
                ),
              ),
              MaterialButton(
                  child: Text('Stop'),
                  color: Colors.red,
                  onPressed: () {
                    _timer?.cancel();
                    ableToStart(true);
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  child: Text('Reset'),
                  color: Colors.blue,
                  onPressed: () {
                    _timer?.cancel();
                    _counter = 0;
                    ableToStart(true);
                    setState(() {
                      _word = '';
                    });
                  },
                ),
              ),
              MaterialButton(
                child: Icon(Icons.lightbulb),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _nightMode = !_nightMode;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void ableToStart(bool value) {
    var words = _text.split(' ');

    if (words.length < 2) {
      setState(() {
        _ableToStart = false;
      });
      return;
    }

    setState(() {
      _ableToStart = value;
    });
  }

  void startRepeatingTimer() async {
    ableToStart(false);
    _timer = Timer.periodic(Duration(milliseconds: _wordDurationMilliseconds), (Timer t) => printNextWord(t));
  }

  void printNextWord(Timer t) {
    setState(() {
      _word = _textArray[_counter];
    });

    if (_counter == _textArray.length - 1) {
      t.cancel();
      _counter = 0;
      ableToStart(true);
      return;
    }

    _counter++;
  }

  void onSubmit(String text) {
    _textArray = text.split(' ');
    startRepeatingTimer();
  }

  TextStyle getTextStyle(bool night, double size) {
    var color = night ? Colors.white : Colors.black;
    return TextStyle(color: color, fontSize: size);
  }
}
