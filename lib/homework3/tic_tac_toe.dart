import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'tic-tac-toe'),
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
  final List<int> _listRed = <int>[];
  final List<int> _listGreen = <int>[];
  bool _isRedsTurn = true, _gameOver = false, _clearPressed = false;

  void _addToList(int index) {
    setState(() {
      _clearPressed = false;
      if (!_gameOver && _boxWasPressed(index)) {
        if (_isRedsTurn) {
          _listRed.add(index);
          if (_checkWin(_listRed) || _listRed.length == 5) {
            _gameOver = true;
          }
          _isRedsTurn = false;
        } else {
          _listGreen.add(index);
          if (_checkWin(_listGreen)) {
            _gameOver = true;
          }
          _isRedsTurn = true;
        }
      }
    });
  }

  void _resetMatch() {
    setState(() {
      _gameOver = false;
      _clearPressed = true;
      _listRed.clear();
      _listGreen.clear();
      _isRedsTurn = true;
    });
  }

  bool _boxWasPressed(int index) {
    return !_listRed.contains(index) && !_listGreen.contains(index);
  }

  bool _checkWin(List<int> _listIndexes) {
    return _winningStrike(_listIndexes, 0, 1, 2) ||
        _winningStrike(_listIndexes, 3, 4, 5) ||
        _winningStrike(_listIndexes, 6, 7, 8) ||
        _winningStrike(_listIndexes, 0, 3, 6) ||
        _winningStrike(_listIndexes, 1, 4, 7) ||
        _winningStrike(_listIndexes, 2, 5, 8) ||
        _winningStrike(_listIndexes, 0, 4, 8) ||
        _winningStrike(_listIndexes, 2, 4, 6);
  }

  bool _winningStrike(
      List<int> _listIndexes, int index1, int index2, int index3) {
    return _listIndexes.contains(index1) &&
        _listIndexes.contains(index2) &&
        _listIndexes.contains(index3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => _addToList(index),
                        child: AnimatedContainer(
                            decoration: BoxDecoration(
                          color: _clearPressed
                              ? Colors.white
                              : _listRed.contains(index)
                                  ? Colors.red
                                  : _listGreen.contains(index)
                                      ? Colors.green
                                      : Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ), duration: const Duration(milliseconds: 300),),
                      );
                    })),
            if (_gameOver)
              FlatButton(
                onPressed: _resetMatch,
                color: Colors.grey,
                child: const Text(
                  'Try again!',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
