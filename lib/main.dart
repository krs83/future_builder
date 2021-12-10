import 'package:flutter/material.dart';
import 'package:future_builder/secure/key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Weather in Lugansk city';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=Luhansk&units=metric&appid=$key');

  _getWeather() async {
    double _temperature = 0;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = await convert.jsonDecode(response.body);
      setState(() {
        _temperature = jsonResponse['main']['temp'];
      });
    } else {
      _temperature = 0;
      print('Its no data to show');
    }
    return _temperature.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder(
        future: _getWeather(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('The temperature: ${snapshot.data} °C'),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
