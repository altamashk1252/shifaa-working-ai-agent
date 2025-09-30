import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:location/location.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  Timer? _locationTimer;

  late MqttServerClient client;
  final String broker = '90faaba835de4202b744d0e0898e0c15.s1.eu.hivemq.cloud';
  final int port = 8883;
  final String username = 'altamash';
  final String password = 'Osmanabad@1';
  String topic = '';

  bool isConnected = false;

  /// Initialize MQTT client
  Future<void> initMQTT() async {
    client = MqttServerClient.withPort(broker, '', port);
    client.logging(on: true);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;

    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .authenticateAs(username, password)
        .keepAliveFor(20);

    client.connectionMessage = connMess;

    try {
      await client.connect();
      isConnected = true;
      print("✅ Connected to MQTT broker");
    } catch (e) {
      print("❌ MQTT connection error: $e");
      disconnect();
    }

    // Each device can have a unique topic
    topic = 'Shifaa/location/${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';
  }

  void onConnected() => print('MQTT connected');
  void onDisconnected() => print('MQTT disconnected');
  void disconnect() {
    client.disconnect();
    isConnected = false;
  }

  void publishLocation(double lat, double lng) {
    if (!isConnected) return;
    final message =
        '{"lat":$lat,"lng":$lng,"timestamp":"${DateTime.now().toIso8601String()}"}';
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    print('📍 Location sent: $message');
  }

  /// Start sending location updates
  Future<void> startLocationUpdates({int intervalSec = 5, double distanceFilter = 5}) async {
    // Cancel previous subscription
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    // 1️⃣ Ensure location services are enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        print("❌ Location service not enabled");
        return;
      }
    }

    // 2️⃣ Request foreground location
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        print("❌ Foreground location denied");
        return;
      }
    }

    // 3️⃣ Request background location (Android 10+)
    if (Platform.isAndroid) {
      var bgStatus = await Permission.locationAlways.status;
      if (!bgStatus.isGranted) {
        bgStatus = await Permission.locationAlways.request();
        if (!bgStatus.isGranted) {
          print("⚠️ Background location denied. Please allow 'Always allow' in settings.");
          return;
        }
      }
    }

    // 4️⃣ Enable background mode for the location plugin
    await _location.enableBackgroundMode(enable: true);

    // Configure interval + distance
    _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: intervalSec * 1000,
      distanceFilter: distanceFilter,
    );

    // Listen to location changes
    _locationSubscription = _location.onLocationChanged.listen((loc) {
      final lat = loc.latitude;
      final lng = loc.longitude;
      if (lat != null && lng != null) {
        publishLocation(lat, lng);
      }
    });

    print("✅ Location updates started");
  }

  /// Stop sending location
  Future<void> stopLocationUpdates() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    print("🛑 Location updates stopped");
  }
}
