import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';

class PassportSearchScreen extends StatefulWidget {
  @override
  _PassportSearchScreenState createState() => _PassportSearchScreenState();
}

class _PassportSearchScreenState extends State<PassportSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  Future<void> searchByName(String name) async {
    final ByteData data = await rootBundle.load('assets/data/2025.xlsx');
    final List<int> bytes = data.buffer.asUint8List();
    final Excel excel = Excel.decodeBytes(bytes);

    List<Map<String, dynamic>> foundResults = [];

    for (String sheetName in excel.tables.keys) {
      final Sheet sheet = excel.tables[sheetName]!;

      for (var row in sheet.rows.skip(1)) {
        final rowName = row.length > 1 ? row[1]?.value.toString().toLowerCase().trim() : null;

        if (rowName != null && rowName.contains(name.toLowerCase().trim())) {
          foundResults.add({
            'م': row.length > 0 ? row[0] : null,
            'الاسم': row.length > 1 ? row[1] : null,
            'تاريخ الميلاد': row.length > 2 ? row[2] : null,
            'تاريخ الانتهاء': row.length > 3 ? row[3] : null,
            'التليفون': row.length > 4 ? row[4] : null,
            'المندوب': row.length > 5 ? row[5] : null,
            'الملاحظات': row.length > 6 ? row[6] : null,
            'اسم الشيت': sheetName,
          });
        }
      }
    }

    setState(() {
      _results = foundResults;
    });

    if (_results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لم يتم العثور على الاسم')),
      );
    }
  }

  Widget _buildResult() {
    if (_results.isEmpty) {
      return SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return Card(
          color: Color(0xFF004080),
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: result.entries.map((entry) {
                final value = entry.value is Data ? entry.value?.value ?? '' : entry.value;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${entry.key}: $value',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('البحث عن جواز')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'ادخل الاسم',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => searchByName(_controller.text),
              child: Text('بحث'),
            ),
            SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: _buildResult())),
          ],
        ),
      ),
    );
  }
}
