import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      home: Scaffold(
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
              top: 50, // Ajusta la posición según lo necesites
              left:
                  (MediaQuery.of(context).size.width - 200) /
                  2, // Centra el logo
              child: Image.asset(
                'assets/logo.png',
                width: 200, // Ajusta el tamaño según lo necesites
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
