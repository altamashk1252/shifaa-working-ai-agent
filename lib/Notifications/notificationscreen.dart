import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _languageCode = 'en';
  String _userName = '';
  String _userMobile = '';

  // Sample notifications
  final List<NotificationItem> notifications = [
    NotificationItem(
      hospitalName: 'City Hospital',
      notificationDate: '2025-09-09',
      message: 'Your appointment has been confirmed for 2025-09-15.',
    ),
    NotificationItem(
      hospitalName: 'Green Valley Clinic',
      notificationDate: '2025-09-10',
      message: 'Your lab results are available for review.',
    ),
    NotificationItem(
      hospitalName: 'Sunny Care Hospital',
      notificationDate: '2025-09-12',
      message: 'You have a new vaccination reminder.',
    ),
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
        'notifications': 'Notifications',
        'hospital_name': 'Hospital Name',
        'notification_date': 'Date',
        'message': 'Message',
      },
      'ar': {
        'notifications': 'الإشعارات',
        'hospital_name': 'اسم المستشفى',
        'notification_date': 'تاريخ الإشعار',
        'message': 'الرسالة',
      },
    };

    return labelsMap[_languageCode]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getText('notifications'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.deepPurple.shade50,
                  child: Icon(
                    Icons.notifications_active,
                    color: Colors.deepPurple.shade400,
                    size: 28,
                  ),
                ),
                title: Text(
                  notification.hospitalName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getText('notification_date')}: ${notification.notificationDate}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_getText('message')}: ${notification.message}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(notification.hospitalName),
                      content: Text(notification.message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationItem {
  final String hospitalName;
  final String notificationDate;
  final String message;

  NotificationItem({
    required this.hospitalName,
    required this.notificationDate,
    required this.message,
  });
}
