import 'package:cloud_firestore/cloud_firestore.dart';

class AsistenciaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String fechaHoy() {
    final ahora = DateTime.now();
    return '${ahora.year}-${_dos(ahora.month)}-${_dos(ahora.day)}';
  }

  static String horaActual() {
    final ahora = DateTime.now();
    return '${_dos(ahora.hour)}:${_dos(ahora.minute)}';
  }

  static String _dos(int n) => n.toString().padLeft(2, '0');

  Future<bool> yaRegistradoHoy(String nombre) async {
    final query = await _db
        .collection('asistencias')
        .where('fecha', isEqualTo: fechaHoy())
        .where('nombre', isEqualTo: nombre)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<void> registrar(String nombre) async {
    await _db.collection('asistencias').add({
      'nombre': nombre,
      'fecha': fechaHoy(),
      'hora': horaActual(),
      'creado': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> asistenciasDeHoy() {
    return _db
        .collection('asistencias')
        .where('fecha', isEqualTo: fechaHoy())
        .snapshots();
  }

  Future<void> limpiarHoy() async {
    final query = await _db
        .collection('asistencias')
        .where('fecha', isEqualTo: fechaHoy())
        .get();
    final batch = _db.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}