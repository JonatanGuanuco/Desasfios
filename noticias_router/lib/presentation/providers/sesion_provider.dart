import 'package:flutter_riverpod/flutter_riverpod.dart';

class SesionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void iniciar() => state = true;

  void cerrar() => state = false;
}

final sesionProvider = NotifierProvider<SesionNotifier, bool>(
  SesionNotifier.new,
);