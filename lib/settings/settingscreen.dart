import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // Make sure MyHomePage is imported

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _languageCode = 'en';

  static const Map<String, Map<String, String>> labelsMap = {
    'en': {
      'settings': 'Settings',
      'account': 'Account Details',
      'language': 'Language',
      'about': 'About Us',
      'terms': 'Terms and Conditions',
      'english': 'English',
      'arabic': 'العربية',
    },
    'ar': {
      'settings': 'الإعدادات',
      'account': 'تفاصيل الحساب',
      'language': 'اللغة',
      'about': 'معلومات عنا',
      'terms': 'الشروط والأحكام',
      'english': 'English',
      'arabic': 'العربية',
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
    });
  }

  Future<void> _changeLanguage(String code) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Language Change"),
        content: const Text(
            "Do you want to apply the new language? The screen will reload."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', code);

      // Update the state
      setState(() {
        _languageCode = code;
      });

      // Reload the home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = labelsMap[_languageCode]!;
    final isArabic = _languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(labels['settings']!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading:
                  const Icon(Icons.account_circle, color: Colors.teal, size: 30),
                  title: Text(labels['account']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Navigate to account details
                  },
                ),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  leading: const Icon(Icons.language, color: Colors.orange, size: 30),
                  title: Text(labels['language']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    RadioListTile<String>(
                      title: Text(labels['english']!),
                      value: 'en',
                      groupValue: _languageCode,
                      onChanged: (value) => _changeLanguage('en'),
                    ),
                    RadioListTile<String>(
                      title: Text(labels['arabic']!),
                      value: 'ar',
                      groupValue: _languageCode,
                      onChanged: (value) => _changeLanguage('ar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: const Icon(Icons.info, color: Colors.blue, size: 30),
                  title: Text(labels['about']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Navigate to About Us page
                  },
                ),
              ),
              const SizedBox(height: 12),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading:
                  const Icon(Icons.description, color: Colors.purple, size: 30),
                  title: Text(labels['terms']!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    // Navigate to Terms & Conditions page
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
