import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Paste text paragraph into the text field.'),
          Padding(
            padding: const EdgeInsets.all(32),
            child: TextField(
              keyboardType: TextInputType.text,
              maxLines: null,
              onChanged: (String text) {
                _text = text;
                ableToStart(true);
              },
              onEditingComplete: () => ableToStart(true),
              onSubmitted: (String text) {
                _text = text;
                ableToStart(true);
              },
            ),
          ),
          Text(
            _word,
            style: TextStyle(fontSize: 150, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Speed (ms)'),
              ),
              Container(
                color: Colors.black12,
                width: 40,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String text) => _wordDurationMilliseconds = int.parse(text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  child: Text('Start'),
                  color: _ableToStart ? Colors.green : Colors.lightGreen,
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
                  color: Colors.green,
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
}
