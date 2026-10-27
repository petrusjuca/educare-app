import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ble_service.dart';
import '../../../word_game/presenter/pages/game_page/game_page.dart';

class DeviceSelectionPage extends StatefulWidget {
  const DeviceSelectionPage({super.key});

  @override
  State<DeviceSelectionPage> createState() => _DeviceSelectionPageState();
}

class _DeviceSelectionPageState extends State<DeviceSelectionPage> {
  final BleService _bleService = BleService();
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  bool _isConnecting = false;
  BluetoothDevice? _selectedDevice;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionSubscription;
  String _statusMessage = 'Pronto para escanear dispositivos';

  @override
  void initState() {
    super.initState();
    _setupBleListeners();
    _startScan();
  }

  void _setupBleListeners() {
    // Listen for scan results
    _scanSubscription = _bleService.scanResultsStream.listen((results) {
      setState(() {
        _scanResults = results;
      });
    });

    // Listen for connection state changes
    _connectionSubscription = _bleService.connectionStateStream.listen((connected) {
      if (connected) {
        setState(() {
          _isConnecting = false;
          _statusMessage = 'Conectado com sucesso! Monitorando serviços Bluetooth...';
        });

        // Navigate to game page after successful connection
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const GamePage(),
            ),
          );
        });
      } else if (_isConnecting) {
        setState(() {
          _isConnecting = false;
          _statusMessage = 'Falha na conexão. Tente novamente.';
        });
      }
    });
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResults = [];
      _statusMessage = 'Escaneando dispositivos...';
    });

    try {
      await _bleService.startScan();

      // Auto-stop scan after 10 seconds
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted && _isScanning) {
          _stopScan();
        }
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _statusMessage = 'Erro ao escanear: $e';
      });
    }
  }

  Future<void> _stopScan() async {
    if (!_isScanning) return;

    setState(() {
      _isScanning = false;
      _statusMessage = 'Escaneamento concluído';
    });

    await _bleService.stopScan();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isConnecting = true;
      _selectedDevice = device;
      _statusMessage = 'Conectando a ${device.name}...';
    });

    await _bleService.connectToDevice(device);
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecionar Dispositivo',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.indigo.shade100,
        foregroundColor: Colors.indigo.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.02),
                _buildStatusCard(),
                SizedBox(height: size.height * 0.03),
                _buildDeviceList(),
                SizedBox(height: size.height * 0.03),
                _buildScanButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Status',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.indigo.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              color: Colors.indigo.shade600,
            ),
          ),
          if (_isScanning || _isConnecting)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo.shade400),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceList() {
    // Show all discovered devices
    final devicesToShow = _scanResults;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: devicesToShow.isEmpty
            ? Center(
                child: Text(
                  _isScanning
                      ? 'Procurando dispositivos...'
                      : 'Nenhum dispositivo encontrado',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    color: Colors.indigo.shade400,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: devicesToShow.length,
                itemBuilder: (context, index) {
                  final result = devicesToShow[index];
                  final device = result.device;
                  // Contrato v3: o nome pode vir com sufixo (EDUCARE-01), casa pelo prefixo
                  final isTarget = device.name.startsWith(BleService.TARGET_DEVICE_NAME);
                  final isSelected = _selectedDevice == device;

                  return ListTile(
                    title: Text(
                      device.name.isNotEmpty ? device.name : 'Dispositivo Desconhecido',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: isTarget ? FontWeight.bold : FontWeight.normal,
                        color: isTarget ? Colors.indigo.shade800 : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.id.toString(),
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (isTarget)
                          Text(
                            'Dispositivo recomendado',
                            style: GoogleFonts.fredoka(
                              fontSize: 11,
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    trailing: isSelected && _isConnecting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo.shade400),
                            ),
                          )
                        : Icon(
                            isTarget ? Icons.bluetooth_connected : Icons.bluetooth,
                            color: isTarget ? Colors.indigo.shade600 : Colors.grey,
                          ),
                    onTap: _isConnecting
                        ? null
                        : () => _connectToDevice(device),
                    tileColor: isTarget ? Colors.indigo.shade50 : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildScanButton() {
    return ElevatedButton.icon(
      onPressed: _isScanning ? _stopScan : _startScan,
      icon: Icon(
        _isScanning ? Icons.stop : Icons.refresh,
        color: Colors.white,
      ),
      label: Text(
        _isScanning ? 'Parar Escaneamento' : 'Escanear Novamente',
        style: GoogleFonts.fredoka(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isScanning ? Colors.red.shade400 : Colors.indigo.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
