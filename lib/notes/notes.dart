import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String _languageCode = 'en'; // Default language is English

  static const Map<String, Map<String, String>> labels = {
    'en': {
      'notes': 'Health Notes',
      'note1': 'Patient reported mild headache in the morning.',
      'note2': 'No allergic reactions to prescribed medication.',
      'note3': 'Improved sleep quality over the past week.',
      'note4': 'Patient follows a low-salt diet consistently.',
    },
    'ar': {
      'notes': 'ملاحظات صحية',
      'note1': 'أبلغ المريض عن صداع خفيف في الصباح.',
      'note2': 'لا توجد ردود فعل تحسسية تجاه الدواء الموصوف.',
      'note3': 'تحسنت جودة النوم خلال الأسبوع الماضي.',
      'note4': 'المريض يتبع نظامًا غذائيًا منخفض الملح باستمرار.',
    },
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelsMap = labels[_languageCode]!;

    final notes = [
      labelsMap['note1']!,
      labelsMap['note2']!,
      labelsMap['note3']!,
      labelsMap['note4']!,
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          labelsMap['notes']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note Icon
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.teal.shade50,
                      child: Icon(
                        Icons.note_alt_outlined,
                        color: Colors.teal.shade700,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Note Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Note Number Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Note ${index + 1}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Note Text
                          Text(
                            notes[index],
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
