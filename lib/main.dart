import 'dart:async';
import 'package:flutter/material.dart';
import 'package:newone/Appointments/doctor_list_page.dart';
import 'package:newone/Home/home.dart';
import 'package:newone/Profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RegistrationForm/registration_form.dart';
import 'package:newone/controllers/app_ctrl.dart' as ctrl;
import 'package:newone/widgets/button.dart' as buttons;
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ctrl.AppCtrl(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _hasUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('name') &&
        prefs.containsKey('age') &&
        prefs.containsKey('sex') &&
        prefs.containsKey('addressLine1');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shifaa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: FutureBuilder<bool>(
        future: _hasUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.blue)),
            );
          }
          return snapshot.data ?? false
              ? const MyHomePage()
              : const RegistrationForm();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _languageCode = 'en';
  String _userName = '';
  String _userMobile = '';

  final List<Widget> _pages = const [
    UserHome(),
    DoctorListPage(),
    Profile(),
  ];

  static const Map<String, Map<String, String>> labels = {
    'en': {
      'home': 'Home',
      'appointments': 'Appointments',
      'profile': 'Profile',
    },
    'ar': {
      'home': 'الرئيسية',
      'appointments': 'المواعيد',
      'profile': 'الملف الشخصي',
    }
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';
      _userName = prefs.getString('name') ?? 'Guest User';
      _userMobile = prefs.getString('mobile') ?? '';
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getLabel(String key) {
    return labels[_languageCode]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
       // selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: getLabel('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: getLabel('appointments'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: getLabel('profile'),
          ),
        ],
      ),
    );
  }
}
