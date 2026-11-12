import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TareasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> escucharTareas() {
    return _db
        .collection('tareas')
        .where('userId', isEqualTo: _uid)
        .orderBy('fechaCreacion', descending: true)
        .snapshots();
  }

  Future<void> agregar(String titulo) async {
    await _db.collection('tareas').add({
      'titulo': titulo,
      'completada': false,
      'fechaCreacion': FieldValue.serverTimestamp(),
      'userId': _uid,
    });
  }

  Future<void> cambiarEstado(String id, bool completada) async {
    await _db.collection('tareas').doc(id).update({'completada': completada});
  }

  Future<void> eliminar(String id) async {
    await _db.collection('tareas').doc(id).delete();
  }
}