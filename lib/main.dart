import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Mi Aplicación', home: RadioApp());
  }
}

class RadioApp extends StatefulWidget {
  @override
  _RadioAppState createState() => _RadioAppState();
}

class _RadioAppState extends State<RadioApp> {
  AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 0.5; // Volumen inicial

  @override
  void initState() {
    super.initState();
    _audioPlayer.setUrl("https://streaming2.mundoradio.com.ar/8362/stream");
    _audioPlayer.setVolume(_volume);

    // Maneja la suspensión y reanudación
    _audioPlayer.play();
    _audioPlayer.setLoopMode(LoopMode.all);
  }

  void _playPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _setVolume(double volume) {
    setState(() {
      _volume = volume;
      _audioPlayer.setVolume(volume);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Logo en la parte superior
          Positioned(
            top: 50,
            left: (MediaQuery.of(context).size.width - 200) / 2,
            child: Image.asset('assets/logo.png', width: 200, height: 100),
          ),
          // Controles en la parte inferior
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Control de volumen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_mute),
                      onPressed: () => _setVolume(0.0),
                    ),
                    Slider(
                      value: _volume,
                      onChanged: _setVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                    ),
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () => _setVolume(1.0),
                    ),
                  ],
                ),
                // Botón de play/stop
                IconButton(
                  icon: Icon(
                    _audioPlayer.playing ? Icons.stop : Icons.play_arrow,
                    size: 40,
                  ),
                  onPressed: _playPause,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
