import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_client_screen.dart';
import 'passport_search_screen.dart'; // ✅ استدعاء شاشة البحث

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<Map<String, String>> clients = [];

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  Future<void> loadClients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedClients = prefs.getStringList('clients') ?? [];

    setState(() {
      clients = storedClients.map((clientString) {
        Map<String, String> client = {};
        for (var field in clientString.split('||')) {
          var keyValue = field.split(':');
          if (keyValue.length == 2) {
            client[keyValue[0]] = keyValue[1];
          }
        }
        return client;
      }).toList();
    });
  }

  void deleteClient(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedClients = prefs.getStringList('clients') ?? [];
    storedClients.removeAt(index);
    await prefs.setStringList('clients', storedClients);
    loadClients();
  }

  void editClient(Map<String, String> client, int index) async {
    bool? updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditClientScreen(client: client, index: index),
      ),
    );
    if (updated == true) {
      loadClients();
    }
  }

  void openPassportSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PassportSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366),
      appBar: AppBar(
        title: Text('صفحة الإدارة'),
        backgroundColor: Color(0xFF003366),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'الإجمالي: ${clients.length}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: clients.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد بيانات مسجلة',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      final client = clients[index];
                      return Card(
                        color: Color(0xFF004080),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ExpansionTile(
                          iconColor: Colors.orange,
                          collapsedIconColor: Colors.white,
                          title: Text(
                            client['الاسم'] ?? 'بدون اسم',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          children: [
                            ...client.entries.map((entry) {
                              return ListTile(
                                title: Text(
                                  entry.key,
                                  style: TextStyle(color: Colors.orangeAccent),
                                ),
                                subtitle: Text(
                                  entry.value,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              );
                            }).toList(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton.icon(
                                  onPressed: () => editClient(client, index),
                                  icon: Icon(Icons.edit, color: Colors.green),
                                  label: Text(
                                    'تعديل',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => deleteClient(index),
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  label: Text(
                                    'حذف',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // 🔍 زر البحث عن جواز
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: openPassportSearch,
              icon: Icon(Icons.search),
              label: Text(
                'البحث عن جواز',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
