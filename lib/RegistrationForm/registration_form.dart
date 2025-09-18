import 'package:flutter/material.dart';
import 'package:newone/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newone/main.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String _selectedSex = 'Male';
  String _selectedCountry = 'United Arab Emirates';

  final List<String> _countries = [
    'United Arab Emirates',
    'India',
    'USA',
    'UK',
    'Canada',
    'Australia',
    'Saudi Arabia',
    'Germany',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _ageController.text = prefs.getString('age') ?? '';
    _addressLine1Controller.text = prefs.getString('addressLine1') ?? '';
    _addressLine2Controller.text = prefs.getString('addressLine2') ?? '';
    _cityController.text = prefs.getString('city') ?? '';
    _pincodeController.text = prefs.getString('pincode') ?? '';
    _mobileController.text = prefs.getString('mobile') ?? '';
    setState(() {
      _selectedSex = prefs.getString('sex') ?? 'Male';
      _selectedCountry = prefs.getString('country') ?? 'United Arab Emirates';
    });
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('name', _nameController.text);
      await prefs.setString('age', _ageController.text);
      await prefs.setString('sex', _selectedSex);
      await prefs.setString('addressLine1', _addressLine1Controller.text);
      await prefs.setString('addressLine2', _addressLine2Controller.text);
      await prefs.setString('city', _cityController.text);
      await prefs.setString('pincode', _pincodeController.text);
      await prefs.setString('country', _selectedCountry);
      await prefs.setString('mobile', _mobileController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserHome()),
      //  MaterialPageRoute(builder: (_) => const MyHomePage()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionHeader('Personal Info'),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration('Full Name'),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Age'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Enter your age';
                            final age = int.tryParse(value);
                            if (age == null || age <= 0) return 'Enter a valid age';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration('Mobile Number'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your mobile number';
                            } else if (value.length < 10) {
                              return 'Enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InputDecorator(
                          decoration: _inputDecoration('Sex'),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSex,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 'Male', child: Text('Male')),
                                DropdownMenuItem(value: 'Female', child: Text('Female')),
                                DropdownMenuItem(value: 'Other', child: Text('Other')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedSex = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionHeader('Address Info'),
                        TextFormField(
                          controller: _addressLine1Controller,
                          decoration: _inputDecoration('Address Line 1'),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Enter address line 1' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressLine2Controller,
                          decoration: _inputDecoration('Address Line 2 (Optional)'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cityController,
                          decoration: _inputDecoration('City'),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Enter city' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Pincode'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Enter pincode';
                            if (value.length < 4) return 'Enter valid pincode';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InputDecorator(
                          decoration: _inputDecoration('Country'),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountry,
                              isExpanded: true,
                              items: _countries
                                  .map((country) => DropdownMenuItem(
                                value: country,
                                child: Text(country),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedCountry = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
