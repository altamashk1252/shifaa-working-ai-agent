import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String _languageCode = 'en'; // Default language


  // List of payments (hospital, amount, date)
  final List<Payment> payments = [
    Payment(hospitalName: 'City Hospital', amount: '100.00', paymentDate: '2025-09-09'),
    Payment(hospitalName: 'Green Valley Clinic', amount: '150.00', paymentDate: '2025-09-10'),
    Payment(hospitalName: 'Sunny Care Hospital', amount: '200.00', paymentDate: '2025-09-12'),
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Load the selected language from shared preferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _languageCode = prefs.getString('language') ?? 'en';

    });
  }

  // Get text based on selected language
  String _getText(String key) {
    final labelsMap = {
      'en': {
        'payment_details': 'Payment Details',
        'hospital_name': 'Hospital Name',
        'amount': 'Amount',
        'payment_date': 'Payment Date',
      },
      'ar': {
        'payment_details': 'تفاصيل الدفع',
        'hospital_name': 'اسم المستشفى',
        'amount': 'المبلغ',
        'payment_date': 'تاريخ الدفع',
      },
    };
    return labelsMap[_languageCode]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _getText('payment_details'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final payment = payments[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hospital Name with icon
                    Row(
                      children: [
                        const Icon(Icons.local_hospital, color: Colors.blue, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            payment.hospitalName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Amount
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          '${_getText('amount')}: \$${payment.amount}',
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Payment Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          '${_getText('payment_date')}: ${payment.paymentDate}',
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
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

// Payment model class
class Payment {
  final String hospitalName;
  final String amount;
  final String paymentDate;

  Payment({
    required this.hospitalName,
    required this.amount,
    required this.paymentDate,
  });
}
