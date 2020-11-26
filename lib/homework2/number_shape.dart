import 'package:flutter/material.dart';
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
      home: const MyHomePage(title: 'Number shape'),
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
  int inputNumber;
  String outputText;
  bool isEmpty = true;
  TextEditingController inputHolder = TextEditingController();

  void _checkNumber() {
    setState(() {
      if (isEmpty) {
        outputText = 'Please enter a number';
        inputNumber = null;
      } else if (inputNumber == 1) {
        outputText = 'Number $inputNumber is SQUARE and TRIANGULAR';
      } else {
        if (_isSquare(inputNumber) && _isTriangular(inputNumber)) {
          outputText = 'Number $inputNumber is SQUARE and TRIANGULAR';
        } else if (_isSquare(inputNumber)) {
          outputText = 'Number $inputNumber is SQUARE';
        } else if (_isTriangular(inputNumber)) {
          outputText = 'Number $inputNumber is TRIANGULAR';
        } else {
          outputText = 'Number $inputNumber is not a SQUARE nor TRIANGULAR';
        }
      }
      inputHolder.clear();
      isEmpty = true;
    });
  }

  bool _isSquare(int input) {
    for (int i = 0; i < input / 2; i++) {
      if (i * i == input) {
        return true;
      }
    }
    return false;
  }

  bool _isTriangular(int input) {
    for (int i = 0; i < input / 2; i++) {
      if (i * i * i == input) {
        return true;
      }
    }
    return false;
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
            // ignore: prefer_const_literals_to_create_immutables
            Container(
              margin: const EdgeInsets.all(15.0),
              child: Column(
                  children: <Widget>[
                    const Text(
                      'Please input a number to see if it is a square or a triangle',
                    ),
                    TextField(
                      controller: inputHolder,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (String value) {
                        setState(() {
                          if (value.isEmpty) {
                            isEmpty = true;
                          } else {
                            inputNumber = int.parse(value);
                            isEmpty = false;
                          }
                        });
                      },
                    ),
                  ]
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _checkNumber();
          showDialog<AlertDialog>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(inputNumber.toString()),
                content: Text(outputText),
              );
            },
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
