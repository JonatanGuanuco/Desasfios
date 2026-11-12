import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/local_database.dart';
import '../../domain/entities/tarea.dart';

class TareasNotifier extends Notifier<List<Tarea>> {
  final LocalDatabase _db = LocalDatabase();

  @override
  List<Tarea> build() => [];

  Future<void> cargar() async {
    state = await _db.obtenerTodas();
  }

  Future<void> agregar(String titulo) async {
    await _db.insertar(
      Tarea(titulo: titulo, fecha: DateTime.now().toIso8601String()),
    );
    await cargar();
  }

  Future<void> cambiarEstado(Tarea tarea) async {
    await _db.actualizar(tarea.copyWith(completada: !tarea.completada));
    await cargar();
  }

  Future<void> eliminar(int id) async {
    state = state.where((t) => t.id != id).toList();
    await _db.eliminar(id);
  }
}

final tareasProvider =
    NotifierProvider<TareasNotifier, List<Tarea>>(TareasNotifier.new);