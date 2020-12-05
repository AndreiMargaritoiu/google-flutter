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
  List<int> _listRed = <int>[];
  List<int> _listGreen = <int>[];
  bool _isRedsTurn = true, _gameOver = false, _clearPressed = false;

  void _addToList(int index) {
    setState(() {
      _clearPressed = false;
      if (!_gameOver && _boxWasPressed(index)) {
        if (_isRedsTurn) {
          _listRed.add(index);
          if (_checkWin(_listRed) != null || _listRed.length == 5) {
            _gameOver = true;
            _listRed = _listRed.where((int element) => _checkWin(_listRed).contains(element)).toList();
            _listGreen.clear();
          }
          _isRedsTurn = false;
        } else {
          _listGreen.add(index);
          if (_checkWin(_listGreen) != null) {
            _gameOver = true;
            _listGreen = _listGreen.where((int element) => _checkWin(_listGreen).contains(element)).toList();
            _listRed.clear();
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

  List<int> _checkWin(List<int> _listIndexes) {
    final List<List<int>> _winningPositionsList = <List<int>>[
      <int>[0, 1, 2],
      <int>[3, 4, 5],
      <int>[6, 7, 8],
      <int>[0, 3, 6],
      <int>[1, 4, 7],
      <int>[2, 5, 8],
      <int>[0, 4, 8],
      <int>[2, 4, 6]
    ];
    for (final List<int> _winningPositions in _winningPositionsList) {
      if (_winningStrike(_listIndexes, _winningPositions)) {
        return _winningPositions;
      }
    }
    return null;
  }

  bool _winningStrike(List<int> _listIndexes, List<int> _indexes) {
    return _listIndexes.contains(_indexes.elementAt(0)) &&
        _listIndexes.contains(_indexes.elementAt(1)) &&
        _listIndexes.contains(_indexes.elementAt(2));
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          ),
                          duration: const Duration(milliseconds: 300),
                        ),
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
