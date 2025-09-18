import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImmunizationsScreen extends StatefulWidget {
  const ImmunizationsScreen({super.key});

  @override
  _ImmunizationsScreenState createState() => _ImmunizationsScreenState();
}

class _ImmunizationsScreenState extends State<ImmunizationsScreen> {
  String _languageCode = 'en'; // Default language
  String _userName = '';
  String _userMobile = '';

  // Mock list of immunizations
  List<Map<String, String>> immunizations = [
    {'name': 'BCG', 'date': '2023-01-15', 'hospital': 'City Hospital'},
    {'name': 'Hepatitis B', 'date': '2023-02-10', 'hospital': 'Community Health Center'},
    {'name': 'Measles', 'date': '2023-05-20', 'hospital': 'General Hospital'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Load the selected language from shared preferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';
      _userName = prefs.getString('name') ?? 'Guest User';
      _userMobile = prefs.getString('mobile') ?? '';
    });
  }

  // Get text based on selected language
  String _getText(String key) {
    final labelsMap = {
      'en': {
        'immunizations': 'Immunizations',
        'immunization_name': 'Immunization Name',
        'date_taken': 'Date Taken',
        'hospital': 'Hospital Name',
        'no_immunizations': 'No immunizations available.',
      },
      'ar': {
        'immunizations': 'التطعيمات',
        'immunization_name': 'اسم التطعيم',
        'date_taken': 'تاريخ التطعيم',
        'hospital': 'اسم المستشفى',
        'no_immunizations': 'لا توجد تطعيمات.',
      },
    };

    return labelsMap[_languageCode]?[key] ?? key;
  }

  // Convert English numbers to Arabic numerals
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

  // Format date to display in Arabic format if needed
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
        title: Text(_getText('immunizations')),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: immunizations.isNotEmpty
            ? ListView.builder(
          itemCount: immunizations.length,
          itemBuilder: (context, index) {
            final immunization = immunizations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Immunization Name
                    Row(
                      children: [
                        const Icon(Icons.vaccines, color: Colors.teal, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            immunization['name']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 1.2),

                    // Date Taken
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          '${_getText('date_taken')}: ${_formatDate(immunization['date']!)}',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Hospital Name
                    Row(
                      children: [
                        const Icon(Icons.local_hospital, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${_getText('hospital')}: ${immunization['hospital']}',
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
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
          child: Text(
            _getText('no_immunizations'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
