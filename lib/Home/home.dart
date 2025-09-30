import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:newone/app.dart';
import 'package:newone/services/locationService.dart';
import 'package:newone/widgets/sos_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Allergies/allergies_page.dart';
import '../Immunizations/immunizations.dart';
import '../LabResults/lab_results.dart';
import '../Measures/measures.dart';
import '../Medications/medications.dart';
import '../Notifications/notificationscreen.dart';
import '../voice_assistant_screen.dart';

 const Map<String, Map<String, String>> SOSlabels = {
  'en': {
    //   'dashboard': 'Shifaa',
    'sos': 'SOS',
    'sosActivation': 'SOS Activation',
    'sosSending': 'Sending SOS in {seconds} seconds...\nTap cancel to abort.',
    'sosHelpOnWay': '🚨 Help is on the way',
    'sosHelpMessage': 'Help is on the way. Please stay put.',
    'sosCancel': 'Cancel',
    'sosConfirmCancel': 'Confirm Cancellation',
    'sosConfirmMessage': 'Are you sure you want to cancel the SOS call?',
    'sosYesCancel': 'Yes, Cancel SOS',
    'sosNo': 'No',
    'ok': 'OK',
    // ... your other labels
  },
  'ar': {
    //  'dashboard': 'شفاء',
    'sos': 'طوارئ',
    'sosActivation': 'تفعيل الطوارئ',
    'sosSending': 'إرسال الطوارئ خلال {seconds} ثوان...\nاضغط إلغاء للإيقاف.',
    'sosHelpOnWay': '🚨 المساعدة في الطريق',
    'sosHelpMessage': 'المساعدة في الطريق. يرجى البقاء في مكانك.',
    'sosCancel': 'إلغاء',
    'sosConfirmCancel': 'تأكيد الإلغاء',
    'sosConfirmMessage': 'هل أنت متأكد أنك تريد إلغاء نداء الطوارئ؟',
    'sosYesCancel': 'نعم، ألغِ الطوارئ',
    'sosNo': 'لا',
    'ok': 'حسناً',
    // ... your other labels
  }
};


 const Map<String, Map<String, String>> labels = {
  'en': {
    "search": "Search...",
    'dashboard1': 'Hi',
    'dashboard2': 'health solution',
    'sos': 'SOS',
    'details': 'Details',
    'appointments': 'Appointments',
    'payments': 'Payments',
    'notifications': 'Notifications',
    'shareRecords': 'Share Records',
    'labResults': 'Lab Results',
    'medications': 'Medications',
    'immunizations': 'Immunizations',
    'allergies': 'Allergies',
    'hospitalizations': 'Hospitalizations',
    'measures': 'Measures',
    'notes': 'Notes',
    'procedures': 'Procedures',
    'correspondence': 'Correspondence',
    'talkToMe': 'Talk to Me',
    'language': 'Language',

  },
  'ar': {
    "search": "بحث...",
    'dashboard1': 'أهلاً',
    'sos': 'طوارئ',
    'details': 'التفاصيل',
    'appointments': 'المواعيد',
    'payments': 'المدفوعات',
    'notifications': 'الإشعارات',
    'shareRecords': 'مشاركة السجلات',
    'labResults': 'نتائج المختبر',
    'medications': 'الأدوية',
    'immunizations': 'التحصينات',
    'allergies': 'الحساسية',
    'hospitalizations': 'الإقامة بالمستشفى',
    'measures': 'القياسات',
    'notes': 'الملاحظات',
    'procedures': 'الإجراءات',
    'correspondence': 'المراسلات',
    'talkToMe': 'تحدث إلي',
    'language': 'اللغة',
  }
};
class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  StreamSubscription<LocationData>? _locationSubscription;

  late MqttServerClient client;
  final String broker = '90faaba835de4202b744d0e0898e0c15.s1.eu.hivemq.cloud';
  final int port = 8883;
  final String username = 'altamash';
  final String password = 'Osmanabad@1';
  final String topic = 'Shifaa/location/${(1000 + DateTime.now().millisecondsSinceEpoch % 9000)}';
  Timer? _locationTimer;
  final Location _location = Location();
  ////////////////////////////////////////////
  String userName = '';
  String userMobile = '';
  String userImage = 'assets/images/user_avatar.png';
  String _languageCode = 'en';
  StreamSubscription? _subscription;
  bool _hasInternet = true;

  final List<String> images = [
    'assets/images/image2.jpg',
    'assets/images/image3.png',
    'assets/images/image2.jpg',
    'assets/images/image3.png',
    'assets/images/image2.jpg',
  ];/*
  void _startSendingLocationnew() async {
    _locationTimer?.cancel(); // cancel existing timer if any

    // Ensure location services are enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // Ensure permissions are granted
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Start sending location every 30 seconds
    _locationTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        LocationData userLocation = await _location.getLocation();
        final latitude = userLocation.latitude;
        final longitude = userLocation.longitude;

        if (latitude != null && longitude != null) {
          final message = '{"lat":$latitude,"lng":$longitude,"timestamp":"${DateTime.now().toIso8601String()}"}';
          publish(topic, message);
          print('Location sent: $message');
        }
      } catch (e) {
        print('Error getting location: $e');
      }
    });
  }*/


/*  void _startSendingLocation() async {
    // Cancel any existing subscription
    // Cancel any existing subscription first
    if (_locationSubscription != null) {
      await _locationSubscription!.cancel();
      _locationSubscription = null;
      print("Previous location subscription canceled");
    }
    // 1️⃣ Ensure location services are enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // 2️⃣ Request foreground location
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) return; // user denied
    }

    // 3️⃣ Request background location (Android 10+)
    if (Platform.isAndroid) {
      var bgStatus = await Permission.locationAlways.status;
      if (!bgStatus.isGranted) {
        bgStatus = await Permission.locationAlways.request();
        if (!bgStatus.isGranted) {
          print("Background location denied. Please allow 'Always allow' in settings.");
          return;
        }
      }
    }

    // 4️⃣ Enable background mode for the location plugin
    await _location.enableBackgroundMode(enable: true);
    // Set custom interval
    _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000, // 5 seconds
      distanceFilter: 5, // update even if not moved
    );

    // 5️⃣ Listen to location updates
    _locationSubscription = _location.onLocationChanged.listen((LocationData userLocation) {
      final latitude = userLocation.latitude;
      final longitude = userLocation.longitude;

      if (latitude != null && longitude != null) {
        final message =
            '{"lat":$latitude,"lng":$longitude,"timestamp":"${DateTime.now().toIso8601String()}"}';
        publish(topic, message);
        print('Location sent: $message');
      }
    });
  }*/



  void _stopSendingLocation() {
    _locationSubscription?.cancel();
    _locationSubscription = null;

    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    // connect to MQTT once
    LocationService().initMQTT();

   // connect();
 //   _listenToInternet();
  }

/*  Future<void> connect() async {
    client = MqttServerClient.withPort(broker, '', port);
    client.logging(on: true);
    client.secure = true; // SSL
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .authenticateAs(username, password)
        .keepAliveFor(20)
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMess;

    try {
      await client.connect();
      print("connected to mqtt server");
    } catch (e) {
      print('Exception: $e');
      disconnect();
    }

    *//*client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final message =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message: $message from topic: ${c[0].topic}');
      setState(() {
    //    receivedMessage = message;
      });
    });*//*

    subscribe(topic);
  }

  void onConnected() {
    print('Connected to MQTT broker');
  }

  void onDisconnected() {
    print('Disconnected from MQTT broker');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }

  void disconnect() {
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }*/


  @override
  void dispose() {
    _subscription?.cancel();
    _locationTimer?.cancel();

    super.dispose();
  }

  void _listenToInternet() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) async {
      final hasConnection = await InternetConnectionChecker.instance.hasConnection;
      if (mounted) {
        setState(() => _hasInternet = hasConnection);
        if (!hasConnection) {
          _showNoInternetSnackBar();
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      }
    });
  }

  void _showNoInternetSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("⚠️ No Internet Connection"),
        backgroundColor: Colors.red,
        duration: Duration(days: 1),
      ),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';
      userName = prefs.getString('name') ?? 'Guest User';
      userMobile = prefs.getString('mobile') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelsMap = labels[_languageCode]!;
    final isArabic = _languageCode == 'ar';

/*    final List<Map<String, dynamic>> gridItems = [
      {'label': labelsMap['notifications'], 'icon': Icons.notifications},
      {'label': labelsMap['labResults'], 'icon': Icons.biotech},
      {'label': labelsMap['medications'], 'icon': Icons.medication},
      {'label': labelsMap['allergies'], 'icon': Icons.warning},
      {'label': labelsMap['measures'], 'icon': Icons.monitor_heart},
      {'label': labelsMap['talkToMe'], 'icon': Icons.record_voice_over},
    ];*/

    final List<Map<String, dynamic>> gridItems = [
      {'label': labelsMap['notifications'], 'lottie': 'assets/animations/notifications.json'},
      {'label': labelsMap['labResults'], 'lottie': 'assets/animations/labresults.json'},
      {'label': labelsMap['medications'], 'lottie': 'assets/animations/medications.json'},
      {'label': labelsMap['allergies'], 'lottie': 'assets/animations/allergies.json'},
      {'label': labelsMap['measures'], 'lottie': 'assets/animations/measures.json'},
      {'label': labelsMap['talkToMe'], 'lottie': 'assets/animations/talktome.json'},
    ];

    final navigationMap = {
      labelsMap['allergies']: AllergiesPage(),
      labelsMap['labResults']: LabResultsPage(),
      labelsMap['notifications']: const NotificationScreen(),
      labelsMap['medications']: const MedicationsScreen(),
      labelsMap['immunizations']: const ImmunizationsScreen(),
      labelsMap['measures']: const MeasuresPage(),
      labelsMap['talkToMe']: const VoiceAssistantApp(),
    };

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: SosButton(
              /*        onSosDispatched: _startSendingLocation,
                      onSosCancelled: _stopSendingLocation,*/
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: labelsMap['search'] ?? "Search...",
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,

                      ),
                    ),
                  ),
                ),
                GridView.builder(
                  itemCount: gridItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = gridItems[index];
                    return _GridItem(
                      label: item['label'],
                      icon: item['lottie'],
                      onTap: () {
                      //  if (!_hasInternet) return;
                        final selectedScreen = navigationMap[item['label']];
                        if (selectedScreen != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => selectedScreen),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 260,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                    ),
                    items: images.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _GridItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge, // ensures ripple effect stays inside
      child: InkWell(
        onTap: onTap,
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          //    Icon(icon, size: 40, color: Colors.white),
              SizedBox(height:55,width: 55 ,child: Lottie.asset(icon)),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

