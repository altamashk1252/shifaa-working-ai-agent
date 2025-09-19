import 'package:flutter/material.dart';
import 'package:newone/Immunizations/immunizations.dart';
import 'package:newone/Payment/payments.dart';
import 'package:newone/Procedures/procedures.dart';
import 'package:newone/RegistrationForm/registration_form.dart';
import 'package:newone/main.dart';
import 'package:newone/notes/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerwidget extends StatefulWidget {
  final String currentScreen;
  const Drawerwidget({
    super.key,
    required  this.currentScreen

  });

  @override
  State<Drawerwidget> createState() => _DrawerwidgetState();
}

class _DrawerwidgetState extends State<Drawerwidget> {
  String _languageCode = "en";
  late String userName;
  late String userMobile;
  late String userImage;

  static const Map<String, Map<String, String>> labels = {
    'en': {
      'home':'Home',
      'payments': 'Payments',
      'immunizations': 'Immunizations',
      'notes': 'Notes',
      'procedures': 'Procedures',
      'logout': 'Logout',
    },
    'ar': {
      'home':'الصفحة الرئيسية',
      'payments': 'المدفوعات',
      'immunizations': 'التحصينات',
      'notes': 'الملاحظات',
      'procedures': 'الإجراءات',
      'logout': 'تسجيل الخروج',
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
      userName = prefs.getString('name') ?? 'Guest User';
      userMobile = prefs.getString('mobile') ?? '';
      userImage = prefs.getString('userimage')??'assets/images/user_avatar.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelsMap = labels[_languageCode]!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 290,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: userImage.isNotEmpty
                          ? AssetImage(userImage)
                          : const AssetImage('assets/images/user_avatar.jpg'),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Row with Name/Mobile on left and Logo on right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userMobile,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      // Logo on the right
                      Image.asset(
                        'assets/images/dmuh.png', // <-- Replace with your logo path
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ),
          // Home
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blueAccent),
            title: Text(labelsMap['home']!),
            onTap: () {
              Navigator.pop(context);
              if (widget.currentScreen!='home'){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              }
            },
          ),


          // Payments
          ListTile(
            leading: const Icon(Icons.payment, color: Colors.blue),
            title: Text(labelsMap['payments']!),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentDetailsScreen()));
              // TODO: Navigate to Payments screen
            },
          ),

          // Immunizations
          ListTile(
            leading: const Icon(Icons.vaccines, color: Colors.green),
            title: Text(labelsMap['immunizations']!),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ImmunizationsScreen()));

              // TODO: Navigate to Immunizations screen
            },
          ),

          // Notes
          ListTile(
            leading: const Icon(Icons.note, color: Colors.orange),
            title: Text(labelsMap['notes']!),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NotesPage()));

              // TODO: Navigate to Notes screen
            },
          ),

          // Procedures
          ListTile(
            leading: const Icon(Icons.description, color: Colors.purple),
            title: Text(labelsMap['procedures']!),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProceduresPage()));

              // TODO: Navigate to Procedures screen
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(labelsMap['logout']!),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // clear user data if needed
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationForm()));

              // TODO: Navigate to login screen
            },
          ),
        ],
      ),
    );
  }
}
