import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BleStatusBanner extends StatelessWidget {
  final bool isConnected;
  final String deviceName;

  const BleStatusBanner({
    super.key,
    required this.isConnected,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected ? const Color(0xFFE8F5E8) : const Color(0xFFFFEBEE),
        border: Border(
          bottom: BorderSide(
            color: isConnected ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: isConnected ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isConnected
                ? 'Conectado ao $deviceName'
                : 'BLE desconectado - Toque nos botões',
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isConnected ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
            ),
          ),
        ],
      ),
    );
  }
}