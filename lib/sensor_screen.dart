import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsScreen extends StatefulWidget {
  @override
  _SensorsScreenState createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  GyroscopeEvent? _gyroData;
  AccelerometerEvent? _accelerometerData;

  @override
  void initState() {
    super.initState();

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroData = event;
      });
    });

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerData = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_gyroData != null)
                Text(
                  'Gyro Data: X: ${_gyroData!.x.toStringAsFixed(2)}, Y: ${_gyroData!.y.toStringAsFixed(2)}, Z: ${_gyroData!.z.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              if (_accelerometerData != null)
                Text(
                  'Accelerometer Data: X: ${_accelerometerData!.x.toStringAsFixed(2)}, Y: ${_accelerometerData!.y.toStringAsFixed(2)}, Z: ${_accelerometerData!.z.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:const Text('Back to Song Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
