import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Guess my number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int numberToBeGuessed, inputNumber;
  String result, buttonText = 'Guess';
  bool isEmpty = true, guessPressed = false, okPressed = false;
  TextEditingController nameHolder = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      numberToBeGuessed = _generateRandomNumber();
    });
  }

  int _generateRandomNumber() {
    final Random random = Random();
    final int returned = random.nextInt(101);
    print(returned);
    return returned;
  }

  void _guessAction(int inputNumber) {
    setState(() {
      if (!isEmpty) {
        guessPressed = true;
        if (inputNumber < numberToBeGuessed) {
          result = 'You tried ${inputNumber.toString()}\nTry higher';
        } else if (inputNumber > numberToBeGuessed) {
          result = 'You tried ${inputNumber.toString()}\nTry lower';
        } else {
          result = 'You tried ${inputNumber.toString()}\nYou guessed right';
        }
      }
      nameHolder.clear();
      isEmpty = true;
    });
  }

  void _tryAgainAction() {
    if (!okPressed) {
      Navigator.of(context).pop();
    }
    nameHolder.clear();
    setState(() {
      guessPressed = false;
      inputNumber = null;
      buttonText = 'Guess';
      okPressed = false;
      numberToBeGuessed = _generateRandomNumber();
    });
  }

  void _okAction() {
    Navigator.of(context).pop();
    setState(() {
      okPressed = true;
      buttonText = 'Reset';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  const Text(
                    'I\'m thinking of a number between 1 and 100.',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'It\' s your turn to guess my number!',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (guessPressed)
                    Text(
                      result,
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ])),
            Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 200,
                        child: Card(
                          semanticContainer: true,
                          child: Column(children: <Widget>[
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                child:
                                    const Text('Try a number!', style: TextStyle(color: Colors.black, fontSize: 22.0))),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                child: TextField(
                                    controller: nameHolder,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                    onChanged: (String value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          isEmpty = true;
                                        } else {
                                          inputNumber = int.parse(value);
                                          isEmpty = false;
                                        }
                                      });
                                    })),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                    width: 120.0,
                                    height: 40.0,
                                    child: FlatButton(
                                      onPressed: () {
                                        if (okPressed) {
                                          _tryAgainAction();
                                        } else {
                                          _guessAction(inputNumber);
                                          if (inputNumber == numberToBeGuessed)
                                            showDialog<AlertDialog>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'You guessed right!',
                                                    ),
                                                    content: Row(children: <Widget>[
                                                      Text('It was ${numberToBeGuessed.toString()}')
                                                    ]),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: const Text('Try Again!'), onPressed: _tryAgainAction),
                                                      FlatButton(child: const Text('OK'), onPressed: _okAction)
                                                    ],
                                                  );
                                                });
                                        }
                                      },
                                      color: Colors.grey,
                                      child: Text(
                                        buttonText,
                                      ),
                                    )))
                          ]),
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
