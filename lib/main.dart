import 'package:atlas_flutter_app/sensor_data_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Atlas Sensor Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () => _navigateToSensorDataWidget("userAccelerometer"),
                child: const Text("See accelerometer data")),
            ElevatedButton(
                onPressed: () => _navigateToSensorDataWidget("gyroscope"),
                child: const Text("See gyroscope data")),
          ],
        ),
      ),
    );
  }

  _navigateToSensorDataWidget(String type) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text("$type Sensor Data"),
          ),
          body: SensorDataWidget(sensorType: type));
    }));
  }
}
