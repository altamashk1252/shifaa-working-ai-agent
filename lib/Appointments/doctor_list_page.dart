import 'package:flutter/material.dart';
import 'package:newone/Appointments/doctor_details_page.dart';
import 'package:newone/widgets/sos_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../listeners/language_service.dart';
import '../widgets/drawerWidget.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  String _languageCode = 'en';
  String userName = 'Guest User';
  String userMobile="";
  String userImage = 'assets/images/user_avatar.jpg';
  String query = "";

  // Labels for multi-language support
  static const Map<String, Map<String, String>> labelsMap = {
    'en': {
      'dashboard1': 'Hi',
      'title': 'Top Doctors',
      'searchHint': 'Search by name or specialty...',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
    },
    'ar': {
      'dashboard1': 'أهلاً',
      'title': 'أفضل الأطباء',
      'searchHint': 'ابحث بالاسم أو التخصص...',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
    }
  };

  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Marcus Horizon',
      'specialty': 'Cardiologist',
      'rating': 4.7,
      'distance': '800m away',
      'bio':
      'Dr. Marcus Horizon is a highly experienced cardiologist specializing in heart health and cardiovascular diseases.',
      'image': 'assets/images/user_avatar.jpg',
    },
    {
      'name': 'Dr. Maria Elena',
      'specialty': 'Psychologist',
      'rating': 4.7,
      'distance': '800m away',
      'bio':
      'Dr. Maria Elena is a compassionate psychologist helping patients with mental wellness and therapy.',
      'image': 'assets/images/user_avatar.jpg',
    },
    {
      'name': 'Dr. Stefi Jessi',
      'specialty': 'Orthopedist',
      'rating': 4.7,
      'distance': '800m away',
      'bio':
      'Dr. Stefi Jessi specializes in bone and joint treatments, ensuring mobility and recovery.',
      'image': 'assets/images/user_avatar.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();

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

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Guest User';
      userMobile = prefs.getString('mobile') ?? '';
      userImage = prefs.getString('userImage') ?? 'assets/images/user_avatar.jpg';
      _languageCode = prefs.getString('language') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _languageCode == 'ar';
    final filteredDoctors = doctors.where((doctor) {
      final nameMatch = doctor['name'].toLowerCase().contains(query.toLowerCase());
      final specialtyMatch =
      doctor['specialty'].toLowerCase().contains(query.toLowerCase());
      return nameMatch || specialtyMatch;
    }).toList();

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${labelsMap[_languageCode]!['dashboard1']}, $userName",
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
                print('Bell icon pressed!');
              },
            ),
          ],
        ),
        drawer: Drawerwidget(
currentScreen: 'doctorslist',

        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(width: double.infinity, child: SosButton()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: labelsMap[_languageCode]!['searchHint'],
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          doctor['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        doctor['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['specialty'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.green, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      doctor['rating'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                doctor['distance'],
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DoctorDetailPage(doctor: doctor),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
