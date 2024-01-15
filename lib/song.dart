import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'sensor_screen.dart';
import 'package:just_audio/just_audio.dart';

class SongDetailScreen extends StatefulWidget {
  final dynamic song;

  SongDetailScreen({required this.song});

  @override
  _SongDetailScreenState createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool isPlaying;
  late AudioPlayer _audioPlayer;
  GyroscopeEvent? _gyroData;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    isPlaying = false;

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroData = event;
        _updatePlaybackSpeed();
      });
    });
  }

  Future<void> _initializePlayer() async {
    await _audioPlayer.setUrl(widget.song.previews[0]);
  }

  void _playPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _updatePlaybackSpeed() {
    if (_gyroData != null) {
      double gyroSpeed = _gyroData!.x.abs() + _gyroData!.y.abs() + _gyroData!.z.abs();
      double newSpeed = 1.0 + (gyroSpeed * 1.2); 
      _audioPlayer.setSpeed(newSpeed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ID: ${widget.song.id}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Name: ${widget.song.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _playPause();
                  setState(() {
                    isPlaying = !isPlaying;
                    isPlaying ? _controller.forward() : _controller.reverse();
                  });
                },
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _controller,
                ),
                label: Text(isPlaying ? 'Pause' : 'Play'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SensorsScreen()),
                  );
                },
                child: Text('Go to Sensors Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
