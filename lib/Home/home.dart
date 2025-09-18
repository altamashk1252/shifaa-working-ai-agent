import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:newone/app.dart';
import 'package:newone/widgets/drawerWidget.dart';
import 'package:newone/widgets/sos_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Allergies/allergies_page.dart';
import '../Immunizations/immunizations.dart';
import '../LabResults/lab_results.dart';
import '../Measures/measures.dart';
import '../Medications/medications.dart';
import '../Notifications/notificationscreen.dart';
import '../voice_assistant_screen.dart';


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


  static const Map<String, Map<String, String>> SOSlabels = {
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


  static const Map<String, Map<String, String>> labels = {
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


  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';
      userName = prefs.getString('name') ?? 'Guest User';
      userMobile = prefs.getString('mobile') ?? '';
    });
  }


  List<String> images=[
    //'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.png',
    'assets/images/image2.jpg',
    'assets/images/image3.png',
    'assets/images/image2.jpg',

  ];
  @override
  Widget build(BuildContext context) {
    final labelsMap = labels[_languageCode]!;
    final soslabelMap = SOSlabels[_languageCode]!;
    final isArabic = _languageCode == 'ar';

    final List<Map<String, dynamic>> gridItems = [
   //   {'label': labelsMap['details'], 'icon': Icons.person},
     // {'label': labelsMap['appointments'], 'icon': Icons.calendar_today},
      //{'label': labelsMap['payments'], 'icon': Icons.payment},
      {'label': labelsMap['notifications'], 'icon': Icons.notifications},
      //{'label': labelsMap['shareRecords'], 'icon': Icons.share},
      {'label': labelsMap['labResults'], 'icon': Icons.biotech},
      {'label': labelsMap['medications'], 'icon': Icons.medication},
      //{'label': labelsMap['immunizations'], 'icon': Icons.vaccines},
      {'label': labelsMap['allergies'], 'icon': Icons.warning},
      //{'label': labelsMap['hospitalizations'], 'icon': Icons.local_hospital},
      {'label': labelsMap['measures'], 'icon': Icons.monitor_heart},
      //{'label': labelsMap['notes'], 'icon': Icons.note},
      //{'label': labelsMap['procedures'], 'icon': Icons.description},
      //{'label': labelsMap['correspondence'], 'icon': Icons.mail},
      {'label': labelsMap['talkToMe'], 'icon': Icons.record_voice_over}, // LAST ITEM
    ];

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child:
      //Scaffold(
        /*appBar: AppBar(
          title: Column(
            children: [
              // Image widget for your logo or image

              // Add some space between the image and the title
              Text(
                labelsMap['dashboard1']!+", "+userName, // Ensure that labelsMap is correctly initialized
                style: const TextStyle(

                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.medical_information_outlined,size: 40,), // Bell icon
              onPressed: () {
                // Handle bell icon press, e.g., show notifications
                print('Bell icon pressed!');
              },
            ),
          ],
        ),

        drawer: Drawerwidget(
currentScreen: 'home',


      ),
        */
     // body:
        Material(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(   // ✅ makes whole body scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: SosButton(),
                    ),
                  ),

                  // 🔍 Search bar
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

                  // 🟦 Grid items
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
                      return InkWell(
                        onTap: () {
                          final navigationMap = {
                           // labelsMap['details']: const RegistrationForm(),
                            labelsMap['allergies']: AllergiesPage(),
                            labelsMap['labResults']: LabResultsPage(),
                            //labelsMap['appointments']: DoctorListPage(),
                            //labelsMap['payments']: const PaymentDetailsScreen(),
                            labelsMap['notifications']: const NotificationScreen(),
                            labelsMap['medications']: const MedicationsScreen(),
                            labelsMap['immunizations']: const ImmunizationsScreen(),
                            //labelsMap['hospitalizations']:
                            //const HospitalizationHistoryScreen(),
                            labelsMap['measures']: const MeasuresPage(),
                            labelsMap['talkToMe']: const VoiceAssistantApp(),
                            //labelsMap['notes']: const NotesPage(),
                            //labelsMap['procedures']: const ProceduresPage(),
                          };
                          final selectedScreen = navigationMap[item['label']];
                          if (selectedScreen != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => selectedScreen),
                            );
                          }
                        },
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
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🖼 Banners BELOW grid
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


      //)
    );}
  }

