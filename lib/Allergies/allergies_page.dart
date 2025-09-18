import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllergiesPage extends StatefulWidget {
  @override
  _AllergiesPageState createState() => _AllergiesPageState();
}

class _AllergiesPageState extends State<AllergiesPage> {
  String _languageCode = 'en'; // Default language

  // Sample data for allergies
  final List<Map<String, String>> allergies = [
    {
      'name': 'Peanuts',
      'severity': 'High',
      'description':
      'Peanuts are highly allergenic and can cause severe reactions in some individuals.'
    },
    {
      'name': 'Dust Mites',
      'severity': 'Medium',
      'description':
      'Dust mites are a common cause of allergies, leading to sneezing, coughing, and asthma.'
    },
    {
      'name': 'Pollen',
      'severity': 'Low',
      'description':
      'Pollen allergy, also known as hay fever, is common during the spring and summer months.'
    },
    {
      'name': 'Shellfish',
      'severity': 'High',
      'description':
      'Shellfish allergies are common and can result in severe reactions, including anaphylaxis.'
    },
    {
      'name': 'Milk',
      'severity': 'Medium',
      'description':
      'Milk allergies are commonly seen in children and can cause rashes, stomach upset, and anaphylaxis.'
    },
  ];

  static const Map<String, Map<String, String>> labels = {
    'en': {
      'title': 'Known Allergies',
      'severity': 'Severity',
      'description': 'Description',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
    },
    'ar': {
      'title': 'الحساسية المعروفة',
      'severity': 'شدة',
      'description': 'وصف',
      'high': 'عالي',
      'medium': 'متوسط',
      'low': 'منخفض',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Function to load language from SharedPreferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';
    });
  }

  // Function to get the label for the selected language
  String _getLabel(String key) {
    return labels[_languageCode]?[key] ?? labels['en']![key]!;
  }

  // Function to get the color based on severity
  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'High':
        return Colors.red.shade200;
      case 'Medium':
        return Colors.yellow.shade200;
      case 'Low':
        return Colors.green.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  // Function to get appropriate icon for each allergy
  IconData _getIconForAllergy(String allergyName) {
    switch (allergyName.toLowerCase()) {
      case 'peanuts':
        return Icons.restaurant; // Food-related
      case 'dust mites':
        return Icons.bed; // Found in beds/mattresses
      case 'pollen':
        return Icons.local_florist; // Flowers/plants
      case 'shellfish':
        return Icons.set_meal; // Seafood
      case 'milk':
        return Icons.local_drink; // Dairy/milk
      default:
        return Icons.warning; // Generic fallback
    }
  }

  // Function to show detailed information about the allergy
  void _showAllergyDetails(BuildContext context, Map<String, String> allergy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(allergy['name'] ?? 'Unknown Allergy'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${_getLabel('severity')}: ${allergy['severity']}'),
              const SizedBox(height: 10),
              Text('${_getLabel('description')}: ${allergy['description']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getLabel('title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: allergies.length,
          itemBuilder: (context, index) {
            final allergy = allergies[index];
            final name = allergy['name'] ?? 'Unknown';
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: _getSeverityColor(allergy['severity'] ?? 'Low'),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(
                    _getIconForAllergy(name),
                    color: Colors.black87,
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle:
                Text('${_getLabel('severity')}: ${allergy['severity']}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                onTap: () {
                  _showAllergyDetails(context, allergy);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
