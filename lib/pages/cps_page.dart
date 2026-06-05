import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import 'app_config.dart';
import 'app_texts.dart';

TextStyle fredoka({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'Fredoka',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );
}

TextStyle baloo2({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'Baloo2',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );
}

class CpsPage extends StatefulWidget {
  const CpsPage({super.key});

  @override
  State<CpsPage> createState() => _CpsPageState();
}

class _CpsPageState extends State<CpsPage> with WidgetsBindingObserver {
  bool conectado = false;
  bool cargando = false;
  bool mostrarGuia = true;

  int deteccionesSesion = 0;
  int estrellasNotificadas = 0;
  int medallasNotificadas = 0;

  String mensajePremioKey = 'defaultPrize';

  final AudioPlayer audioPremio = AudioPlayer();
  final AudioPlayer audioFigura = AudioPlayer();

  int _idReproduccionFiguras = 0;

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

  static _CpsPageState? _paginaActiva;
  static BluetoothDevice? _dispositivoPersistente;
  static BluetoothCharacteristic? _commandCharacteristicPersistente;
  static StreamSubscription? _scanSubscriptionPersistente;
  static StreamSubscription? _datosSubscriptionPersistente;
  static StreamSubscription? _logSubscriptionPersistente;
  static bool _conectadoPersistente = false;
  static bool _cargandoPersistente = false;
  static bool _mostrarGuiaPersistente = true;
  static int _deteccionesSesionPersistente = 0;
  static int _estrellasNotificadasPersistente = 0;
  static int _medallasNotificadasPersistente = 0;
  static String _mensajePremioKeyPersistente = 'defaultPrize';
  static Set<String> _figurasActivasPersistente = {};
  static List<String> _logsOfflinePersistente = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _paginaActiva = this;
    _restaurarEstadoPersistente();
  }

  void _restaurarEstadoPersistente() {
    conectado = _conectadoPersistente;
    cargando = _cargandoPersistente;
    mostrarGuia = _mostrarGuiaPersistente;
    deteccionesSesion = _deteccionesSesionPersistente;
    estrellasNotificadas = _estrellasNotificadasPersistente;
    medallasNotificadas = _medallasNotificadasPersistente;
    mensajePremioKey = _mensajePremioKeyPersistente;
    figurasActivas = Set<String>.from(_figurasActivasPersistente);
    logsOffline = List<String>.from(_logsOfflinePersistente);
    dispositivo = _dispositivoPersistente;
    commandCharacteristic = _commandCharacteristicPersistente;
    scanSubscription = _scanSubscriptionPersistente;
    datosSubscription = _datosSubscriptionPersistente;
    logSubscription = _logSubscriptionPersistente;
  }

  void _guardarEstadoPersistente() {
    _conectadoPersistente = conectado;
    _cargandoPersistente = cargando;
    _mostrarGuiaPersistente = mostrarGuia;
    _deteccionesSesionPersistente = deteccionesSesion;
    _estrellasNotificadasPersistente = estrellasNotificadas;
    _medallasNotificadasPersistente = medallasNotificadas;
    _mensajePremioKeyPersistente = mensajePremioKey;
    _figurasActivasPersistente = Set<String>.from(figurasActivas);
    _logsOfflinePersistente = List<String>.from(logsOffline);
    _dispositivoPersistente = dispositivo;
    _commandCharacteristicPersistente = commandCharacteristic;
    _scanSubscriptionPersistente = scanSubscription;
    _datosSubscriptionPersistente = datosSubscription;
    _logSubscriptionPersistente = logSubscription;
  }

  static void _limpiarEstadoPersistente() {
    _conectadoPersistente = false;
    _cargandoPersistente = false;
    _mostrarGuiaPersistente = true;
    _deteccionesSesionPersistente = 0;
    _estrellasNotificadasPersistente = 0;
    _medallasNotificadasPersistente = 0;
    _mensajePremioKeyPersistente = 'defaultPrize';
    _figurasActivasPersistente = {};
    _logsOfflinePersistente = [];
    _dispositivoPersistente = null;
    _commandCharacteristicPersistente = null;
    _scanSubscriptionPersistente = null;
    _datosSubscriptionPersistente = null;
    _logSubscriptionPersistente = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      _desconectarAlCerrarApp();
    }
  }

  Future<void> _desconectarAlCerrarApp() async {
    try {
      await scanSubscription?.cancel();
      await datosSubscription?.cancel();
      await logSubscription?.cancel();
      cancelarSonidosFiguras();

      if (dispositivo != null) {
        await dispositivo!.disconnect();
      }
    } catch (e) {
      debugPrint('Error desconectando al cerrar la app: $e');
    }

    _limpiarEstadoPersistente();
  }

  Future<void> botonBluetooth() async {
    if (conectado) {
      await desconectarESP32();
    } else {
      await buscarDispositivosBluetooth();
    }
  }

  Future<void> vibrarSuave() async {
    if (!AppConfig.vibracionActiva.value) return;

    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final bool tieneVibrador = await Vibration.hasVibrator();

        if (tieneVibrador) {
          await Vibration.vibrate(
            pattern: [0, 220, 80, 220],
            intensities: [0, 255, 0, 255],
          );
          return;
        }
      }

      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('${T.txt('strongVibrationError')}: $e');

      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  Future<void> vibrarPremio() async {
    if (!AppConfig.vibracionActiva.value) return;

    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final bool tieneVibrador = await Vibration.hasVibrator();

        if (tieneVibrador) {
          await Vibration.vibrate(
            pattern: [0, 160, 70, 160, 70, 220],
            intensities: [0, 230, 0, 230, 0, 255],
          );
          return;
        }
      }

      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('${T.txt('rewardVibrationError')}: $e');

      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  Future<bool> pedirPermisosBluetooth() async {
    if (kIsWeb) return true;

    if (defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }

    final Map<Permission, PermissionStatus> permisos = await [
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(T.txt('enableBluetoothPermission')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

      return false;
    }

    return true;
  }

  Future<bool> verificarBluetoothEncendido() async {
    if (kIsWeb) return true;

    try {
      final BluetoothAdapterState estado =
          await FlutterBluePlus.adapterState.first.timeout(
        const Duration(seconds: 6),
      );

      if (estado == BluetoothAdapterState.on) {
        return true;
      }

      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          await FlutterBluePlus.turnOn();

          await FlutterBluePlus.adapterState
              .where((state) => state == BluetoothAdapterState.on)
              .first
              .timeout(const Duration(seconds: 8));

          return true;
        } catch (e) {
          debugPrint('${T.txt('bluetoothAutoEnableError')}: $e');
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(T.txt('turnOnBluetooth')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

      return false;
    } catch (e) {
      debugPrint('${T.txt('bleUnavailablePlatform')}: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(T.txt('bleUnavailablePlatform')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

      return false;
    }
  }

  Future<void> buscarDispositivosBluetooth() async {
    final bool permisosOk = await pedirPermisosBluetooth();

    if (!permisosOk) return;

    final bool bluetoothListo = await verificarBluetoothEncendido();

    if (!bluetoothListo) return;

    setState(() {
      cargando = true;
      conectado = false;
      figurasActivas.clear();
    });

    _guardarEstadoPersistente();

    await scanSubscription?.cancel();
    await datosSubscription?.cancel();
    await logSubscription?.cancel();

    final Map<String, ScanResult> dispositivosMap = {};

    try {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      scanSubscription = FlutterBluePlus.scanResults.listen((resultados) {
        for (final resultado in resultados) {
          final BluetoothDevice device = resultado.device;

          final String nombreDevice = device.platformName.trim();
          final String nombreAdv = resultado.advertisementData.advName.trim();
          final String id = device.remoteId.str;

          debugPrint(
            'BLE encontrado: deviceName="$nombreDevice" advName="$nombreAdv" '
            'id=$id rssi=${resultado.rssi} servicios=${resultado.advertisementData.serviceUuids}',
          );

          dispositivosMap[id] = resultado;
        }
      });

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        withServices: const [],
        androidUsesFineLocation: true,
        webOptionalServices: [
          Guid(serviceUuid),
          Guid(characteristicUuid),
          Guid(logUuid),
          Guid(commandUuid),
        ],
      );

      _guardarEstadoPersistente();

      await Future.delayed(const Duration(seconds: 15));

      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      final List<ScanResult> dispositivosEncontrados =
          dispositivosMap.values.toList();

      dispositivosEncontrados.sort((a, b) {
        final bool aEsEsp = esDispositivoEsp(a);
        final bool bEsEsp = esDispositivoEsp(b);

        if (aEsEsp && !bEsEsp) return -1;
        if (!aEsEsp && bEsEsp) return 1;

        final String aName = nombreVisible(a);
        final String bName = nombreVisible(b);

        final bool aTieneNombre =
            aName.trim().isNotEmpty && aName != T.txt('unnamedDevice');

        final bool bTieneNombre =
            bName.trim().isNotEmpty && bName != T.txt('unnamedDevice');

        if (aTieneNombre && !bTieneNombre) return -1;
        if (!aTieneNombre && bTieneNombre) return 1;

        return b.rssi.compareTo(a.rssi);
      });

      setState(() {
        cargando = false;
      });

      _guardarEstadoPersistente();

      if (!mounted) return;

      mostrarDispositivosBluetooth(dispositivosEncontrados);
    } catch (e) {
      setState(() {
        cargando = false;
        conectado = false;
      });

      debugPrint('${T.txt('bleSearchError')}: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${T.txt('bleSearchError')}: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  bool esDispositivoEsp(ScanResult resultado) {
    final String nombreDevice = resultado.device.platformName.trim();
    final String nombreAdv = resultado.advertisementData.advName.trim();

    final bool esEspPorNombre =
        nombreDevice == nombreArduino || nombreAdv == nombreArduino;

    final bool esEspPorServicio = resultado.advertisementData.serviceUuids.any(
      (uuid) => uuid.toString().toLowerCase() == serviceUuid.toLowerCase(),
    );

    return esEspPorNombre || esEspPorServicio;
  }

  String nombreVisible(ScanResult resultado) {
    final String nombreDevice = resultado.device.platformName.trim();
    final String nombreAdv = resultado.advertisementData.advName.trim();

    if (nombreDevice.isNotEmpty) return nombreDevice;
    if (nombreAdv.isNotEmpty) return nombreAdv;

    return T.txt('unnamedDevice');
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
      backgroundColor: modoOscuroInicial
          ? const Color(0xFF15131A)
          : const Color(0xFFFAF7F2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: AppConfig.temaApp,
            builder: (context, temaActual, _) {
              final bool modoOscuro =
                  Theme.of(context).brightness == Brightness.dark;

              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.82,
                ),
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
                          Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color:
                                  modoOscuro ? Colors.white24 : Colors.black26,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Icon(
                            Icons.bluetooth_searching,
                            size: 55,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            T.txt('selectBluetoothDevice'),
                            textAlign: TextAlign.center,
                            style: fredoka(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: modoOscuro
                                  ? Colors.white
                                  : const Color(0xFF4A2C82),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            T.txt('bleDevicesDescription'),
                            textAlign: TextAlign.center,
                            style: baloo2(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color:
                                  modoOscuro ? Colors.white70 : Colors.black54,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dispositivos.length,
                              itemBuilder: (context, index) {
                                final resultado = dispositivos[index];

                                final String nombre = nombreVisible(resultado);
                                final String id = resultado.device.remoteId.str;
                                final int rssi = resultado.rssi;
                                final bool esEsp = esDispositivoEsp(resultado);
                                final List<Guid> servicios =
                                    resultado.advertisementData.serviceUuids;

                                final Color colorCard =
                                    esEsp ? Colors.green : Colors.blueGrey;

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

                                        await conectarDispositivoSeleccionado();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              modoOscuro
                                                  ? const Color(0xFF211B2E)
                                                  : Colors.white,
                                              colorCard.withValues(
                                                alpha:
                                                    modoOscuro ? 0.22 : 0.10,
                                              ),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(
                                            color: colorCard.withValues(
                                              alpha: esEsp ? 0.42 : 0.20,
                                            ),
                                            width: esEsp ? 2 : 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: colorCard
                                                  .withValues(alpha: 0.16),
                                              child: Icon(
                                                esEsp
                                                    ? Icons.developer_board
                                                    : Icons.bluetooth,
                                                color: colorCard,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          nombre,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: fredoka(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: esEsp
                                                                ? Colors.green
                                                                : modoOscuro
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(
                                                                        0xFF2D2D2D,
                                                                      ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorCard
                                                              .withValues(
                                                            alpha: 0.16,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                        ),
                                                        child: Text(
                                                          esEsp
                                                              ? 'ESP_CPS'
                                                              : 'BLE',
                                                          style: fredoka(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: colorCard,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    '${T.txt('signal')}: $rssi dBm',
                                                    style: baloo2(
                                                      fontSize: 14,
                                                      color: modoOscuro
                                                          ? Colors.white70
                                                          : Colors.black54,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    id,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: baloo2(
                                                      fontSize: 12.5,
                                                      color: modoOscuro
                                                          ? Colors.white38
                                                          : Colors.black38,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 2,
                                                    ),
                                                    child: Text(
                                                      servicios.isEmpty
                                                          ? T.txt(
                                                              'servicesNotAdvertised',
                                                            )
                                                          : '${T.txt('services')}: ${servicios.length}',
                                                      style: baloo2(
                                                        fontSize: 12.5,
                                                        color: modoOscuro
                                                            ? Colors.white38
                                                            : Colors.black38,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: colorCard,
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

  Future<void> conectarDispositivoSeleccionado() async {
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
        timeout: const Duration(seconds: 12),
        autoConnect: false,
      );
    } catch (e) {
      debugPrint('${T.txt('deviceAlreadyConnectedError')}: $e');
    }

    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await dispositivo!.requestMtu(185);

        await dispositivo!.requestConnectionPriority(
          connectionPriorityRequest: ConnectionPriority.high,
        );

        debugPrint(T.txt('bleOptimizedAndroid'));
      }
    } catch (e) {
      debugPrint('${T.txt('bleOptimizeError')}: $e');
    }

    try {
      final List<BluetoothService> servicios =
          await dispositivo!.discoverServices();

      bool encontroServicioCps = false;
      bool encontroStatus = false;

      commandCharacteristic = null;

      for (BluetoothService servicio in servicios) {
        final String servicioId = servicio.uuid.toString().toLowerCase();

        if (servicioId == serviceUuid.toLowerCase()) {
          encontroServicioCps = true;

          for (BluetoothCharacteristic c in servicio.characteristics) {
            final String uuid = c.uuid.toString().toLowerCase();

            if (uuid == characteristicUuid.toLowerCase()) {
              encontroStatus = true;

              await c.setNotifyValue(true);

              await datosSubscription?.cancel();

              datosSubscription = c.lastValueStream.listen((valor) {
                if (valor.isNotEmpty) {
                  final String dato = utf8.decode(valor).trim();

                  _CpsPageState._paginaActiva?.actualizarFiguras(dato);

                  debugPrint('${T.txt('dataReceived')}: $dato');
                }
              });

              try {
                final List<int> valorInicial = await c.read();

                if (valorInicial.isNotEmpty) {
                  final String datoInicial = utf8.decode(valorInicial).trim();
                  actualizarFiguras(datoInicial);
                }
              } catch (e) {
                debugPrint('${T.txt('initialValueReadError')}: $e');
              }
            }

            if (uuid == logUuid.toLowerCase()) {
              await c.setNotifyValue(true);

              await logSubscription?.cancel();

              logSubscription = c.lastValueStream.listen((valor) {
                if (valor.isNotEmpty) {
                  final String dato = utf8.decode(valor).trim();

                  _CpsPageState._paginaActiva?.recibirLog(dato);

                  debugPrint('${T.txt('logReceived')}: $dato');
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

      _guardarEstadoPersistente();

      if (!encontroServicioCps || !encontroStatus) {
        try {
          await dispositivo?.disconnect();
        } catch (_) {}

        setState(() {
          conectado = false;
          cargando = false;
          dispositivo = null;
          commandCharacteristic = null;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(T.txt('noBleService')),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        conectado = false;
        cargando = false;
      });

      debugPrint('${T.txt('discoverServicesError')}: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${T.txt('connectReadServicesError')}: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void cancelarSonidosFiguras() {
    _idReproduccionFiguras++;

    try {
      audioFigura.stop();
    } catch (_) {}
  }

  String? obtenerRutaSonidoFigura(String numero) {
    final String idiomaActual = AppConfig.idioma.value;
    final bool usarIngles = idiomaActual == 'en';

    if (usarIngles) {
      if (numero == '1') return 'sonidos/en/circle.mp3';
      if (numero == '2') return 'sonidos/en/square.mp3';
      if (numero == '3') return 'sonidos/en/triangle.mp3';
      if (numero == '4') return 'sonidos/en/star.mp3';
    } else {
      if (numero == '1') return 'sonidos/es/circulo.mp3';
      if (numero == '2') return 'sonidos/es/cuadrado.mp3';
      if (numero == '3') return 'sonidos/es/triangulo.mp3';
      if (numero == '4') return 'sonidos/es/estrella.mp3';
    }

    return null;
  }

 Future<void> reproducirSonidosFiguras(Set<String> figuras) async {
  if (!AppConfig.sonidosActivos.value) return;
  if (figuras.isEmpty) return;

  _idReproduccionFiguras++;

  final int idActual = _idReproduccionFiguras;

  try {
    await audioFigura.stop();

    final List<String> figurasOrdenadas = figuras.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    for (final String figura in figurasOrdenadas) {
      if (idActual != _idReproduccionFiguras) return;

      final String? ruta = obtenerRutaSonidoFigura(figura);

      if (ruta == null) continue;

      await audioFigura.stop();

      if (idActual != _idReproduccionFiguras) return;

      await audioFigura.play(AssetSource(ruta));

      final DateTime inicio = DateTime.now();

      while (audioFigura.state == PlayerState.playing) {
        if (idActual != _idReproduccionFiguras) return;

        await Future.delayed(const Duration(milliseconds: 80));

        final int tiempo = DateTime.now().difference(inicio).inMilliseconds;

        if (tiempo > 3000) {
          await audioFigura.stop();
          break;
        }
      }

      await Future.delayed(const Duration(milliseconds: 120));
    }
  } catch (e) {
    debugPrint('Error reproduciendo sonido de figura: $e');
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

  bool huboCambio = !_setsIguales(nuevasFiguras, figurasActivas);

  bool huboNuevaDeteccion = nuevasFiguras.isNotEmpty && huboCambio;

  if (!mounted) {
    figurasActivas = nuevasFiguras;
    if (huboNuevaDeteccion) {
      deteccionesSesion++;
    }
    _guardarEstadoPersistente();
    return;
  }

  setState(() {
    figurasActivas = nuevasFiguras;

    if (huboNuevaDeteccion) {
      deteccionesSesion++;
    }
  });

  _guardarEstadoPersistente();

  if (huboCambio && nuevasFiguras.isEmpty) {
    cancelarSonidosFiguras();
  }

  if (huboNuevaDeteccion) {
    vibrarSuave();
    reproducirSonidosFiguras(nuevasFiguras);
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

      await vibrarPremio();
      await reproducirSonidoPremio('medalla.mp3');
      return;
    }

    if (estrellasActuales > estrellasNotificadas) {
      estrellasNotificadas = estrellasActuales;

      setState(() {
        mensajePremioKey = 'starPrize';
      });

      await vibrarPremio();
      await reproducirSonidoPremio('estrella.mp3');
    }
  }

  Future<void> reproducirSonidoPremio(String sonido) async {
    if (!AppConfig.sonidosActivos.value) return;

    try {
      await audioPremio.stop();
      await audioPremio.play(AssetSource('sonidos/$sonido'));
    } catch (e) {
      debugPrint('${T.txt('rewardSoundError')}: $e');
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

    cancelarSonidosFiguras();

    try {
      if (dispositivo != null) {
        await dispositivo!.disconnect();
      }
    } catch (e) {
      debugPrint('${T.txt('disconnectEspError')}: $e');
    }

    if (!mounted) {
      conectado = false;
      cargando = false;
      figurasActivas.clear();
      dispositivo = null;
      commandCharacteristic = null;
      scanSubscription = null;
      datosSubscription = null;
      logSubscription = null;
      _limpiarEstadoPersistente();
      return;
    }

    setState(() {
      conectado = false;
      cargando = false;
      figurasActivas.clear();
      dispositivo = null;
      commandCharacteristic = null;
      scanSubscription = null;
      datosSubscription = null;
      logSubscription = null;
    });

    _limpiarEstadoPersistente();
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
            style: fredoka(
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
              style: baloo2(
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
              style: fredoka(
                color: modoOscuro ? Colors.white : Colors.blue.shade800,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: baloo2(
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
          color: const Color(0xFF4A2C82).withValues(
            alpha: modoOscuro ? 0.32 : 0.18,
          ),
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
            style: fredoka(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: modoOscuro ? Colors.white : const Color(0xFF4A2C82),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            T.txt(mensajePremioKey),
            textAlign: TextAlign.center,
            style: baloo2(
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
              style: fredoka(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              subtitulo,
              textAlign: TextAlign.center,
              style: baloo2(
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
            child: Icon(icono, color: color, size: 36),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              mensajeRecompensa,
              style: fredoka(
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
      tween: Tween<double>(begin: 0, end: encendida ? 1 : 0),
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
                          child: FittedBox(fit: BoxFit.contain, child: figura),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          T.txt(nombreKey),
                          textAlign: TextAlign.center,
                          style: fredoka(
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
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
    WidgetsBinding.instance.removeObserver(this);

    if (_paginaActiva == this) {
      _paginaActiva = null;
    }

    _guardarEstadoPersistente();
    cancelarSonidosFiguras();
    audioPremio.dispose();
    audioFigura.dispose();
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
            final bool modoOscuro =
                Theme.of(context).brightness == Brightness.dark;

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
                  style: fredoka(
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
                        style: fredoka(
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
                        style: baloo2(
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
                              style: fredoka(
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
            final bool modoOscuro =
                Theme.of(context).brightness == Brightness.dark;

            return Scaffold(
              backgroundColor: modoOscuro
                  ? const Color(0xFF15131A)
                  : const Color(0xFFFAF7F2),
              appBar: AppBar(
                title: Text(
                  T.txt('offlineHistory'),
                  style: fredoka(
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
                            modoOscuro ? const Color(0xFF211B2E) : Colors.white,
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
                            style: fredoka(
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
                            style: baloo2(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: modoOscuro
                                  ? Colors.white70
                                  : Colors.black54,
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
                                style: baloo2(
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
                                        backgroundColor: Colors.deepPurple
                                            .withValues(alpha: 0.15),
                                        child: Text(
                                          '${index + 1}',
                                          style: fredoka(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          log,
                                          style: baloo2(
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