import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

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

class _RadioAppState extends State<RadioApp> with WidgetsBindingObserver {
  AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 0.5; // Volumen inicial
  bool _isMenuOpen = false; // Estado del menú hamburguesa

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Añade el observador
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    await _audioPlayer.setUrl(
      "https://streaming2.mundoradio.com.ar/8362/stream",
    );
    _audioPlayer.setVolume(_volume);
    _audioPlayer.play();
    _audioPlayer.setLoopMode(LoopMode.all);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Elimina el observador
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Cuando la aplicación está en segundo plano, aseguramos que el reproductor siga activo
    } else if (state == AppLifecycleState.resumed) {
      // Cuando la aplicación vuelve a primer plano
    }
  }

  void _playPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {});
  }

  void _setVolume(double volume) {
    setState(() {
      _volume = volume;
      _audioPlayer.setVolume(volume);
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  Future<void> _launchWhatsApp() async {
    final url =
        'whatsapp://send?phone=5492214980001&text=Hola, estoy usando la aplicación de Radio Andesur!';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir WhatsApp';
    }
  }

  void _shareApp() {
    Share.share(
      "Estoy usando la aplicación oficial de Radio Andesur! Descárgala en: https://play.google.com/store/apps/details?id=appinventor.ai_grupomascompras.RadioAndesur&hl=es_419",
    );
  }

  Future<bool> _onWillPop() async {
    // Evita cerrar la aplicación y simplemente vuelve a minimizarla
    return false; // Cambia a 'false' para prevenir el cierre
  }

  void _closeApp() {
    // Cierra la aplicación
    SystemNavigator.pop(); // Esto simula el efecto de "cerrar" la aplicación
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Evita que se cierre la aplicación
      child: Scaffold(
        body: Stack(
          children: [
            // Fondo
            Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Logo centrado verticalmente en la parte superior
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25 - 50,
              left: (MediaQuery.of(context).size.width - 200) / 2,
              child: Image.asset('assets/logo.png', width: 200, height: 100),
            ),
            // Controles centrados verticalmente en la parte inferior
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.25 - 50,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Control de volumen centrado
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
                        activeColor: Colors.blue,
                        thumbColor: Colors.blue,
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () => _setVolume(1.0),
                      ),
                    ],
                  ),
                  // Botón de play/stop redondo
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                        size: 64,
                        color: Colors.black,
                      ),
                      onPressed: _playPause,
                    ),
                  ),
                ],
              ),
            ),
            // Menú hamburguesa en el lado izquierdo
            Positioned(
              left: 20,
              top: 20,
              child: IconButton(
                icon: Icon(Icons.menu, size: 30),
                onPressed: () {
                  setState(() {
                    _isMenuOpen = !_isMenuOpen;
                  });
                },
              ),
            ),
            // Mostrar el menú si está abierto
            if (_isMenuOpen)
              Positioned(
                top: 60,
                left: 20,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    color: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text('Instagram'),
                          onTap: () {
                            _launchURL(
                              'https://www.instagram.com/andesuralegra/',
                            );
                            _toggleMenu();
                          },
                        ),
                        ListTile(
                          title: Text('Facebook'),
                          onTap: () {
                            _launchURL(
                              'https://www.facebook.com/andesuralegra/',
                            );
                            _toggleMenu();
                          },
                        ),
                        ListTile(
                          title: Text('WhatsApp'),
                          onTap: () {
                            _launchWhatsApp();
                            _toggleMenu();
                          },
                        ),
                        ListTile(
                          title: Text('Sitio Web'),
                          onTap: () {
                            _launchURL('https://andesur.webradio.com.ar/');
                            _toggleMenu();
                          },
                        ),
                        ListTile(
                          title: Text('Compartir App'),
                          onTap: () {
                            _shareApp();
                            _toggleMenu();
                          },
                        ),
                        ListTile(
                          title: Text('Minimizar'),
                          onTap: () {
                            SystemNavigator.pop();
                            _toggleMenu();
                          },
                        ),
                        ListTile(
                          title: Text('Cerrar'),
                          onTap: () {
                            _closeApp();
                            _toggleMenu();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Método para cerrar el menú
  void _toggleMenu() {
    setState(() {
      _isMenuOpen = false; // Cierra el menú cuando se selecciona una opción
    });
  }
}
