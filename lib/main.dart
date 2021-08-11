import 'dart:typed_data';

import 'package:atlas_flutter_app/sensor_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
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
  void initState() {
    _configureAmplify();
    super.initState();
  }

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
                onPressed: () => onTestApi(), //_navigateToSensorDataWidget("userAccelerometer"),
                child: const Text("See accelerometer data")),
            ElevatedButton(
                onPressed: () => _navigateToSensorDataWidget("gyroscope"),
                child: const Text("See gyroscope data")),
          ],
        ),
      ),
    );
  }

  void _configureAmplify() async {
    // Add the following line to add API plugin to your app.
    // Auth plugin needed for IAM authorization mode, which is default for REST API.
    Amplify.addPlugins([AmplifyAPI(), AmplifyAuthCognito()]);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  void onTestApi() async {
    if (Amplify.isConfigured) {
      try {
        RestOptions options = RestOptions(
            path: '/api',
            body: Uint8List.fromList('{\'name\':\'Mow the lawn\'}'.codeUnits)
        );
        RestOperation restOperation = Amplify.API.post(
            restOptions: options
        );
        RestResponse response = await restOperation.response;
        print('POST call succeeded');
        print(String.fromCharCodes(response.data));
      } on ApiException catch (e) {
        print('POST call failed: $e');
      }
    } else {
      print('Amplify not configured!');
    }

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
