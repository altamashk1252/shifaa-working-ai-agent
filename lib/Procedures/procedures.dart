import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProceduresPage extends StatefulWidget {
  const ProceduresPage({super.key});

  @override
  State<ProceduresPage> createState() => _ProceduresPageState();
}

class _ProceduresPageState extends State<ProceduresPage> {
  String _languageCode = 'en';

  static const Map<String, Map<String, dynamic>> labels = {
    'en': {
      'title': 'Procedures',
      'previous': 'Previous Procedures',
      'planned': 'Planned Procedures',
      'prev1': 'Blood test - Completed on Aug 15, 2023',
      'prev2': 'Chest X-Ray - Completed on Sep 2, 2023',
      'plan1': 'MRI Scan - Scheduled for Oct 12, 2023',
      'plan2': 'Dental Surgery - Scheduled for Nov 5, 2023',
    },
    'ar': {
      'title': 'الإجراءات',
      'previous': 'الإجراءات السابقة',
      'planned': 'الإجراءات المخطط لها',
      'prev1': 'تحليل دم - أُنجز في 15 أغسطس 2023',
      'prev2': 'أشعة سينية للصدر - أُنجزت في 2 سبتمبر 2023',
      'plan1': 'فحص بالرنين المغناطيسي - مقرر في 12 أكتوبر 2023',
      'plan2': 'جراحة الأسنان - مقررة في 5 نوفمبر 2023',
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

    final previousProcedures = [
      labelsMap['prev1'] as String,
      labelsMap['prev2'] as String,
    ];

    final plannedProcedures = [
      labelsMap['plan1'] as String,
      labelsMap['plan2'] as String,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(labelsMap['title'] as String),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Previous Procedures
            Text(
              labelsMap['previous'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            ...previousProcedures.map((proc) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.deepPurple.shade700,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    proc,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )),

            const SizedBox(height: 24),

            // Planned Procedures
            Text(
              labelsMap['planned'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            ...plannedProcedures.map((proc) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange.shade100,
                    child: Icon(
                      Icons.schedule,
                      color: Colors.orange.shade700,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    proc,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
