import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HospitalizationHistoryScreen extends StatefulWidget {
  const HospitalizationHistoryScreen({super.key});

  @override
  _HospitalizationHistoryScreenState createState() =>
      _HospitalizationHistoryScreenState();
}

class _HospitalizationHistoryScreenState
    extends State<HospitalizationHistoryScreen> {
  String _languageCode = 'en';
  String _userName = '';
  String _userMobile = '';

  List<Map<String, String>> hospitalizations = [
    {
      'hospital': 'City Hospital',
      'admissionDate': '2023-01-01',
      'dischargeDate': '2023-01-07',
      'reason': 'Pneumonia'
    },
    {
      'hospital': 'General Hospital',
      'admissionDate': '2023-02-15',
      'dischargeDate': '2023-02-20',
      'reason': 'Fracture'
    },
    {
      'hospital': 'Community Health Center',
      'admissionDate': '2023-05-05',
      'dischargeDate': '2023-05-10',
      'reason': 'Surgery'
    },
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
        'hospitalizations': 'Hospitalization History',
        'hospital_name': 'Hospital Name',
        'admission_date': 'Admission Date',
        'discharge_date': 'Discharge Date',
        'reason': 'Reason for Admission',
        'no_hospitalizations': 'No hospitalization history available.',
      },
      'ar': {
        'hospitalizations': 'تاريخ الاستشفاء',
        'hospital_name': 'اسم المستشفى',
        'admission_date': 'تاريخ الدخول',
        'discharge_date': 'تاريخ الخروج',
        'reason': 'سبب الدخول',
        'no_hospitalizations': 'لا توجد سوابق استشفاء.',
      },
    };
    return labelsMap[_languageCode]?[key] ?? key;
  }

  String _convertToArabicNumbers(String input) {
    const arabicNumbers = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"];
    return input.split('').map((char) {
      if (int.tryParse(char) != null) {
        return arabicNumbers[int.parse(char)];
      } else {
        return char;
      }
    }).join('');
  }

  String _formatDate(String date) {
    if (_languageCode == 'ar') {
      final parts = date.split('-');
      return "${_convertToArabicNumbers(parts[2])}/${_convertToArabicNumbers(parts[1])}/${_convertToArabicNumbers(parts[0])}";
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_getText('hospitalizations')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: hospitalizations.isNotEmpty
            ? ListView.builder(
          itemCount: hospitalizations.length,
          itemBuilder: (context, index) {
            final h = hospitalizations[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hospital Name
                    Row(
                      children: [
                        const Icon(Icons.local_hospital,
                            color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            h['hospital']!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Admission Date
                    Row(
                      children: [
                        const Icon(Icons.login, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${_getText('admission_date')}: ${_formatDate(h['admissionDate']!)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Discharge Date
                    Row(
                      children: [
                        const Icon(Icons.logout, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${_getText('discharge_date')}: ${_formatDate(h['dischargeDate']!)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Reason
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${_getText('reason')}: ${h['reason']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _getText('no_hospitalizations'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
