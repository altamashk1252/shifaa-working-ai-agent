import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../listeners/language_service.dart';
import '../widgets/drawerWidget.dart';
import '../widgets/sos_button.dart';

class UpcomingAppointmentsPage extends StatefulWidget {
  const UpcomingAppointmentsPage({super.key});

  @override
  State<UpcomingAppointmentsPage> createState() => _UpcomingAppointmentsPageState();
}

class _UpcomingAppointmentsPageState extends State<UpcomingAppointmentsPage> {
  String _languageCode = 'en';
  String userName = 'Guest User';
  String userImage = 'assets/images/user_avatar.jpg';
  // Add this at the top of your state class
  int expandedIndex = -1; // -1 means no card is expanded


  // Dummy appointments list
  List<Map<String, dynamic>> appointments = [
    {
      'doctorName': 'Dr. Marcus Horizon',
      'specialty': 'Cardiologist',
      'date': 'Mon, Sep 15',
      'time': '09:00 AM',
      'image': 'assets/images/user_avatar.jpg',
      'status': 'Confirmed'
    },
    {
      'doctorName': 'Dr. Maria Elena',
      'specialty': 'Psychologist',
      'date': 'Tue, Sep 16',
      'time': '11:00 AM',
      'image': 'assets/images/user_avatar.jpg',
      'status': 'Pending'
    },
    {
      'doctorName': 'Dr. Stefi Jessi',
      'specialty': 'Orthopedist',
      'date': 'Wed, Sep 17',
      'time': '02:00 PM',
      'image': 'assets/images/user_avatar.jpg',
      'status': 'Cancelled'
    },
  ];

  static const Map<String,dynamic> labelsMap = {
    'en': {
      'dashboard1': 'Hi',
      'title': 'Upcoming Appointments',
      'statusConfirmed': 'Confirmed',
      'statusPending': 'Pending',
      'statusCancelled': 'Cancelled',
    },
    'ar': {
      'dashboard1': 'أهلاً',
      'title': 'المواعيد القادمة',
      'statusConfirmed': 'تم التأكيد',
      'statusPending': 'قيد الانتظار',
      'statusCancelled': 'ملغاة',
    }
  };

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
      userImage = prefs.getString('userImage') ?? 'assets/images/user_avatar.jpg';
      _languageCode = prefs.getString('language') ?? 'en';
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'تم التأكيد':
        return Colors.green;
      case 'pending':
      case 'قيد الانتظار':
        return Colors.orange;
      case 'cancelled':
      case 'ملغاة':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _languageCode == 'ar';

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
          drawer: Drawerwidget(currentScreen: 'appointments',

          ),


        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: SosButton(),
              ),
              const SizedBox(height: 12),
              Text(
                labelsMap[_languageCode]!['title']!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                bool isExpandable = appointment['status'].toLowerCase() == 'confirmed' ||
                    appointment['status'].toLowerCase() == 'pending' ||
                    appointment['status'] == 'تم التأكيد' ||
                    appointment['status'] == 'قيد الانتظار';

                bool isExpanded = expandedIndex == index;

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isExpandable) {
                          setState(() {
                            // If tapping the already expanded card, collapse it
                            if (expandedIndex == index) {
                              expandedIndex = -1;
                            } else {
                              expandedIndex = index;
                            }
                          });
                        }
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              // --- Row with doctor info, status, date, time ---
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      appointment['image'],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appointment['doctorName'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          appointment['specialty'],
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(appointment['date']),
                                            const SizedBox(width: 12),
                                            const Icon(Icons.access_time,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(appointment['time']),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(appointment['status'])
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      labelsMap[_languageCode]![
                                      'status${appointment['status']}'] ??
                                          appointment['status'],
                                      style: TextStyle(
                                        color: _getStatusColor(appointment['status']),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // --- Expanded buttons ---
                              if (isExpanded)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Cancel Button
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade600,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          elevation: 3,
                                          shadowColor: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          _showConfirmationDialog(
                                            context,
                                            'Cancel Appointment',
                                            'Are you sure you want to cancel this appointment?',
                                            onConfirm: () {
                                              print('Appointment Cancelled');
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.cancel, size: 18),
                                        label: const Text(
                                          'Cancel',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Reschedule Button
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade600,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          elevation: 3,
                                          shadowColor: Colors.blueAccent,
                                        ),
                                        onPressed: () {
                                          _showConfirmationDialog(
                                            context,
                                            'Reschedule Appointment',
                                            'Do you want to reschedule this appointment?',
                                            onConfirm: () {
                                              print('Appointment Rescheduled');
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.schedule, size: 18),
                                        label: const Text(
                                          'Reschedule',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
            ],
          ),
        ),
      ),
    );
  }
  void _showConfirmationDialog(BuildContext context, String title, String content,
      {required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close dialog
              child: const Text('No', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onConfirm,
              child: const Text('Yes',style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }

}
