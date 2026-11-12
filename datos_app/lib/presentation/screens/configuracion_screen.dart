import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('preferencias').listenable(),
        builder: (context, caja, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Modo oscuro'),
                value: caja.get('modoOscuro', defaultValue: false) as bool,
                onChanged: (valor) => caja.put('modoOscuro', valor),
              ),
              SwitchListTile(
                title: const Text('Notificaciones'),
                value: caja.get('notificaciones', defaultValue: true) as bool,
                onChanged: (valor) => caja.put('notificaciones', valor),
              ),
            ],
          );
        },
      ),
    );
  }
}