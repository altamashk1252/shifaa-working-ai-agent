import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeasuresPage extends StatefulWidget {
  const MeasuresPage({super.key});

  @override
  State<MeasuresPage> createState() => _MeasuresPageState();
}

class _MeasuresPageState extends State<MeasuresPage> {
  String _languageCode = 'en'; // Default language is English

  static const Map<String, Map<String, String>> labels = {
    'en': {
      'measures': 'Measures',
      'measure1': 'Take prescribed medication daily.',
      'measure2': 'Attend follow-up appointment next week.',
      'measure3': 'Monitor blood pressure twice a day.',
      'measure4': 'Avoid salty foods.',
    },
    'ar': {
      'measures': 'القياسات',
      'measure1': 'تناول الدواء الموصوف يوميًا.',
      'measure2': 'حضور موعد المتابعة الأسبوع المقبل.',
      'measure3': 'مراقبة ضغط الدم مرتين في اليوم.',
      'measure4': 'تجنب الأطعمة المالحة.',
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

    final measures = [
      labelsMap['measure1']!,
      labelsMap['measure2']!,
      labelsMap['measure3']!,
      labelsMap['measure4']!,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(labelsMap['measures']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: measures.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Icon(
                    Icons.check,
                    color: Colors.green.shade700,
                  ),
                ),
                title: Text(
                  measures[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
