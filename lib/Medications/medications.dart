import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  String _languageCode = 'en';
  String _userName = '';
  String _userMobile = '';

  List<Map<String, String>> medications = [
    {'name': 'Paracetamol', 'dosage': '500mg', 'time': 'morning, afternoon, night'},
    {'name': 'Ibuprofen', 'dosage': '200mg', 'time': 'afternoon, night'},
    {'name': 'Amoxicillin', 'dosage': '250mg', 'time': 'morning, evening'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';
      _userName = prefs.getString('name') ?? 'Guest User';
      _userMobile = prefs.getString('mobile') ?? '';
    });
  }

  String _getText(String key) {
    final labelsMap = {
      'en': {
        'medications': 'Medications',
        'dosage': 'Dosage',
        'time': 'Time to Take',
        'no_medications': 'No medications available.',
        'morning': 'Morning',
        'afternoon': 'Afternoon',
        'night': 'Night',
        'evening': 'Evening',
      },
      'ar': {
        'medications': 'الأدوية',
        'dosage': 'الجرعة',
        'time': 'وقت التناول',
        'no_medications': 'لا توجد أدوية.',
        'morning': 'الصباح',
        'afternoon': 'بعد الظهر',
        'night': 'الليل',
        'evening': 'المساء',
      },
    };
    return labelsMap[_languageCode]?[key] ?? key;
  }

  String _convertToArabicNumbers(String input) {
    const arabicNumbers = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"];
    return input.split('').map((char) {
      if (int.tryParse(char) != null) {
        return arabicNumbers[int.parse(char)];
      } else {
        return char;
      }
    }).join('');
  }

  String _translateTime(String timeString) {
    final timeMap = {
      'morning': _getText('morning'),
      'afternoon': _getText('afternoon'),
      'night': _getText('night'),
      'evening': _getText('evening'),
    };
    List<String> times = timeString.split(', ');
    List<String> translatedTimes = times.map((time) => timeMap[time] ?? time).toList();
    return translatedTimes.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getText('medications'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: medications.isNotEmpty
            ? ListView.builder(
          itemCount: medications.length,
          itemBuilder: (context, index) {
            final med = medications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.medical_services, color: Colors.teal.shade400, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              med['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.local_hospital, size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            '${_getText('dosage')}: ${_languageCode == 'ar' ? _convertToArabicNumbers(med['dosage']!) : med['dosage']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            '${_getText('time')}: ${_translateTime(med['time']!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
            : Center(
          child: Text(
            _getText('no_medications'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
