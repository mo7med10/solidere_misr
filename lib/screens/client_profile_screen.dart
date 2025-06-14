import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfileScreen extends StatefulWidget {
  final String nationalId;

  const ClientProfileScreen({Key? key, required this.nationalId}) : super(key: key);

  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  Map<String, String>? clientData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  Future<void> _loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> clients = prefs.getStringList('clients') ?? [];

    String? clientEntry = clients.firstWhere(
      (entry) => entry.contains('الرقم القومي:${widget.nationalId}'),
      orElse: () => '',
    );

    if (clientEntry.isNotEmpty) {
      Map<String, String> dataMap = {};
      clientEntry.split('||').forEach((pair) {
        final splitPair = pair.split(':');
        if (splitPair.length >= 2) {
          final key = splitPair[0];
          final value = splitPair.sublist(1).join(':');
          dataMap[key] = value;
        }
      });

      setState(() {
        clientData = dataMap;
        isLoading = false;
      });
    } else {
      setState(() {
        clientData = null;
        isLoading = false;
      });
    }
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[900]),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('ملف العميل'),
        backgroundColor: Color(0xFF004D40),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : clientData == null
              ? Center(child: Text('لم يتم العثور على بيانات للعميل', style: TextStyle(fontSize: 18)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: clientData!['صورة'] != null && clientData!['صورة']!.isNotEmpty
                              ? NetworkImage(clientData!['صورة']!)
                              : null,
                          child: clientData!['صورة'] == null || clientData!['صورة']!.isEmpty
                              ? Icon(Icons.person, size: 60, color: Colors.white)
                              : null,
                        ),
                      ),
                      SizedBox(height: 20),

                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // تم حذف رقم العقد كما طلبت
                              _buildRow('الاسم', clientData!['الاسم']),
                              _buildRow('العمر', clientData!['العمر']),
                              _buildRow('الرقم القومي', clientData!['الرقم القومي']),
                              _buildRow('رقم الموبايل', clientData!['رقم الموبايل']),
                              _buildRow('رقم موبايل احتياطي', clientData!['رقم موبايل احتياطي']),
                              _buildRow('العنوان', clientData!['العنوان']),
                              _buildRow('رقم الجواز', clientData!['رقم الجواز']),
                              _buildRow('تاريخ الإصدار', clientData!['تاريخ الإصدار']),
                              _buildRow('تاريخ الانتهاء', clientData!['تاريخ الانتهاء']),
                              _buildRow('مكان الإصدار', clientData!['مكان الإصدار']),
                              _buildRow('الخبرات السابقة', clientData!['الخبرات السابقة']),
                              if (clientData!['الخبرات السابقة'] == 'قديم')
                                _buildRow('الشركات السابقة', clientData!['الشركات السابقة']),
                              _buildRow('اسم المندوب', clientData!['اسم المندوب']),
                              _buildRow('تاريخ التسجيل', clientData!['تاريخ التسجيل']),
                              _buildRow('الحالة', clientData!['الحالة']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
