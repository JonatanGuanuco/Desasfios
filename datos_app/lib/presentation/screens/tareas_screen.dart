import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tareas_provider.dart';

class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(tareasProvider.notifier).cargar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _agregar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    ref.read(tareasProvider.notifier).agregar(texto);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tareas = ref.watch(tareasProvider);
    final notifier = ref.read(tareasProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: Column(
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
                ElevatedButton(
                  onPressed: _agregar,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: tareas.isEmpty
                ? const Center(child: Text('No hay tareas todavía'))
                : ListView.builder(
                    itemCount: tareas.length,
                    itemBuilder: (context, index) {
                      final tarea = tareas[index];
                      return Dismissible(
                        key: ValueKey(tarea.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => notifier.eliminar(tarea.id!),
                        child: CheckboxListTile(
                          title: Text(
                            tarea.titulo,
                            style: TextStyle(
                              decoration: tarea.completada
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          value: tarea.completada,
                          onChanged: (_) => notifier.cambiarEstado(tarea),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}