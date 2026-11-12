import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const TarjetaScreen(),
    );
  }
}

class TarjetaScreen extends StatefulWidget {
  const TarjetaScreen({super.key});

  @override
  State<TarjetaScreen> createState() => _TarjetaScreenState();
}

class _TarjetaScreenState extends State<TarjetaScreen> {
  bool _fondoColor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoColor ? Colors.purple.shade200 : Colors.white,
      appBar: AppBar(
        title: Text('Mi tarjeta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            SizedBox(height: 16),
            Text(
              'Jonatan Nahuel Guanuco',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Técnico en Informática',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Fondo de color'),
                SizedBox(width: 8),
                Switch(
                  value: _fondoColor,
                  onChanged: (val) => setState(() => _fondoColor = val),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('¡Hola!')),
                );
              },
              child: Text('Saludar'),
            ),
          ],
        ),
      ),
    );
  }
}