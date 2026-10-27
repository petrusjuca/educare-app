import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../modules/ble/services/ble_service.dart';

/// Tela splash que força a conexão BLE antes de entrar no app
class BleConnectionSplash extends StatefulWidget {
  final Widget nextScreen;

  const BleConnectionSplash({
    super.key,
    required this.nextScreen,
  });

  @override
  State<BleConnectionSplash> createState() => _BleConnectionSplashState();
}

class _BleConnectionSplashState extends State<BleConnectionSplash> {
  late BleService _bleService;
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  bool _isConnecting = false;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionSubscription;
  String _statusMessage = 'Iniciando busca de dispositivos...';

  @override
  void initState() {
    super.initState();
    _bleService = BleService();
    _setupBleListeners();
    _startScan();
  }

  void _setupBleListeners() {
    // Listener para resultados de scan
    _scanSubscription = _bleService.scanResultsStream.listen((results) {
      if (mounted) {
        setState(() {
          _scanResults = results;
          if (results.isEmpty) {
            _statusMessage = 'Procurando por ESP32...';
          } else {
            _statusMessage = 'Dispositivos encontrados! Selecione um para conectar.';
          }
        });
      }
    });

    // Listener para mudanças de conexão
    _connectionSubscription = _bleService.connectionStateStream.listen((connected) {
      if (mounted && connected) {
        setState(() {
          _isConnecting = false;
          _statusMessage = 'Conectado com sucesso! 🎉';
        });

        // Navega para a tela principal após 2 segundos
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => widget.nextScreen),
            );
          }
        });
      }
    });
  }

  void _startScan() async {
    if (mounted) {
      setState(() {
        _isScanning = true;
        _statusMessage = 'Procurando por ESP32...';
      });
    }

    try {
      await _bleService.startScan();
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Erro ao iniciar busca: $e';
        });
      }
    }
  }

  Future<void> _connectToDevice(ScanResult result) async {
    if (mounted) {
      setState(() {
        _isConnecting = true;
        _statusMessage = 'Conectando a ${result.device.platformName}...';
      });
    }

    try {
      final success = await _bleService.connectToDevice(result.device);
      
      if (!success) {
        if (mounted) {
          setState(() {
            _isConnecting = false;
            _statusMessage = 'Falha ao conectar. Tente novamente.';
          });
        }
      }
      // Se sucesso, o listener já navega automaticamente
    } catch (e) {
      debugPrint('Erro ao conectar: $e');
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _statusMessage = 'Erro: ${e.toString().substring(0, 50)}...';
        });
      }
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    _bleService.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.bluetooth,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Conectar ESP32',
                    style: GoogleFonts.fredoka(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Lista de dispositivos
            Expanded(
              child: _scanResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isScanning)
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          else
                            const Icon(
                              Icons.bluetooth_disabled,
                              size: 48,
                              color: Colors.white70,
                            ),
                          const SizedBox(height: 16),
                          Text(
                            _isScanning ? 'Procurando...' : 'Nenhum dispositivo encontrado',
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _scanResults.length,
                      itemBuilder: (context, index) {
                        final result = _scanResults[index];
                        final deviceName = result.device.platformName.isEmpty
                            ? 'Dispositivo desconhecido'
                            : result.device.platformName;
                        final isEducare = deviceName.contains('EDUCARE') || 
                                          deviceName.contains('ESP32_NimBLE') ||
                                          deviceName.contains('DLJ3');
                        final signalStrength = result.rssi;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isEducare ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.bluetooth,
                              color: isEducare ? const Color(0xFF4CAF50) : Colors.grey,
                            ),
                            title: Text(
                              deviceName,
                              style: GoogleFonts.fredoka(
                                fontWeight: FontWeight.w600,
                                color: isEducare ? const Color(0xFF4CAF50) : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Sinal: $signalStrength dBm${isEducare ? ' ✓ EDUCARE' : ''}',
                              style: GoogleFonts.fredoka(fontSize: 12),
                            ),
                            trailing: _isConnecting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () => _connectToDevice(result),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isEducare
                                          ? const Color(0xFF4CAF50)
                                          : Colors.grey,
                                    ),
                                    child: Text(
                                      'Conectar',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            onTap: _isConnecting ? null : () => _connectToDevice(result),
                          ),
                        );
                      },
                    ),
            ),

            // Footer com opção de pular (apenas para debug)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => widget.nextScreen),
                  );
                },
                child: Text(
                  'Continuar sem conectar (debug)',
                  style: GoogleFonts.fredoka(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
