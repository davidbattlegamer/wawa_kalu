import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import 'app_config.dart';
import 'app_texts.dart';

class CpsPage extends StatefulWidget {
  const CpsPage({super.key});

  @override
  State<CpsPage> createState() => _CpsPageState();
}

class _CpsPageState extends State<CpsPage> {
  bool conectado = false;
  bool cargando = false;
  bool mostrarGuia = true;

  int deteccionesSesion = 0;
  int estrellasNotificadas = 0;
  int medallasNotificadas = 0;

  String mensajePremioKey = 'defaultPrize';

  final AudioPlayer audioPremio = AudioPlayer();

  BluetoothDevice? dispositivo;
  BluetoothCharacteristic? commandCharacteristic;

  StreamSubscription? scanSubscription;
  StreamSubscription? datosSubscription;
  StreamSubscription? logSubscription;

  Set<String> figurasActivas = {};
  List<String> logsOffline = [];

  final String nombreArduino = 'ESP_CPS';

  final String serviceUuid = '19B10000-E8F2-537E-4F6C-D104768A1214';
  final String characteristicUuid = '19B10001-E8F2-537E-4F6C-D104768A1214';
  final String logUuid = '19B10002-E8F2-537E-4F6C-D104768A1214';
  final String commandUuid = '19B10003-E8F2-537E-4F6C-D104768A1214';

  Future<void> botonBluetooth() async {
    if (conectado) {
      await desconectarESP32();
    } else {
      await buscarESP32();
    }
  }

  Future<void> vibrarSuave() async {
    if (!AppConfig.vibracionActiva.value) return;

    try {
      if (!kIsWeb) {
        final bool tieneVibrador = await Vibration.hasVibrator();

        if (tieneVibrador) {
          await Vibration.vibrate(duration: 80);
          return;
        }
      }

      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('No se pudo vibrar suave: $e');

      try {
        await HapticFeedback.selectionClick();
      } catch (_) {}
    }
  }

  Future<void> vibrarPremio({required bool medalla}) async {
    if (!AppConfig.vibracionActiva.value) return;

    try {
      if (!kIsWeb) {
        final bool tieneVibrador = await Vibration.hasVibrator();

        if (tieneVibrador) {
          if (medalla) {
            await Vibration.vibrate(pattern: [0, 180, 80, 180]);
          } else {
            await Vibration.vibrate(duration: 140);
          }
          return;
        }
      }

      if (medalla) {
        await HapticFeedback.heavyImpact();
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      debugPrint('No se pudo vibrar premio: $e');

      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  Future<bool> verificarBluetoothEncendido() async {
    BluetoothAdapterState estado = await FlutterBluePlus.adapterState.first;

    if (estado == BluetoothAdapterState.on) {
      return true;
    }

    try {
      await FlutterBluePlus.turnOn();

      await FlutterBluePlus.adapterState
          .where((state) => state == BluetoothAdapterState.on)
          .first
          .timeout(const Duration(seconds: 8));

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(T.txt('turnOnBluetooth')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

      debugPrint('Bluetooth no se pudo activar: $e');
      return false;
    }
  }

  Future<void> buscarESP32() async {
    bool bluetoothListo = await verificarBluetoothEncendido();

    if (!bluetoothListo) return;

    setState(() {
      cargando = true;
      figurasActivas.clear();
    });

    await scanSubscription?.cancel();
    await datosSubscription?.cancel();
    await logSubscription?.cancel();

    List<ScanResult> dispositivosEncontrados = [];

    try {
      await FlutterBluePlus.stopScan();

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 8),
        webOptionalServices: [
          Guid(serviceUuid),
        ],
      );

      scanSubscription = FlutterBluePlus.scanResults.listen((resultados) {
        dispositivosEncontrados = resultados
            .where((r) => r.device.platformName.isNotEmpty)
            .toList();
      });

      await Future.delayed(const Duration(seconds: 4));

      await FlutterBluePlus.stopScan();

      setState(() {
        cargando = false;
      });

      if (!mounted) return;

      mostrarDispositivosBluetooth(dispositivosEncontrados);
    } catch (e) {
      setState(() {
        cargando = false;
        conectado = false;
      });

      debugPrint('Error buscando ESP32: $e');
    }
  }

  void mostrarDispositivosBluetooth(List<ScanResult> dispositivos) {
    if (dispositivos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(T.txt('noBleDevices')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final bool modoOscuroInicial = AppConfig.temaApp.value == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          modoOscuroInicial ? const Color(0xFF15131A) : const Color(0xFFFAF7F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: AppConfig.temaApp,
            builder: (context, temaActual, _) {
              final bool modoOscuro = temaActual == ThemeMode.dark;

              return Container(
                decoration: BoxDecoration(
                  color: modoOscuro
                      ? const Color(0xFF15131A)
                      : const Color(0xFFFAF7F2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: AppConfig.idioma,
                  builder: (context, idioma, _) {
                    return Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bluetooth_searching,
                            size: 55,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            T.txt('selectEsp'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: modoOscuro
                                  ? Colors.white
                                  : const Color(0xFF4A2C82),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dispositivos.length,
                              itemBuilder: (context, index) {
                                final resultado = dispositivos[index];
                                final nombre = resultado.device.platformName;
                                final rssi = resultado.rssi;
                                final esEsp = nombre == nombreArduino;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(22),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(22),
                                      onTap: () async {
                                        Navigator.pop(context);

                                        dispositivo = resultado.device;

                                        setState(() {
                                          cargando = true;
                                        });

                                        await conectarESP32();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              modoOscuro
                                                  ? const Color(0xFF211B2E)
                                                  : Colors.white,
                                              esEsp
                                                  ? Colors.green.withValues(
                                                      alpha: modoOscuro
                                                          ? 0.22
                                                          : 0.12,
                                                    )
                                                  : Colors.grey.withValues(
                                                      alpha: modoOscuro
                                                          ? 0.18
                                                          : 0.10,
                                                    ),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(
                                            color: esEsp
                                                ? Colors.green.withValues(
                                                    alpha: 0.30,
                                                  )
                                                : Colors.grey.withValues(
                                                    alpha: 0.20,
                                                  ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 27,
                                              backgroundColor: esEsp
                                                  ? Colors.green.withValues(
                                                      alpha: 0.18,
                                                    )
                                                  : Colors.grey.withValues(
                                                      alpha: 0.18,
                                                    ),
                                              child: Icon(
                                                Icons.bluetooth,
                                                color: esEsp
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    nombre,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.fredoka(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: esEsp
                                                          ? Colors.green
                                                          : modoOscuro
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xFF2D2D2D),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${T.txt('signal')}: $rssi dBm',
                                                    style: GoogleFonts.baloo2(
                                                      fontSize: 14,
                                                      color: modoOscuro
                                                          ? Colors.white70
                                                          : Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: esEsp
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> conectarESP32() async {
    if (dispositivo == null) {
      setState(() {
        cargando = false;
        conectado = false;
      });
      return;
    }

    try {
      await dispositivo!.connect(
        license: License.free,
        timeout: const Duration(seconds: 10),
      );
    } catch (e) {
      debugPrint('Error o ya estaba conectado: $e');
    }

    try {
      await dispositivo!.requestMtu(185);

      await dispositivo!.requestConnectionPriority(
        connectionPriorityRequest: ConnectionPriority.high,
      );

      debugPrint('BLE optimizado: MTU 185 y prioridad alta');
    } catch (e) {
      debugPrint('No se pudo optimizar BLE: $e');
    }

    try {
      List<BluetoothService> servicios = await dispositivo!.discoverServices();

      bool encontroStatus = false;

      for (BluetoothService servicio in servicios) {
        if (servicio.uuid.toString().toLowerCase() ==
            serviceUuid.toLowerCase()) {
          for (BluetoothCharacteristic c in servicio.characteristics) {
            final uuid = c.uuid.toString().toLowerCase();

            if (uuid == characteristicUuid.toLowerCase()) {
              encontroStatus = true;

              await c.setNotifyValue(true);

              await datosSubscription?.cancel();

              datosSubscription = c.lastValueStream.listen((valor) {
                if (valor.isNotEmpty) {
                  String dato = utf8.decode(valor).trim();
                  actualizarFiguras(dato);
                  debugPrint('Dato recibido: $dato');
                }
              });

              try {
                List<int> valorInicial = await c.read();

                if (valorInicial.isNotEmpty) {
                  String datoInicial = utf8.decode(valorInicial).trim();
                  actualizarFiguras(datoInicial);
                }
              } catch (e) {
                debugPrint('No se pudo leer valor inicial: $e');
              }
            }

            if (uuid == logUuid.toLowerCase()) {
              await c.setNotifyValue(true);

              await logSubscription?.cancel();

              logSubscription = c.lastValueStream.listen((valor) {
                if (valor.isNotEmpty) {
                  String dato = utf8.decode(valor).trim();
                  recibirLog(dato);
                  debugPrint('Log recibido: $dato');
                }
              });
            }

            if (uuid == commandUuid.toLowerCase()) {
              commandCharacteristic = c;
            }
          }
        }
      }

      setState(() {
        conectado = encontroStatus;
        cargando = false;

        if (encontroStatus) {
          deteccionesSesion = 0;
          estrellasNotificadas = 0;
          medallasNotificadas = 0;
          mensajePremioKey = 'defaultPrize';
          figurasActivas.clear();
          logsOffline.clear();
          mostrarGuia = false;
        }
      });

      if (!encontroStatus && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(T.txt('noBleService')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() {
        conectado = false;
        cargando = false;
      });

      debugPrint('Error discoverServices: $e');
    }
  }

  void actualizarFiguras(String dato) {
    dato = dato.trim();

    Set<String> nuevasFiguras = {};

    if (dato != '0' && dato.isNotEmpty && dato.toLowerCase() != 'none') {
      List<String> partes = dato.split(',');

      for (String parte in partes) {
        String valor = parte.trim();

        if (valor == '1') nuevasFiguras.add('1');
        if (valor == '2') nuevasFiguras.add('2');
        if (valor == '3') nuevasFiguras.add('3');
        if (valor == '4') nuevasFiguras.add('4');
      }
    }

    bool huboNuevaDeteccion =
        nuevasFiguras.isNotEmpty && !_setsIguales(nuevasFiguras, figurasActivas);

    setState(() {
      figurasActivas = nuevasFiguras;

      if (huboNuevaDeteccion) {
        deteccionesSesion++;
      }
    });

    if (huboNuevaDeteccion) {
      vibrarSuave();
      revisarRecompensa();
    }
  }

  bool _setsIguales(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;

    for (final item in a) {
      if (!b.contains(item)) return false;
    }

    return true;
  }

  Future<void> revisarRecompensa() async {
    int estrellasActuales = deteccionesSesion ~/ 5;
    int medallasActuales = deteccionesSesion ~/ 10;

    if (medallasActuales > medallasNotificadas) {
      medallasNotificadas = medallasActuales;

      setState(() {
        mensajePremioKey = 'medalPrize';
      });

      await vibrarPremio(medalla: true);
      await reproducirSonidoPremio('medalla.mp3');
      return;
    }

    if (estrellasActuales > estrellasNotificadas) {
      estrellasNotificadas = estrellasActuales;

      setState(() {
        mensajePremioKey = 'starPrize';
      });

      await vibrarPremio(medalla: false);
      await reproducirSonidoPremio('estrella.mp3');
    }
  }

  Future<void> reproducirSonidoPremio(String sonido) async {
    if (!AppConfig.sonidosActivos.value) return;

    try {
      await audioPremio.stop();
      await audioPremio.play(AssetSource('sonidos/$sonido'));
    } catch (e) {
      debugPrint('No se pudo reproducir el sonido de premio: $e');
    }
  }

  void recibirLog(String dato) async {
    if (dato == 'LOG_START') {
      setState(() {
        logsOffline.clear();
      });
      return;
    }

    if (dato == 'LOG_END') {
      await confirmarLogRecibido();
      return;
    }

    if (dato == 'SIN_LOG') {
      setState(() {
        logsOffline.clear();
        logsOffline.add(T.txt('noOfflineLogs'));
      });
      return;
    }

    if (dato == 'ERROR_LOG') {
      setState(() {
        logsOffline.clear();
        logsOffline.add(T.txt('logError'));
      });
      return;
    }

    if (dato == 'LOG_BORRADO') {
      return;
    }

    setState(() {
      logsOffline.add(dato);
    });
  }

  Future<void> solicitarLogOffline() async {
    if (commandCharacteristic == null) {
      return;
    }

    setState(() {
      logsOffline.clear();
      logsOffline.add(T.txt('syncingHistory'));
    });

    await commandCharacteristic!.write(
      utf8.encode('GET_LOG'),
      withoutResponse: false,
    );
  }

  Future<void> confirmarLogRecibido() async {
    if (commandCharacteristic == null) {
      return;
    }

    await commandCharacteristic!.write(
      utf8.encode('ACK_LOG'),
      withoutResponse: false,
    );
  }

  Future<void> desconectarESP32() async {
    await scanSubscription?.cancel();
    await datosSubscription?.cancel();
    await logSubscription?.cancel();

    try {
      if (dispositivo != null) {
        await dispositivo!.disconnect();
      }
    } catch (e) {
      debugPrint('Error desconectando ESP32: $e');
    }

    setState(() {
      conectado = false;
      cargando = false;
      figurasActivas.clear();
      dispositivo = null;
      commandCharacteristic = null;
    });
  }

  void abrirHistorial() {
    if (!conectado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(T.txt('connectFirst')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LogOfflinePage(
          logs: logsOffline,
          onActualizar: solicitarLogOffline,
        ),
      ),
    );
  }

  bool activa(String numero) {
    return figurasActivas.contains(numero);
  }

  Widget guiaVisual(bool modoOscuro) {
    if (!mostrarGuia) return const SizedBox();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            Colors.lightBlue.withValues(alpha: modoOscuro ? 0.20 : 0.13),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.lightBlue.withValues(alpha: modoOscuro ? 0.30 : 0.22),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            T.txt('quickGuide'),
            style: GoogleFonts.fredoka(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 10),
          pasoGuia('1', T.txt('guide1'), modoOscuro),
          pasoGuia('2', T.txt('guide2'), modoOscuro),
          pasoGuia('3', T.txt('guide3'), modoOscuro),
          pasoGuia('4', T.txt('guide4'), modoOscuro),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: modoOscuro ? 0.22 : 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              T.txt('prizeGuide'),
              textAlign: TextAlign.center,
              style: GoogleFonts.baloo2(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: modoOscuro ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  mostrarGuia = false;
                });
              },
              icon: const Icon(Icons.visibility_off),
              label: Text(T.txt('hideGuide')),
            ),
          ),
        ],
      ),
    );
  }

  Widget pasoGuia(String numero, String texto, bool modoOscuro) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: Colors.blue.withValues(alpha: 0.16),
            child: Text(
              numero,
              style: GoogleFonts.fredoka(
                color: modoOscuro ? Colors.white : Colors.blue.shade800,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: GoogleFonts.baloo2(
                fontSize: 15.5,
                color: modoOscuro ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget avancesVisuales(bool modoOscuro) {
    int figurasActivasAhora = figurasActivas.length;
    int estrellas = deteccionesSesion ~/ 5;
    int medallas = deteccionesSesion ~/ 10;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            const Color(0xFF4A2C82).withValues(alpha: modoOscuro ? 0.22 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color:
              const Color(0xFF4A2C82).withValues(alpha: modoOscuro ? 0.32 : 0.18),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.withValues(alpha: 0.22),
                  Colors.deepPurple.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: Colors.deepPurple,
              size: 38,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            T.txt('sessionProgress'),
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF4A2C82),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt(mensajePremioKey),
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: modoOscuro ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              avanceItem(
                icono: Icons.touch_app_rounded,
                titulo: '$deteccionesSesion',
                subtitulo: T.txt('detections'),
                color: Colors.blue,
                modoOscuro: modoOscuro,
              ),
              avanceItem(
                icono: Icons.category_rounded,
                titulo: '$figurasActivasAhora',
                subtitulo: T.txt('activeNow'),
                color: Colors.green,
                modoOscuro: modoOscuro,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              avanceItem(
                icono: Icons.star_rounded,
                titulo: '$estrellas',
                subtitulo: T.txt('stars'),
                color: Colors.amber,
                modoOscuro: modoOscuro,
              ),
              avanceItem(
                icono: Icons.emoji_events_rounded,
                titulo: '$medallas',
                subtitulo: T.txt('medals'),
                color: Colors.deepPurple,
                modoOscuro: modoOscuro,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget avanceItem({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required Color color,
    required bool modoOscuro,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              modoOscuro ? const Color(0xFF15131A) : Colors.white,
              color.withValues(alpha: modoOscuro ? 0.20 : 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withValues(alpha: modoOscuro ? 0.26 : 0.18),
          ),
        ),
        child: Column(
          children: [
            Icon(icono, color: color, size: 30),
            const SizedBox(height: 5),
            Text(
              titulo,
              style: GoogleFonts.fredoka(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              subtitulo,
              textAlign: TextAlign.center,
              style: GoogleFonts.baloo2(
                fontSize: 13.5,
                color: modoOscuro ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recompensasCard(bool modoOscuro) {
    String mensajeRecompensa = T.txt('keepPlaying');
    IconData icono = Icons.emoji_events_outlined;
    Color color = Colors.blueGrey;

    if (deteccionesSesion >= 10) {
      mensajeRecompensa = T.txt('medalsWon');
      icono = Icons.emoji_events_rounded;
      color = Colors.deepPurple;
    } else if (deteccionesSesion >= 5) {
      mensajeRecompensa = T.txt('starsWon');
      icono = Icons.star_rounded;
      color = Colors.amber;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
            color.withValues(alpha: modoOscuro ? 0.18 : 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: modoOscuro ? 0.28 : 0.18),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icono,
              color: color,
              size: 36,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              mensajeRecompensa,
              style: GoogleFonts.fredoka(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tarjetaFigura({
    required String numero,
    required String nombreKey,
    required Color color,
    required Widget figura,
    required bool modoOscuro,
  }) {
    bool encendida = activa(numero);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0,
        end: encendida ? 1 : 0,
      ),
      duration: const Duration(milliseconds: 600),
      builder: (context, valor, child) {
        double sacudida = encendida ? math.sin(valor * math.pi * 8) * 4 : 0;

        return Transform.translate(
          offset: Offset(sacudida, 0),
          child: AnimatedScale(
            scale: encendida ? 1.06 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: encendida ? 0.95 : 0.24),
                    modoOscuro
                        ? const Color(0xFF211B2E)
                        : color.withValues(alpha: encendida ? 0.55 : 0.10),
                  ],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: encendida
                      ? color.withValues(alpha: 1)
                      : color.withValues(alpha: 0.35),
                  width: encendida ? 6 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: encendida
                        ? color.withValues(alpha: 0.70)
                        : color.withValues(alpha: 0.18),
                    blurRadius: encendida ? 28 : 12,
                    spreadRadius: encendida ? 2 : 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double tamFigura = constraints.maxWidth * 0.45;

                  if (tamFigura > 85) tamFigura = 85;
                  if (tamFigura < 58) tamFigura = 58;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        scale: encendida ? 1.18 : 0.95,
                        child: SizedBox(
                          width: tamFigura,
                          height: tamFigura,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: figura,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          T.txt(nombreKey),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: encendida
                                ? Colors.white
                                : modoOscuro
                                    ? Colors.white
                                    : const Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget circulo(Color color) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget cuadrado(Color color) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget triangulo(Color color) {
    return CustomPaint(
      size: const Size(95, 90),
      painter: TrianguloPainter(color),
    );
  }

  Widget estrella(Color color) {
    return CustomPaint(
      size: const Size(95, 90),
      painter: EstrellaPainter(color),
    );
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    datosSubscription?.cancel();
    logSubscription?.cancel();
    audioPremio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppConfig.temaApp,
          builder: (context, temaActual, _) {
            final bool modoOscuro = temaActual == ThemeMode.dark;

            const azul = Colors.blue;
            const rojo = Colors.red;
            const verde = Colors.green;
            const amarillo = Colors.amber;

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('cps'),
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                  ),
                ),
                centerTitle: true,
                backgroundColor:
                    modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                foregroundColor:
                    modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                elevation: 0,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        T.txt('cpsTitle'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: modoOscuro
                              ? Colors.white
                              : const Color(0xFF4A2C82),
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        T.txt('cpsSubTitle'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF476F),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              modoOscuro
                                  ? const Color(0xFF211B2E)
                                  : Colors.white,
                              conectado
                                  ? Colors.green.withValues(
                                      alpha: modoOscuro ? 0.22 : 0.12,
                                    )
                                  : Colors.deepPurple.withValues(
                                      alpha: modoOscuro ? 0.18 : 0.08,
                                    ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: conectado
                                ? Colors.green.withValues(alpha: 0.25)
                                : Colors.deepPurple.withValues(alpha: 0.20),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              conectado
                                  ? Icons.bluetooth_connected
                                  : Icons.bluetooth_searching,
                              size: 46,
                              color:
                                  conectado ? Colors.green : Colors.deepPurple,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              conectado
                                  ? T.txt('espConnected')
                                  : T.txt('connectEsp'),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredoka(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: modoOscuro
                                    ? Colors.white
                                    : const Color(0xFF2D2D2D),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: cargando ? null : botonBluetooth,
                                  icon: Icon(
                                    conectado
                                        ? Icons.bluetooth_disabled
                                        : Icons.bluetooth_searching,
                                  ),
                                  label: Text(
                                    cargando
                                        ? T.txt('searching')
                                        : conectado
                                            ? T.txt('disconnect')
                                            : T.txt('connectEspButton'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: conectado
                                        ? Colors.redAccent
                                        : Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: abrirHistorial,
                                  icon: const Icon(Icons.history),
                                  label: Text(T.txt('offlineHistory')),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: conectado
                                        ? Colors.deepPurple
                                        : Colors.grey,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                if (!mostrarGuia)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        mostrarGuia = true;
                                      });
                                    },
                                    icon: const Icon(Icons.help_outline),
                                    label: Text(T.txt('viewGuide')),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      guiaVisual(modoOscuro),
                      avancesVisuales(modoOscuro),
                      recompensasCard(modoOscuro),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double ancho = constraints.maxWidth;

                          int columnas = ancho < 500 ? 2 : 4;
                          double proporcion = ancho < 380 ? 0.82 : 0.90;

                          return GridView.count(
                            crossAxisCount: columnas,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: proporcion,
                            children: [
                              tarjetaFigura(
                                numero: '1',
                                nombreKey: 'circle',
                                color: azul,
                                figura: circulo(azul),
                                modoOscuro: modoOscuro,
                              ),
                              tarjetaFigura(
                                numero: '2',
                                nombreKey: 'square',
                                color: rojo,
                                figura: cuadrado(rojo),
                                modoOscuro: modoOscuro,
                              ),
                              tarjetaFigura(
                                numero: '3',
                                nombreKey: 'triangle',
                                color: verde,
                                figura: triangulo(verde),
                                modoOscuro: modoOscuro,
                              ),
                              tarjetaFigura(
                                numero: '4',
                                nombreKey: 'star',
                                color: amarillo,
                                figura: estrella(amarillo),
                                modoOscuro: modoOscuro,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class TrianguloPainter extends CustomPainter {
  final Color color;

  TrianguloPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class EstrellaPainter extends CustomPainter {
  final Color color;

  EstrellaPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    double w = size.width;
    double h = size.height;

    path.moveTo(w * 0.50, h * 0.00);
    path.lineTo(w * 0.61, h * 0.35);
    path.lineTo(w * 0.98, h * 0.35);
    path.lineTo(w * 0.68, h * 0.56);
    path.lineTo(w * 0.79, h * 0.91);
    path.lineTo(w * 0.50, h * 0.70);
    path.lineTo(w * 0.21, h * 0.91);
    path.lineTo(w * 0.32, h * 0.56);
    path.lineTo(w * 0.02, h * 0.35);
    path.lineTo(w * 0.39, h * 0.35);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LogOfflinePage extends StatefulWidget {
  final List<String> logs;
  final Future<void> Function() onActualizar;

  const LogOfflinePage({
    super.key,
    required this.logs,
    required this.onActualizar,
  });

  @override
  State<LogOfflinePage> createState() => _LogOfflinePageState();
}

class _LogOfflinePageState extends State<LogOfflinePage> {
  bool cargando = false;

  Future<void> actualizar() async {
    setState(() {
      cargando = true;
    });

    await widget.onActualizar();

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppConfig.idioma,
      builder: (context, idioma, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppConfig.temaApp,
          builder: (context, temaActual, _) {
            final bool modoOscuro = temaActual == ThemeMode.dark;

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('offlineHistory'),
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                  ),
                ),
                centerTitle: true,
                backgroundColor:
                    modoOscuro ? const Color(0xFF211B2E) : Colors.white,
                foregroundColor:
                    modoOscuro ? Colors.white : const Color(0xFF2D2D2D),
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            modoOscuro
                                ? const Color(0xFF211B2E)
                                : Colors.white,
                            Colors.deepPurple.withValues(
                              alpha: modoOscuro ? 0.20 : 0.10,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.deepPurple.withValues(
                            alpha: modoOscuro ? 0.30 : 0.18,
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.storage,
                            size: 58,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            T.txt('savedRecords'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: modoOscuro
                                  ? Colors.white
                                  : const Color(0xFF4A2C82),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            T.txt('offlineData'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.baloo2(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color:
                                  modoOscuro ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: cargando ? null : actualizar,
                            icon: Icon(
                              cargando ? Icons.hourglass_top : Icons.sync,
                            ),
                            label: Text(
                              cargando
                                  ? T.txt('updating')
                                  : T.txt('updateHistory'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: widget.logs.isEmpty
                          ? Center(
                              child: Text(
                                T.txt('noRecords'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.baloo2(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: modoOscuro
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: widget.logs.length,
                              itemBuilder: (context, index) {
                                final log = widget.logs[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        modoOscuro
                                            ? const Color(0xFF211B2E)
                                            : Colors.white,
                                        Colors.deepPurple.withValues(
                                          alpha: modoOscuro ? 0.18 : 0.08,
                                        ),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: Colors.deepPurple.withValues(
                                        alpha: modoOscuro ? 0.28 : 0.14,
                                      ),
                                      width: 1.3,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.deepPurple.withValues(
                                          alpha: 0.15,
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: GoogleFonts.fredoka(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          log,
                                          style: GoogleFonts.baloo2(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: modoOscuro
                                                ? Colors.white70
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}