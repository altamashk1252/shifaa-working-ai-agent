import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:newone/app.dart';
import 'package:newone/widgets/sos_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Allergies/allergies_page.dart';
import '../Immunizations/immunizations.dart';
import '../LabResults/lab_results.dart';
import '../Measures/measures.dart';
import '../Medications/medications.dart';
import '../Notifications/notificationscreen.dart';
import '../voice_assistant_screen.dart';

const Map<String, Map<String, String>> SOSlabels = {
  // ... (same as before)
};

const Map<String, Map<String, String>> labels = {
  // ... (same as before)
};

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
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
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _listenToInternet();
  }

  @override
  void dispose() {
    _subscription?.cancel();
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

    final List<Map<String, dynamic>> gridItems = [
      {'label': labelsMap['notifications'], 'icon': Icons.notifications},
      {'label': labelsMap['labResults'], 'icon': Icons.biotech},
      {'label': labelsMap['medications'], 'icon': Icons.medication},
      {'label': labelsMap['allergies'], 'icon': Icons.warning},
      {'label': labelsMap['measures'], 'icon': Icons.monitor_heart},
      {'label': labelsMap['talkToMe'], 'icon': Icons.record_voice_over},
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
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: SosButton(),
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = gridItems[index];
                    return _GridItem(
                      label: item['label'],
                      icon: item['icon'],
                      onTap: () {
                        if (!_hasInternet) return;
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
                      height: 230,
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
  final IconData icon;
  final VoidCallback onTap;

  const _GridItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade400,
              Colors.purple.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
