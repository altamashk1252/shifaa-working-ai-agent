import 'package:flutter/material.dart';
import 'package:newone/Hospitilizations/hospitilizations.dart';
import 'package:newone/LabResults/lab_results.dart';
import 'package:newone/RegistrationForm/registration_form.dart';
import 'package:newone/widgets/drawerWidget.dart';
import 'package:newone/widgets/sos_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Appointments/appointments.dart';
import '../listeners/language_service.dart';
import '../settings/settingscreen.dart'; // make sure you have this

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = '';
  String userMobile = '';
  String _languageCode = 'en';

  // Labels for Profile grid
  static const Map<String, Map<String, String>> profileLabels = {
    'en': {
      'dashboard1': 'Hi',
      "appointments": "My Appointments",
      "records": "My Records",
      "details": "Profile Details",
      "settings": "Settings",
      "help": "Help",
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
    },
    'ar': {
      'dashboard1': 'أهلاً',
      "appointments": "مواعيدي",
      "records": "سجلاتي",
      "details": "تفاصيل الملف الشخصي",
      'language': 'اللغة',
      "settings": "الإعدادات",
      "help": "مساعدة",
      'english': 'الإنجليزية',
      'arabic': 'العربية',
    }
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // Listen to language changes
    LanguageService.languageNotifier.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LanguageService.languageNotifier.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {
      _languageCode = LanguageService.languageNotifier.value;
    });
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Guest User';
      userMobile = prefs.getString('mobile') ?? '';

      _languageCode = prefs.getString('language') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelsMap = profileLabels[_languageCode]!;
    final isArabic = _languageCode == 'ar';

    final List<Map<String, dynamic>> gridItems = [
      {"label": profileLabels[_languageCode]!["appointments"], "icon": Icons.calendar_month},
      {"label": profileLabels[_languageCode]!["records"], "icon": Icons.file_copy},
      {"label": profileLabels[_languageCode]!["details"], "icon": Icons.person},
      {"label": profileLabels[_languageCode]!["settings"], "icon": Icons.settings},
      {"label": profileLabels[_languageCode]!["help"], "icon": Icons.help},
    ];

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child:
     /* Scaffold(
        appBar: AppBar(
          title: Text(
            "${profileLabels[_languageCode]!['dashboard1']}, $userName",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.medical_information_outlined,size: 40,), // Bell icon
              onPressed: () {
                // Handle bell icon press, e.g., show notifications
             //   print('Bell icon pressed!');
              },
            ),
          ],
        ),
        drawer: Drawerwidget(currentScreen: 'profile',

     ),
        body:
        */Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: SosButton(), // will also update automatically if you implement listener inside SosButton
              ),
              const SizedBox(height: 12), // padding above grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemCount: gridItems.length,
                  itemBuilder: (context, index) {
                    final item = gridItems[index];
                    return InkWell(
                      onTap: () {
                        if (item['label'] == profileLabels[_languageCode]!['settings']) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        }
                        if (item['label'] == profileLabels[_languageCode]!['appointments']) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const UpcomingAppointmentsPage()),
                          );
                        }
                        if (item['label'] == profileLabels[_languageCode]!['records']) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const HospitalizationHistoryScreen()),
                          );
                        }
                        if (item['label'] == profileLabels[_languageCode]!['details']) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const RegistrationForm()),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
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
                            Icon(item['icon'], size: 40, color: Colors.white),
                            const SizedBox(height: 10),
                            Text(
                              item['label'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
   //   ),
    );
  }
}
