// ignore_for_file: dead_code

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'sensor_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SensorDataWidget extends StatefulWidget {
  const SensorDataWidget({Key? key, required this.sensorType})
      : super(key: key);
  final String sensorType;

  @override
  _SensorDataWidgetState createState() => _SensorDataWidgetState();
}

class _SensorDataWidgetState extends State<SensorDataWidget> {
  late StreamSubscription _subscription;
  var _sensorData = SensorData(x: 0, y: 0, z: 0);

  @override
  void initState() {
    _subscription = _listen(widget.sensorType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text("x: ${_sensorData.x}"),
        Text("y: ${_sensorData.y}"),
        Text("z: ${_sensorData.z}"),
        ElevatedButton(
          child: const Text("Send data to server"),
          onPressed: () => _sendSensorData(),
        )
      ],
    ));
  }

  StreamSubscription _listen(sensorType) {
    switch (sensorType) {
      case "accelerometer":
        return accelerometerEvents.listen((event) {
          _setSensorData(event.x, event.y, event.z);
        });
        break;

      case "userAccelerometer":
        return userAccelerometerEvents.listen((event) {
          _setSensorData(event.x, event.y, event.z);
        });
        break;

      case "gyroscope":
        return gyroscopeEvents.listen((event) {
          _setSensorData(event.x, event.y, event.z);
        });
        break;

      default:
        throw "Unknown sensor type: $sensorType";
    }
  }

  _setSensorData(x, y, z) {
    setState(() {
      _sensorData = SensorData(x: x, y: y, z: z);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _sendSensorData() async {
    final response = await http.post(
      Uri.parse('https://postman-echo.com/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(_sensorData),
    );

    if (response.statusCode == 200) {
      _showSnackBar('Successfully sent sensor data.');
    } else {
      _showSnackBar('Failed to send sensor data.');
    }
  }

  void _showSnackBar(text) {
    final snackBar = SnackBar(
      content:  Text('$text'),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
