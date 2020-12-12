import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class Movie {
  Movie(
      {@required this.id,
      @required this.title,
      @required this.year,
      @required this.runTime,
      @required this.rating,
      @required this.cover});

  factory Movie.fromJson(dynamic item) {
    return Movie(
      id: item['id'],
      title: item['title'],
      year: item['year'],
      runTime: item['runtime'],
      rating: item['rating'],
      cover: item['small_cover_image'],
    );
  }

  final int id;
  String title;
  final int year;
  final int runTime;
  final num rating;
  final String cover;

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, year: $year, runTime: $runTime, '
        'rating: $rating, cover: $cover}';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Movies'),
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
  List<Movie> _movies = <Movie>[];
  List<String> dropDown = <String>[
    'default',
    'rating ascending',
    'rating descending',
    'runtime ascending',
    'runtime descending',
    'year ascending',
    'year descending',
  ];
  bool isError = false, filterPressed = false;
  TextEditingController inputHolder = TextEditingController();
  int _radioValue = 0;

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async {
    final Response response = await get('https://yts.mx/api/v2/list_movies.json');
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final Map<String, dynamic> data = responseData['data'];
    final List<dynamic> movies = data['movies'];

    for (int i = 0; i < movies.length; i++) {
      final Map<String, dynamic> item = movies[i];
      final Movie movie = Movie(
        id: item['id'],
        title: item['title'],
        year: item['year'],
        runTime: item['runtime'],
        rating: item['rating'],
        cover: item['medium_cover_image'],
      );
      if (movie.title.length > 33) {
        movie.title = '${movie.title.substring(0, 30)} ...';
      }

      _movies.add(movie);
    }

    setState(() {
      // movies changed
    });
  }

  void sortItems(String value) {
    switch (value) {
      case 'rating ascending':
        _movies.sort((Movie first, Movie second) => first.rating.compareTo(second.rating));
        break;
      case 'rating descending':
        _movies.sort((Movie first, Movie second) => second.rating.compareTo(first.rating));
        break;
      case 'runtime ascending':
        _movies.sort((Movie first, Movie second) => first.runTime.compareTo(second.runTime));
        break;
      case 'runtime descending':
        _movies.sort((Movie first, Movie second) => second.runTime.compareTo(first.runTime));
        break;
      case 'year ascending':
        _movies.sort((Movie first, Movie second) => first.year.compareTo(second.year));
        break;
      case 'year descending':
        _movies.sort((Movie first, Movie second) => second.year.compareTo(first.year));
        break;
      case 'default':
        _movies.sort((Movie first, Movie second) => second.id.compareTo(first.id));
        break;
    }
  }

  void filterItems() {
    setState(() {
      if (inputHolder.text.isEmpty) {
        isError = true;
      } else {
        switch (_radioValue) {
          case 0:
            _movies = _movies.where((Movie movie) => movie.year == int.parse(inputHolder.text)).toList();
            break;
          case 1:
            _movies = _movies.where((Movie movie) => movie.year > int.parse(inputHolder.text)).toList();
            break;
          case 2:
            _movies = _movies.where((Movie movie) => movie.year < int.parse(inputHolder.text)).toList();
            break;
        }
        filterPressed = true;
        inputHolder.clear();
        isError = false;
      }
    });
  }

  void restoreItems() {
    _movies.clear();
    getMovies();
    filterPressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.title),
          DropdownButton<String>(
              underline: Container(),
              icon: const Icon(Icons.sort, color: Colors.white),
              items: dropDown.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  sortItems(value);
                });
              })
        ],
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter the year',
                        errorText: isError ? 'please enter a number' : null,
                      ),
                      controller: inputHolder,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  FlatButton(
                    onPressed: !filterPressed ? filterItems : restoreItems,
                    color: Colors.grey,
                    child: Text(
                      !filterPressed ? 'Filter' : 'Clear',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio<int>(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (int value) => setState(() {
                    _radioValue = value;
                  }),
                ),
                const Text(
                  'equal',
                  style: TextStyle(fontSize: 16.0),
                ),
                Radio<int>(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (int value) => setState(() {
                    _radioValue = value;
                  }),
                ),
                const Text(
                  'bigger',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Radio<int>(
                  value: 2,
                  groupValue: _radioValue,
                  onChanged: (int value) => setState(() {
                    _radioValue = value;
                  }),
                ),
                const Text(
                  'smaller',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _movies.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 160,
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Image.network('${_movies[index].cover}'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _movies[index].title,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Year ${_movies[index].year.toString()}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Runtime: ${_movies[index].runTime.toString()}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text(
                                  'Rating: ${_movies[index].rating.toString()}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
