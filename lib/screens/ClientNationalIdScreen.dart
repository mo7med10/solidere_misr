import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'client_profile_screen.dart'; // تأكد إن المسار صحيح حسب مشروعك

class ClientNationalIdScreen extends StatefulWidget {
  @override
  _ClientNationalIdScreenState createState() => _ClientNationalIdScreenState();
}

class _ClientNationalIdScreenState extends State<ClientNationalIdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nationalIdController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<bool> _checkClientExists(String nationalId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> clients = prefs.getStringList('clients') ?? [];
    return clients.any((entry) => entry.contains('الرقم القومي:$nationalId'));
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      bool exists = await _checkClientExists(_nationalIdController.text.trim());

      setState(() {
        _isLoading = false;
      });

      if (exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ClientProfileScreen(nationalId: _nationalIdController.text.trim()),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'لم يتم العثور على بيانات للعميل بهذا الرقم القومي';
        });
      }
    }
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دخول العميل'),
        backgroundColor: Color(0xFF004D40),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nationalIdController,
                decoration: InputDecoration(
                  labelText: 'أدخل الرقم القومي',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الرقم القومي';
                  }
                  if (value.length != 14) {
                    return 'الرقم القومي يجب أن يكون مكون من 14 رقمًا';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'الرقم القومي يجب أن يحتوي أرقام فقط';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'دخول',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
