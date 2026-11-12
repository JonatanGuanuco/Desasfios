import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/tareas_service.dart';

class TareasScreen extends StatefulWidget {
  final bool soloPendientes;

  const TareasScreen({super.key, this.soloPendientes = false});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TareasService _servicio = TareasService();
  final TextEditingController _controller = TextEditingController();
  final Set<String> _eliminando = {};
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _servicio.escucharTareas();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _agregar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    _controller.clear();
    await _servicio.agregar(texto);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Nueva tarea',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _agregar(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _agregar,
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs.where((doc) {
                if (_eliminando.contains(doc.id)) return false;
                if (!widget.soloPendientes) return true;
                return doc.data()['completada'] != true;
              }).toList();

              if (docs.isEmpty) {
                return const Center(child: Text('No hay tareas'));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data();
                  final completada = data['completada'] == true;

                  return Dismissible(
                    key: ValueKey(doc.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      setState(() => _eliminando.add(doc.id));
                      _servicio.eliminar(doc.id);
                    },
                    child: CheckboxListTile(
                      title: Text(
                        data['titulo'] ?? '',
                        style: TextStyle(
                          decoration: completada
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      value: completada,
                      onChanged: (valor) =>
                          _servicio.cambiarEstado(doc.id, valor ?? false),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}