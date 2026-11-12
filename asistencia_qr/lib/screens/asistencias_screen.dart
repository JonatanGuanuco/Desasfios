import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/asistencia_service.dart';

class AsistenciasScreen extends StatefulWidget {
  const AsistenciasScreen({super.key});

  @override
  State<AsistenciasScreen> createState() => _AsistenciasScreenState();
}

class _AsistenciasScreenState extends State<AsistenciasScreen> {
  final AsistenciaService _servicio = AsistenciaService();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _servicio.asistenciasDeHoy();
  }

  Future<void> _confirmarLimpiar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar registro'),
        content: const Text('Se borrarán las asistencias de hoy. ¿Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await _servicio.limpiarHoy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistencias de hoy')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs.toList()
            ..sort((a, b) {
              final horaA = (a.data()['hora'] ?? '').toString();
              final horaB = (b.data()['hora'] ?? '').toString();
              return horaB.compareTo(horaA);
            });

          if (docs.isEmpty) {
            return const Center(
              child: Text('Todavía no hay asistencias hoy'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.check)),
                title: Text('${data['nombre'] ?? ''}'),
                subtitle: Text('Hora: ${data['hora'] ?? ''}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmarLimpiar,
        icon: const Icon(Icons.delete_sweep),
        label: const Text('Limpiar registro del día'),
      ),
    );
  }
}