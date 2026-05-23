import 'package:flutter/material.dart';


class JuegoPatyPage extends StatefulWidget {
  const JuegoPatyPage({super.key});

  @override
  State<JuegoPatyPage> createState() => _JuegoPatyPageState();
}

class _JuegoPatyPageState extends State<JuegoPatyPage> {
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

  void _reiniciar() {
    setState(() {
      _contador = 0;
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
            const SizedBox(height: 30),
            Wrap(
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: _sumar,
                  child: const Text("Sumar"),
                ),
                ElevatedButton(
                  onPressed: _restar,
                  child: const Text("Restar"),
                ),
                ElevatedButton(
                  onPressed: _reiniciar,
                  child: const Text("Reiniciar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
