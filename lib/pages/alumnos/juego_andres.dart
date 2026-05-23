import 'package:flutter/material.dart';

class JuegoAndresPage extends StatefulWidget {
  const JuegoAndresPage({super.key});

  @override
  State<JuegoAndresPage> createState() => _JuegoPatyPageState();
}

class _JuegoPatyPageState extends State<JuegoAndresPage> {
  int _contador = 0;

  void _sumar() {
    setState(() {
      _contador++;
    });
  }

  void _restar() {
    setState(() {
      if (_contador > 0) _contador--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Juego de Paty")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Contador de clicks",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '$_contador',
              style: const TextStyle(fontSize: 48, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _sumar,
                  child: const Text("Sumar"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _restar,
                  child: const Text("Restar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
