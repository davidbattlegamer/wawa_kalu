import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermisosApp {
  static Future<void> pedirPermisosIniciales(BuildContext context) async {
    if (kIsWeb) return;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final permisos = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();

        final bool bluetoothScanOk =
            permisos[Permission.bluetoothScan]?.isGranted ?? false;

        final bool bluetoothConnectOk =
            permisos[Permission.bluetoothConnect]?.isGranted ?? false;

        final bool ubicacionOk =
            permisos[Permission.locationWhenInUse]?.isGranted ?? false;

        if (!bluetoothScanOk || !bluetoothConnectOk || !ubicacionOk) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Activa Bluetooth, dispositivos cercanos y ubicación para conectar.',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          return;
        }

        try {
          final estado = await FlutterBluePlus.adapterState.first.timeout(
            const Duration(seconds: 4),
          );

          if (estado != BluetoothAdapterState.on) {
            await FlutterBluePlus.turnOn();
          }
        } catch (e) {
          debugPrint('No se pudo activar/verificar Bluetooth: $e');
        }
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        try {
          await FlutterBluePlus.adapterState.first.timeout(
            const Duration(seconds: 4),
          );
        } catch (e) {
          debugPrint('Permiso Bluetooth iOS pendiente o no disponible: $e');
        }
      }
    } catch (e) {
      debugPrint('Error pidiendo permisos iniciales: $e');
    }
  }
}