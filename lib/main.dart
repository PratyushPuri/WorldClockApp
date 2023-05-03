//main file


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Clock',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 40.0),
        ),
      ),
      home: const WorldClockScreen(),
    );
  }
}

class WorldClockScreen extends StatefulWidget {
  const WorldClockScreen({Key? key}) : super(key: key);

  @override
  _WorldClockScreenState createState() => _WorldClockScreenState();
}

class _WorldClockScreenState extends State<WorldClockScreen> {
  late List<String> locations;
  late String selectedLocation;
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    locations = tz.timeZoneDatabase.locations.keys.toList();
    selectedLocation = locations.first;
    currentTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final tzLocation = tz.getLocation(selectedLocation);
    final tzNow = tz.TZDateTime.now(tzLocation);
    final formattedTime = DateFormat.jm().format(tzNow);
    final formattedDate = DateFormat.yMMMMd().format(tzNow);

    return Scaffold(
      appBar: AppBar(
        title: const Text('World Clock'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50.0,
            child: DropdownButton<String>(
              value: selectedLocation,
              onChanged: (String? value) {
                setState(() {
                  selectedLocation = value!;
                });
              },
              items: locations
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedTime,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentTime = DateTime.now();
                });
              },
              child: const Text('Refresh Time'),
            ),
          ),
        ],
      ),
    );
  }
}
