import 'package:flutter/material.dart';
import 'package:newone/widgets/drawerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../listeners/language_service.dart'; // Your language notifier

class DoctorDetailPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  int selectedDateIndex = 0;
  int selectedTimeIndex = -1;

  final List<String> dates = ["Mon 21", "Tue 22", "Wed 23", "Thu 24", "Fri 25", "Sat 26"];
  final List<String> times = ["09:00 AM", "10:00 AM", "11:00 AM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "07:00 PM"];
  String userName = '';
  String userMobile = '';
  late String _languageCode;

  // Labels map
  static const Map<String, Map<String, String>> labels = {
    'en': {
      'doctorDetail': 'Doctor Detail',
      'about': 'About',
      'bookAppointment': 'Book Appointment',
      'appointmentBooked': 'Appointment booked on {date} at {time}',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
    },
    'ar': {
      'doctorDetail': 'تفاصيل الطبيب',
      'about': 'حول',
      'bookAppointment': 'حجز موعد',
      'appointmentBooked': 'تم حجز موعد في {date} الساعة {time}',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',

    }
  };

  @override
  void initState() {
    super.initState();

    // Initialize language
    _languageCode = LanguageService.languageNotifier.value;

    // Listen for language changes
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
      userName = prefs.getString('name') ?? 'Guest';
      userMobile = prefs.getString('mobile') ?? '';
     // userImage = prefs.getString('avatar') ?? 'assets/images/user_avatar.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final isArabic = _languageCode == 'ar';
    final labelsMap = labels[_languageCode]!;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(labelsMap['doctorDetail']!),
          centerTitle: true,
        ),
        drawer: Drawerwidget(currentScreen: 'doctordetails',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      doctor['image'],
                      width: 125,
                      height: 125,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          doctor['specialty'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.green, size: 16),
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
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              doctor['distance'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // About Section
              Text(
                labelsMap['about']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                doctor['bio'],
                style: TextStyle(color: Colors.grey[700]),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(height: 5),

              // Horizontal Dates
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final parts = dates[index].split(' '); // ["Mon", "21"]
                    final day = parts[0];
                    final date = parts[1];
                    final isSelected = selectedDateIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDateIndex = index;
                        });
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Column(

                          children: [
                              Text(
                                day,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            Text(
                              date,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              // Time Slots
              Center(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(times.length, (index) {
                    final isSelected = selectedTimeIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTimeIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade400,
                          ),
                        ),
                        child: Text(
                          times[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30),

              // Book Appointment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedTimeIndex != -1
                      ? () {
                    final msg = labelsMap['appointmentBooked']!
                        .replaceAll('{date}', dates[selectedDateIndex])
                        .replaceAll('{time}', times[selectedTimeIndex]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    labelsMap['bookAppointment']!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
