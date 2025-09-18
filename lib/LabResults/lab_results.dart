import 'package:flutter/material.dart';

class LabResultsPage extends StatelessWidget {
  // Sample data for lab results (can be fetched from an API or database)
  final List<Map<String, String>> labResults = [
    {'test': 'CBC', 'date': '2023-09-01'},
    {'test': 'Blood Sugar', 'date': '2023-08-15'},
    {'test': 'Liver Function Test', 'date': '2023-07-20'},
    {'test': 'Cholesterol Test', 'date': '2023-06-10'},
    {'test': 'Thyroid Function Test', 'date': '2023-05-25'},
  ];

  // Function to map test names to icons
  IconData _getIconForTest(String testName) {
    switch (testName.toLowerCase()) {
      case 'cbc':
        return Icons.bloodtype; // Blood test
      case 'blood sugar':
        return Icons.water_drop; // Sugar/Glucose
      case 'liver function test':
        return Icons.healing; // Organ/Health
      case 'cholesterol test':
        return Icons.favorite; // Heart health
      case 'thyroid function test':
        return Icons.bolt; // Metabolism/Energy
      default:
        return Icons.science; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lab Results",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: labResults.length,
          itemBuilder: (context, index) {
            final labResult = labResults[index];
            final testName = labResult['test'] ?? 'Unknown Test';
            final testIcon = _getIconForTest(testName);

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
                    testIcon,
                    color: Colors.deepPurple.shade400,
                    size: 28,
                  ),
                ),
                title: Text(
                  testName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Date: ${labResult['date']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey[600],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('More Info for $testName'),
                        content: const Text('Detailed lab result info will be here.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
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
