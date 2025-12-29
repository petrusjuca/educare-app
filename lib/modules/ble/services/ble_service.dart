import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async' show Timer;

// Initialize FlutterBluePlus with license
void initFlutterBluePlus() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
}

// Define a mapping between BluetoothConnectionState and BluetoothDeviceState
extension ConnectionStateToDeviceState on BluetoothConnectionState {
  BluetoothDeviceState toDeviceState() {
    switch (this) {
      case BluetoothConnectionState.connected:
        return BluetoothDeviceState.connected;
      case BluetoothConnectionState.disconnected:
        return BluetoothDeviceState.disconnected;
      default:
        return BluetoothDeviceState.disconnected;
    }
  }
}

class BleService {
  // Singleton pattern
  static final BleService _instance = BleService._internal();
  factory BleService() => _instance;
  BleService._internal();

  // Constants - keeping for backward compatibility
  static const String TARGET_DEVICE_NAME = "EDUCARE - DLJ3";
  static const String SERVICE_UUID = "1234";
  static const String CHARACTERISTIC_UUID = "5678";

  // BLE state
  final FlutterBluePlus _flutterBlue = FlutterBluePlus();
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _vowelCharacteristic;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _characteristicSubscription;
  List<StreamSubscription> _serviceSubscriptions = [];
  Map<String, BluetoothCharacteristic> _monitoredCharacteristics = {};
  Timer? _periodicReadTimer;

  // Stream controllers
  final _deviceStateController = StreamController<BluetoothDeviceState>.broadcast();
  final _vowelNotificationController = StreamController<String>.broadcast();
  final _scanResultsController = StreamController<List<ScanResult>>.broadcast();
  final _connectionStateController = StreamController<bool>.broadcast();
  final _bleDataController = StreamController<Map<String, dynamic>>.broadcast();

  // Streams
  Stream<BluetoothDeviceState> get deviceStateStream => _deviceStateController.stream;
  Stream<String> get vowelNotificationStream => _vowelNotificationController.stream;
  Stream<List<ScanResult>> get scanResultsStream => _scanResultsController.stream;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;
  Stream<Map<String, dynamic>> get bleDataStream => _bleDataController.stream;

  // Getters
  bool get isConnected => _connectedDevice != null;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  // Start scanning for BLE devices
  Future<void> startScan() async {
    // Check bluetooth state
    var state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      debugPrint("Bluetooth OFF");
      return;
    }

    // Stop previous scan
    await FlutterBluePlus.stopScan();

    // Attach listener only once
    FlutterBluePlus.onScanResults.listen((results) {
      _scanResultsController.add(results);
    });

    // Start scan
    await FlutterBluePlus.startScan(
      androidUsesFineLocation: true,
      timeout: const Duration(seconds: 30),
    );
  }


  // Stop scanning for BLE devices
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // Connect to a specific device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false, license: License.free);
      _connectedDevice = device;

      // Listen for connection state changes
      _connectionSubscription = device.connectionState.listen((state) {
        // Convert BluetoothConnectionState to BluetoothDeviceState
        final deviceState = state == BluetoothConnectionState.connected
            ? BluetoothDeviceState.connected
            : BluetoothDeviceState.disconnected;
        _deviceStateController.add(deviceState);
        _connectionStateController.add(state == BluetoothConnectionState.connected);

        if (state == BluetoothConnectionState.disconnected) {
          _cleanupConnection();
        }
      });

      // Discover services
      await _discoverServicesAndCharacteristics();

      return true;
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      _cleanupConnection();
      return false;
    }
  }

  // Discover services and characteristics
  Future<void> _discoverServicesAndCharacteristics() async {
    if (_connectedDevice == null) return;

    try {
      List<BluetoothService> services = await _connectedDevice!.discoverServices();
      debugPrint('Discovered ${services.length} services');

      // First, look for the target service and characteristic for backward compatibility
      bool foundTargetCharacteristic = false;
      for (BluetoothService service in services) {
        String serviceUuid = service.uuid.toString().toUpperCase();
        debugPrint('Service discovered: $serviceUuid');

        if (serviceUuid.contains(SERVICE_UUID)) {
          debugPrint('Found target service: $serviceUuid');

          for (BluetoothCharacteristic characteristic in service.characteristics) {
            String characteristicUuid = characteristic.uuid.toString().toUpperCase();
            if (characteristicUuid.contains(CHARACTERISTIC_UUID)) {
              debugPrint('Found target characteristic: $characteristicUuid');
              _vowelCharacteristic = characteristic;
              foundTargetCharacteristic = true;

              // Enable notifications for the target characteristic
              await _setupNotifications();
            }
          }
        }
      }

      // Now monitor all services and characteristics
      await _monitorAllServices(services);

    } catch (e) {
      debugPrint('Error discovering services: $e');
    }
  }

  // Monitor all services and characteristics
  Future<void> _monitorAllServices(List<BluetoothService> services) async {
    // List to track readable characteristics that don't support notifications
    List<Map<String, dynamic>> readableCharacteristics = [];

    for (BluetoothService service in services) {
      String serviceUuid = service.uuid.toString().toUpperCase();

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        String characteristicUuid = characteristic.uuid.toString().toUpperCase();

        // Skip the target characteristic as it's already being monitored
        if (_vowelCharacteristic != null && 
            characteristicUuid == _vowelCharacteristic!.uuid.toString().toUpperCase()) {
          continue;
        }

        // Store the characteristic for reference with a key that includes both service and characteristic UUIDs
        String key = "$serviceUuid|$characteristicUuid";
        _monitoredCharacteristics[key] = characteristic;

        // Set up notifications if the characteristic supports it
        if (characteristic.properties.notify || characteristic.properties.indicate) {
          try {
            await characteristic.setNotifyValue(true);

            // Listen for notifications
            StreamSubscription subscription = characteristic.value.listen((value) {
              if (value.isNotEmpty) {
                // Try to convert to string for logging
                String dataString;
                try {
                  dataString = String.fromCharCodes(value);
                } catch (e) {
                  dataString = "Binary data: ${value.toString()}";
                }

                debugPrint('Received data from $serviceUuid/$characteristicUuid: $dataString');

                // Broadcast the data
                _bleDataController.add({
                  'serviceUuid': serviceUuid,
                  'characteristicUuid': characteristicUuid,
                  'data': value,
                  'dataString': dataString,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                });

                // If this is a vowel notification, also process it through the existing channel
                if (dataString.startsWith('VOGAL:')) {
                  String vowel = dataString.substring(6).trim();
                  _vowelNotificationController.add(vowel);
                }
              }
            });

            _serviceSubscriptions.add(subscription);
            debugPrint('Set up notifications for $serviceUuid/$characteristicUuid');
          } catch (e) {
            debugPrint('Error setting up notifications for $characteristicUuid: $e');
          }
        } else {
          debugPrint('Characteristic $characteristicUuid does not support notifications');

          // For characteristics that don't support notifications, try to read them periodically
          if (characteristic.properties.read) {
            // Add to the list of readable characteristics
            readableCharacteristics.add({
              'characteristic': characteristic,
              'serviceUuid': serviceUuid,
              'characteristicUuid': characteristicUuid,
            });

            // Read the initial value
            try {
              List<int> value = await characteristic.read();
              String dataString;
              try {
                dataString = String.fromCharCodes(value);
              } catch (e) {
                dataString = "Binary data: ${value.toString()}";
              }

              debugPrint('Read data from $serviceUuid/$characteristicUuid: $dataString');

              // Broadcast the data
              _bleDataController.add({
                'serviceUuid': serviceUuid,
                'characteristicUuid': characteristicUuid,
                'data': value,
                'dataString': dataString,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
              });
            } catch (e) {
              debugPrint('Error reading characteristic $characteristicUuid: $e');
            }
          }
        }
      }
    }

    // Set up periodic reading for readable characteristics
    if (readableCharacteristics.isNotEmpty) {
      // Cancel any existing timer
      _periodicReadTimer?.cancel();

      // Create a new timer that reads all readable characteristics every 2 seconds
      _periodicReadTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        // Check if we're still connected
        if (_connectedDevice == null) {
          timer.cancel();
          _periodicReadTimer = null;
          return;
        }

        // Read all readable characteristics
        for (var item in readableCharacteristics) {
          final characteristic = item['characteristic'] as BluetoothCharacteristic;
          final serviceUuid = item['serviceUuid'] as String;
          final characteristicUuid = item['characteristicUuid'] as String;

          try {
            List<int> value = await characteristic.read();
            if (value.isNotEmpty) {
              // Try to convert to string for logging
              String dataString;
              try {
                dataString = String.fromCharCodes(value);
              } catch (e) {
                dataString = "Binary data: ${value.toString()}";
              }

              debugPrint('Periodic read from $serviceUuid/$characteristicUuid: $dataString');

              // Broadcast the data
              _bleDataController.add({
                'serviceUuid': serviceUuid,
                'characteristicUuid': characteristicUuid,
                'data': value,
                'dataString': dataString,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'isPeriodicRead': true,
              });
            }
          } catch (e) {
            debugPrint('Error reading characteristic $characteristicUuid: $e');
          }
        }
      });

      debugPrint('Started periodic reading of ${readableCharacteristics.length} readable characteristics');
    }
  }

  // Setup notifications for the vowel characteristic
  Future<void> _setupNotifications() async {
    if (_vowelCharacteristic == null) return;

    try {
      // Enable notifications
      await _vowelCharacteristic!.setNotifyValue(true);

      // Listen for notifications
      _characteristicSubscription = _vowelCharacteristic!.value.listen((value) {
        if (value.isNotEmpty) {
          // Convert the received bytes to a string
          String data = String.fromCharCodes(value);
          debugPrint('Received notification: $data');

          // Parse the vowel from the notification
          if (data.startsWith('VOGAL:')) {
            String vowel = data.substring(6).trim();
            _vowelNotificationController.add(vowel);
          }
        }
      });

      debugPrint('Notifications set up successfully');
    } catch (e) {
      debugPrint('Error setting up notifications: $e');
    }
  }

  // Disconnect from the current device
  Future<void> disconnect() async {
    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.disconnect();
      } catch (e) {
        debugPrint('Error disconnecting: $e');
      }
    }
    _cleanupConnection();
  }

  // Clean up connection resources
  void _cleanupConnection() {
    _connectionSubscription?.cancel();
    _characteristicSubscription?.cancel();

    // Cancel all service subscriptions
    for (var subscription in _serviceSubscriptions) {
      subscription.cancel();
    }
    _serviceSubscriptions.clear();

    // Cancel periodic read timer
    _periodicReadTimer?.cancel();
    _periodicReadTimer = null;

    _connectedDevice = null;
    _vowelCharacteristic = null;
    _monitoredCharacteristics.clear();
    _connectionStateController.add(false);

    debugPrint('Connection resources cleaned up');
  }

  // Dispose of resources
  void dispose() {
    _connectionSubscription?.cancel();
    _characteristicSubscription?.cancel();

    // Cancel all service subscriptions
    for (var subscription in _serviceSubscriptions) {
      subscription.cancel();
    }
    _serviceSubscriptions.clear();

    // Cancel periodic read timer
    _periodicReadTimer?.cancel();
    _periodicReadTimer = null;

    _deviceStateController.close();
    _vowelNotificationController.close();
    _scanResultsController.close();
    _connectionStateController.close();
    _bleDataController.close();

    debugPrint('BLE service disposed');
  }
}
