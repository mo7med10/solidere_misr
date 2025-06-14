import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditClientScreen extends StatefulWidget {
  final Map<String, String> client;
  final int index;

  EditClientScreen({required this.client, required this.index});

  @override
  _EditClientScreenState createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {};

  final List<String> excludedKeys = [
    'رقم العقد',
    'تاريخ التسجيل',
    'الحالة',
  ];

  @override
  void initState() {
    super.initState();
    widget.client.forEach((key, value) {
      controllers[key] = TextEditingController(text: value);
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedClients = prefs.getStringList('clients') ?? [];

    Map<String, String> updatedClient = {};
    controllers.forEach((key, controller) {
      updatedClient[key] = controller.text;
    });

    final dataString = updatedClient.entries.map((e) => '${e.key}:${e.value}').join('||');
    storedClients[widget.index] = dataString;
    await prefs.setStringList('clients', storedClients);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
    );

    Navigator.pop(context, true); // يرجع للإدارة مع إشارة للتحديث
  }

  @override
  Widget build(BuildContext context) {
    List<String> editableKeys = widget.client.keys
        .where((key) => !excludedKeys.contains(key))
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFF003366),
      appBar: AppBar(
        title: Text('تعديل بيانات العميل'),
        backgroundColor: Color(0xFF003366),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ...editableKeys.map((key) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: controllers[key],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: key,
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                    filled: true,
                    fillColor: Color(0xFF004080),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('حفظ التعديلات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
