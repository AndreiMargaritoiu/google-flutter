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
      home: const MyHomePage(title: 'Currency convertor'),
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
  double amountToBeConverted = 0;
  double convertedAmount = 0;
  bool isEmpty = true;
  bool isError = false;

  void _convertSum() {
    setState(() {
      if (isEmpty) {
        isError = true;
      } else {
        convertedAmount = amountToBeConverted * 4.87;
        isError = false;
      }
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
            Image.network(
                'https://www.unibank.com.au/-/media/unibank/money-matters/money-tips/where-does-my-money-go/where-does-money-go-og.ashx'),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter the amount in EUR',
                  errorText: isError ? 'please enter a number' : null,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
                onChanged: (String value) {
                  setState(() {
                    if (value.isEmpty) {
                      isEmpty = true;
                    } else {
                      amountToBeConverted = double.parse(value);
                      isEmpty = false;
                    }
                  });
                },
              ),
            ),
            FlatButton(
              onPressed: _convertSum,
              color: Colors.grey,
              child: const Text(
                'Convert!',
              ),
            ),
            Text(
              convertedAmount.toString() + ' RON',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
