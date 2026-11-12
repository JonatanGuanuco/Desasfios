import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/asistencia_service.dart';
import '../services/notificaciones_service.dart';

class EscanerScreen extends StatefulWidget {
  const EscanerScreen({super.key});

  @override
  State<EscanerScreen> createState() => _EscanerScreenState();
}

class _EscanerScreenState extends State<EscanerScreen> {
  final MobileScannerController _ctrl = MobileScannerController();
  final AsistenciaService _servicio = AsistenciaService();
  bool _procesando = false;
  bool _linterna = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _alDetectar(BarcodeCapture captura) async {
    if (_procesando) return;
    if (captura.barcodes.isEmpty) return;
    final valor = captura.barcodes.first.rawValue?.trim();
    if (valor == null || valor.isEmpty) return;

    setState(() => _procesando = true);

    final yaEstaba = await _servicio.yaRegistradoHoy(valor);

    if (yaEstaba) {
      await NotificacionesService.mostrar(
        titulo: 'Ya registrado',
        cuerpo: '$valor ya tiene asistencia registrada hoy.',
      );
      _mostrarMensaje('$valor ya tiene asistencia hoy');
    } else {
      await _servicio.registrar(valor);
      _mostrarMensaje('Asistencia registrada: $valor');
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _procesando = false);
  }

  void _mostrarMensaje(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Stack(
        children: [
          MobileScanner(controller: _ctrl, onDetect: _alDetectar),
          if (_procesando)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ctrl.toggleTorch();
          setState(() => _linterna = !_linterna);
        },
        child: Icon(_linterna ? Icons.flash_off : Icons.flash_on),
      ),
    );
  }
}