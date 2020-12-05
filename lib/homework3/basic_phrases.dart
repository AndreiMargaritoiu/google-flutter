import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Basic Phases'),
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _phrases = <String>[
    'buna',
    'buna (en)',
    'mancare',
    'mancare (en)',
    'alergat',
    'alergat (en)',
    'somn',
    'somn (en)',
    'codat',
    'codat (en)',
  ];

  void _playSound(int index) {
    setState(() {
      switch (index) {
        case 0:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=buna&tl=ro&total=1&idx=0&textlen=20');
          break;
        case 1:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=hi&tl=en&total=1&idx=0&textlen=20');
          break;
        case 2:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=mancare&tl=ro&total=1&idx=0&textlen=20');
          break;
        case 3:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=food&tl=en&total=1&idx=0&textlen=20');
          break;
        case 4:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=alergat&tl=ro&total=1&idx=0&textlen=20');
          break;
        case 5:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=running&tl=en&total=1&idx=0&textlen=20');
          break;
        case 6:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=somn&tl=ro&total=1&idx=0&textlen=20');
          break;
        case 7:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=sleep&tl=en&total=1&idx=0&textlen=20');
          break;
        case 8:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=codat&tl=ro&total=1&idx=0&textlen=20');
          break;
        case 9:
          _audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=coding&tl=en&total=1&idx=0&textlen=20');
          break;
      }
    });
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
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _phrases.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 32.0,
                      crossAxisSpacing: 32.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => _playSound(index),
                        child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            duration: const Duration(milliseconds: 100),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                _phrases.elementAt(index),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
