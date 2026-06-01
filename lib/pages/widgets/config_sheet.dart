import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import '../app_config.dart';
import '../app_texts.dart';

Future<bool> dispositivoPermiteVibracion() async {
  if (kIsWeb) return false;

  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      return await Vibration.hasVibrator();
    } catch (_) {
      return false;
    }
  }

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return true;
  }

  return false;
}

Future<void> vibrarActivacionFuerte() async {
  try {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final bool tieneVibrador = await Vibration.hasVibrator();

      if (tieneVibrador) {
        await Vibration.vibrate(pattern: [0, 160, 70, 160]);
        return;
      }
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      await HapticFeedback.heavyImpact();
    }
  } catch (_) {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }
}

String textoTema(ThemeMode tema) {
  if (tema == ThemeMode.system) return T.txt('themeAutomatic');
  if (tema == ThemeMode.dark) return T.txt('darkMode');
  return T.txt('lightMode');
}

IconData iconoTema(ThemeMode tema) {
  if (tema == ThemeMode.system) return Icons.brightness_auto_rounded;
  if (tema == ThemeMode.dark) return Icons.dark_mode_rounded;
  return Icons.light_mode_rounded;
}

Color colorTema(ThemeMode tema) {
  if (tema == ThemeMode.system) return const Color(0xFF00A896);
  if (tema == ThemeMode.dark) return Colors.indigo;
  return Colors.amber;
}

String textoIdiomaActual({
  required bool idiomaAuto,
  required String idiomaActual,
}) {
  if (idiomaAuto) return T.txt('languageAutomatic');
  if (idiomaActual == 'en') return T.txt('english');
  return T.txt('spanish');
}

String nombrePlataforma() {
  if (kIsWeb) return 'Web';

  if (defaultTargetPlatform == TargetPlatform.android) return 'Android';
  if (defaultTargetPlatform == TargetPlatform.iOS) return 'iOS';
  if (defaultTargetPlatform == TargetPlatform.windows) return 'Windows';
  if (defaultTargetPlatform == TargetPlatform.macOS) return 'macOS';
  if (defaultTargetPlatform == TargetPlatform.linux) return 'Linux';

  return T.txt('unknown');
}

String textoEstadoPermiso(PermissionStatus estado) {
  if (estado.isGranted) return T.txt('granted');
  if (estado.isDenied) return T.txt('denied');
  if (estado.isPermanentlyDenied) return T.txt('permanentlyDenied');
  if (estado.isRestricted) return T.txt('restricted');
  if (estado.isLimited) return T.txt('limited');
  if (estado.isProvisional) return T.txt('provisional');

  return T.txt('unknown');
}

Color colorEstado(String estado) {
  final texto = estado.toLowerCase();

  if (texto.contains(T.txt('granted').toLowerCase()) ||
      texto.contains(T.txt('on').toLowerCase()) ||
      texto.contains('activo') ||
      texto.contains('active') ||
      texto.contains('disponible') ||
      texto.contains('available')) {
    return Colors.green;
  }

  if (texto.contains(T.txt('denied').toLowerCase()) ||
      texto.contains(T.txt('permanentlyDenied').toLowerCase()) ||
      texto.contains('apagado') ||
      texto.contains('off') ||
      texto.contains('no disponible') ||
      texto.contains('not available') ||
      texto.contains(T.txt('restricted').toLowerCase())) {
    return Colors.redAccent;
  }

  return Colors.orange;
}

Future<void> pedirPermisosDesdeInfo() async {
  if (kIsWeb) return;

  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();

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
    debugPrint('Error pidiendo permisos desde info: $e');
  }
}

Future<Map<String, String>> obtenerDiagnosticoPermisos() async {
  final Map<String, String> datos = {};

  datos[T.txt('platform')] = nombrePlataforma();

  if (kIsWeb) {
    datos[T.txt('bluetoothWeb')] = T.txt('webBleNote');
    datos[T.txt('permissions')] = T.txt('webBleLimitedNote');
    return datos;
  }

  try {
    final estadoBluetooth = await FlutterBluePlus.adapterState.first.timeout(
      const Duration(seconds: 4),
    );

    datos[T.txt('bluetoothStatus')] =
        estadoBluetooth == BluetoothAdapterState.on
            ? T.txt('on')
            : T.txt('offOrUnavailable');
  } catch (_) {
    datos[T.txt('bluetoothStatus')] = T.txt('notAvailableOrConfigured');
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    final bluetoothScan = await Permission.bluetoothScan.status;
    final bluetoothConnect = await Permission.bluetoothConnect.status;
    final ubicacion = await Permission.locationWhenInUse.status;

    datos[T.txt('nearbyDevicesScan')] = textoEstadoPermiso(bluetoothScan);
    datos[T.txt('bluetoothConnection')] = textoEstadoPermiso(bluetoothConnect);
    datos[T.txt('preciseLocation')] = textoEstadoPermiso(ubicacion);
    datos[T.txt('permissions')] = T.txt('androidBleNote');
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    final bluetooth = await Permission.bluetooth.status;

    datos[T.txt('bluetoothPermission')] = textoEstadoPermiso(bluetooth);
    datos[T.txt('permissions')] = T.txt('iosBleNote');
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    datos[T.txt('macosPermissions')] = T.txt('macosBleNote');
  } else if (defaultTargetPlatform == TargetPlatform.windows) {
    datos[T.txt('windowsPermissions')] = T.txt('windowsBleNote');
  } else {
    datos[T.txt('permissions')] = T.txt('genericPermissionNote');
  }

  return datos;
}

bool faltanPermisos(Map<String, String> datos) {
  if (kIsWeb) return false;

  final valores = datos.values.map((e) => e.toLowerCase()).toList();

  final faltaPermiso = valores.any(
        (e) => e.contains(T.txt('denied').toLowerCase()),
      ) ||
      valores.any(
        (e) => e.contains(T.txt('permanentlyDenied').toLowerCase()),
      ) ||
      valores.any(
        (e) => e.contains(T.txt('restricted').toLowerCase()),
      );

  final bluetoothApagado = valores.any(
    (e) =>
        e.contains(T.txt('offOrUnavailable').toLowerCase()) ||
        e.contains(T.txt('notAvailableOrConfigured').toLowerCase()),
  );

  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    return faltaPermiso || bluetoothApagado;
  }

  return false;
}

void mostrarInformacionPermisos(BuildContext context, bool modoOscuro) async {
  final datos = await obtenerDiagnosticoPermisos();
  final bool hayFaltantes = faltanPermisos(datos);

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: modoOscuro ? const Color(0xFF211B2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.deepPurple),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                T.txt('systemInfo'),
                style: TextStyle(
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w700,
                  color: modoOscuro ? Colors.white : const Color(0xFF4A2C82),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: datos.entries.map((item) {
              final Color color = colorEstado(item.value);

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: modoOscuro ? 0.18 : 0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      color == Colors.green
                          ? Icons.check_circle_rounded
                          : color == Colors.redAccent
                              ? Icons.cancel_rounded
                              : Icons.warning_rounded,
                      color: color,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.key,
                            style: TextStyle(
                              fontFamily: 'Fredoka',
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: modoOscuro
                                  ? Colors.white
                                  : const Color(0xFF2D2D2D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: TextStyle(
                              fontFamily: 'Baloo2',
                              fontSize: 14.5,
                              color:
                                  modoOscuro ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(T.txt('close')),
          ),
          if (hayFaltantes &&
              !kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS))
            TextButton(
              onPressed: () async {
                await pedirPermisosDesdeInfo();

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                if (context.mounted) {
                  mostrarInformacionPermisos(context, modoOscuro);
                }
              },
              child: Text(T.txt('grantPermissions')),
            ),
          if (!kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS))
            TextButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: Text(T.txt('openSettings')),
            ),
        ],
      );
    },
  );
}

void showConfigSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF15131A)
        : const Color(0xFFFAF7F2),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      final altoPantalla = MediaQuery.of(context).size.height;

      return ValueListenableBuilder<ThemeMode>(
        valueListenable: AppConfig.temaApp,
        builder: (context, temaActual, _) {
          final bool modoOscuro =
              Theme.of(context).brightness == Brightness.dark;

          final Color fondoModal = modoOscuro
              ? const Color(0xFF15131A)
              : const Color(0xFFFAF7F2);

          final Color textoSecundario =
              modoOscuro ? Colors.white70 : Colors.black54;

          final Color colorApariencia = colorTema(temaActual);

          return Container(
            decoration: BoxDecoration(
              color: fondoModal,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Stack(
              children: [
                SafeArea(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: altoPantalla * 0.90),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 18,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: ValueListenableBuilder<String>(
                        valueListenable: AppConfig.idioma,
                        builder: (context, idiomaActual, _) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: AppConfig.idiomaAuto,
                            builder: (context, idiomaAuto, _) {
                              return ValueListenableBuilder<bool>(
                                valueListenable: AppConfig.sonidosActivos,
                                builder: (context, sonidosActivos, _) {
                                  return ValueListenableBuilder<bool>(
                                    valueListenable: AppConfig.vibracionActiva,
                                    builder: (context, vibracionActiva, _) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: modoOscuro
                                                  ? Colors.white24
                                                  : Colors.black26,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Container(
                                            width: 74,
                                            height: 74,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.deepPurple.withValues(
                                                    alpha: modoOscuro
                                                        ? 0.38
                                                        : 0.22,
                                                  ),
                                                  Colors.deepPurple.withValues(
                                                    alpha: modoOscuro
                                                        ? 0.16
                                                        : 0.08,
                                                  ),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.settings,
                                              size: 42,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          Text(
                                            T.txt('settingsTitle'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Fredoka',
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                              color: modoOscuro
                                                  ? Colors.white
                                                  : const Color(0xFF4A2C82),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          SettingCard(
                                            color: sonidosActivos
                                                ? Colors.green
                                                : Colors.redAccent,
                                            icon: sonidosActivos
                                                ? Icons.volume_up_rounded
                                                : Icons.volume_off_rounded,
                                            title: T.txt('sounds'),
                                            subtitle: sonidosActivos
                                                ? T.txt('enabled')
                                                : T.txt('disabled'),
                                            modoOscuro: modoOscuro,
                                            trailing: AdaptiveSwitch(
                                              value: sonidosActivos,
                                              activeColor: Colors.green,
                                              inactiveColor: Colors.redAccent,
                                              onChanged: (valor) async {
                                                await AppConfig.cambiarSonidos(
                                                  valor,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          SettingCard(
                                            color: idiomaAuto
                                                ? const Color(0xFF00A896)
                                                : Colors.deepPurple,
                                            icon: idiomaAuto
                                                ? Icons.translate_rounded
                                                : Icons.language_rounded,
                                            title: T.txt('language'),
                                            subtitle: idiomaAuto
                                                ? T.txt('languageAutoSubtitle')
                                                : textoIdiomaActual(
                                                    idiomaAuto: idiomaAuto,
                                                    idiomaActual: idiomaActual,
                                                  ),
                                            modoOscuro: modoOscuro,
                                            trailing: LanguageSelector(
                                              idiomaActual: idiomaActual,
                                              idiomaAuto: idiomaAuto,
                                              modoOscuro: modoOscuro,
                                            ),
                                          ),
                                          FutureBuilder<bool>(
                                            future:
                                                dispositivoPermiteVibracion(),
                                            builder: (context, snapshot) {
                                              final bool puedeVibrar =
                                                  snapshot.data ?? false;

                                              if (!puedeVibrar) {
                                                return const SizedBox.shrink();
                                              }

                                              return Column(
                                                children: [
                                                  const SizedBox(height: 14),
                                                  SettingCard(
                                                    color: vibracionActiva
                                                        ? Colors.orange
                                                        : Colors.blueGrey,
                                                    icon: vibracionActiva
                                                        ? Icons
                                                            .vibration_rounded
                                                        : Icons
                                                            .phone_android_rounded,
                                                    title: T.txt('vibration'),
                                                    subtitle: vibracionActiva
                                                        ? T.txt('vibrationOn')
                                                        : T.txt(
                                                            'vibrationOff',
                                                          ),
                                                    modoOscuro: modoOscuro,
                                                    trailing: AdaptiveSwitch(
                                                      value: vibracionActiva,
                                                      activeColor:
                                                          Colors.orange,
                                                      inactiveColor:
                                                          Colors.blueGrey,
                                                      onChanged: (valor) async {
                                                        await AppConfig
                                                            .cambiarVibracion(
                                                          valor,
                                                        );

                                                        if (!valor) return;

                                                        await vibrarActivacionFuerte();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 14),
                                          SettingCard(
                                            color: colorApariencia,
                                            icon: iconoTema(temaActual),
                                            title: T.txt('appearance'),
                                            subtitle: textoTema(temaActual),
                                            modoOscuro: modoOscuro,
                                            trailing: ThemeSelector(
                                              temaActual: temaActual,
                                              modoOscuro: modoOscuro,
                                              onChanged: (nuevoTema) async {
                                                await AppConfig.cambiarTema(
                                                  nuevoTema,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 14),
                                          Text(
                                            T.txt('settingsNote'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Baloo2',
                                              fontSize: 15.5,
                                              color: textoSecundario,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 14,
                  right: 16,
                  child: SafeArea(
                    child: Material(
                      color: Colors.transparent,
                      child: Tooltip(
                        message: T.txt('permissionsInfo'),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            mostrarInformacionPermisos(context, modoOscuro);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: modoOscuro
                                  ? const Color(0xFF211B2E)
                                  : Colors.white,
                              border: Border.all(
                                color: Colors.deepPurple.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                T.txt('info'),
                                style: const TextStyle(
                                  fontFamily: 'Fredoka',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class SettingCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool modoOscuro;

  const SettingCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool estrecho = constraints.maxWidth < 390;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(estrecho ? 14 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                color.withValues(alpha: modoOscuro ? 0.18 : 0.09),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: color.withValues(alpha: modoOscuro ? 0.30 : 0.16),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: modoOscuro ? 0.10 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: estrecho
              ? Column(
                  children: [
                    Row(
                      children: [
                        SettingIcon(color: color, icon: icon),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SettingText(
                            title: title,
                            subtitle: subtitle,
                            modoOscuro: modoOscuro,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(fit: BoxFit.scaleDown, child: trailing),
                    ),
                  ],
                )
              : Row(
                  children: [
                    SettingIcon(color: color, icon: icon),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SettingText(
                        title: title,
                        subtitle: subtitle,
                        modoOscuro: modoOscuro,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: trailing,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class SettingIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  const SettingIcon({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }
}

class SettingText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool modoOscuro;

  const SettingText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontFamily: 'Baloo2',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: modoOscuro ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }
}

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final Color inactiveColor;
  final Future<void> Function(bool valor) onChanged;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      activeThumbColor: activeColor,
      inactiveThumbColor: inactiveColor,
      onChanged: (valor) async {
        await onChanged(valor);
      },
    );
  }
}

class LanguageSelector extends StatelessWidget {
  final String idiomaActual;
  final bool idiomaAuto;
  final bool modoOscuro;

  const LanguageSelector({
    super.key,
    required this.idiomaActual,
    required this.idiomaAuto,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    final Color seleccionado = idiomaAuto
        ? const Color(0xFF00A896)
        : idiomaActual == 'en'
            ? Colors.deepPurple
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: modoOscuro ? const Color(0xFF15131A) : const Color(0xFFF2ECFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: seleccionado.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LanguageOptionButton(
            text: 'A',
            icon: Icons.settings_suggest_rounded,
            selected: idiomaAuto,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            tooltip: T.txt('languageAutomatic'),
            onTap: () async {
              await AppConfig.cambiarIdiomaAutomatico();
            },
          ),
          LanguageOptionButton(
            text: 'ES',
            selected: !idiomaAuto && idiomaActual == 'es',
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            tooltip: T.txt('spanish'),
            onTap: () async {
              await AppConfig.cambiarIdioma('es');
            },
          ),
          LanguageOptionButton(
            text: 'EN',
            selected: !idiomaAuto && idiomaActual == 'en',
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            tooltip: T.txt('english'),
            onTap: () async {
              await AppConfig.cambiarIdioma('en');
            },
          ),
        ],
      ),
    );
  }
}

class LanguageOptionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool selected;
  final Color selectedColor;
  final bool modoOscuro;
  final String tooltip;
  final Future<void> Function() onTap;

  const LanguageOptionButton({
    super.key,
    required this.text,
    this.icon,
    required this.selected,
    required this.selectedColor,
    required this.modoOscuro,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.26),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            await onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            child: icon != null
                ? Icon(
                    icon,
                    size: 20,
                    color: selected
                        ? Colors.white
                        : modoOscuro
                            ? Colors.white70
                            : const Color(0xFF4A2C82),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? Colors.white
                          : modoOscuro
                              ? Colors.white70
                              : const Color(0xFF4A2C82),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ThemeSelector extends StatelessWidget {
  final ThemeMode temaActual;
  final bool modoOscuro;
  final Future<void> Function(ThemeMode nuevoTema) onChanged;

  const ThemeSelector({
    super.key,
    required this.temaActual,
    required this.modoOscuro,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color fondo =
        modoOscuro ? const Color(0xFF15131A) : const Color(0xFFF2ECFF);

    Color colorSeleccionado() {
      if (temaActual == ThemeMode.system) {
        return const Color(0xFF00A896);
      }

      if (temaActual == ThemeMode.dark) {
        return modoOscuro ? Colors.indigo.shade400 : Colors.indigo;
      }

      return Colors.amber;
    }

    final Color seleccionado = colorSeleccionado();

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: seleccionado.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeOptionButton(
            icon: Icons.brightness_auto_rounded,
            selected: temaActual == ThemeMode.system,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () => onChanged(ThemeMode.system),
          ),
          ThemeOptionButton(
            icon: Icons.light_mode_rounded,
            selected: temaActual == ThemeMode.light,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () => onChanged(ThemeMode.light),
          ),
          ThemeOptionButton(
            icon: Icons.dark_mode_rounded,
            selected: temaActual == ThemeMode.dark,
            selectedColor: seleccionado,
            modoOscuro: modoOscuro,
            onTap: () => onChanged(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}

class ThemeOptionButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final bool modoOscuro;
  final VoidCallback onTap;

  const ThemeOptionButton({
    super.key,
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.modoOscuro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: selectedColor.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(
            icon,
            size: 22,
            color: selected
                ? Colors.white
                : modoOscuro
                    ? Colors.white70
                    : const Color(0xFF4A2C82),
          ),
        ),
      ),
    );
  }
}