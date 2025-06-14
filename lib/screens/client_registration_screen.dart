import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'client_profile_screen.dart';

class ClientRegistrationScreen extends StatefulWidget {
  @override
  _ClientRegistrationScreenState createState() => _ClientRegistrationScreenState();
}

class _ClientRegistrationScreenState extends State<ClientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final birthDateController = TextEditingController();
  final nationalIdController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final altMobileNumberController = TextEditingController();
  final addressController = TextEditingController();
  final passportNumberController = TextEditingController();
  final passportIssueDateController = TextEditingController();
  final passportExpiryDateController = TextEditingController();
  final passportIssuePlaceController = TextEditingController();
  final previousCompaniesController = TextEditingController();
  final delegateNameController = TextEditingController();
  String? experienceType;

  File? _pickedImage;

  final Color backgroundColor = Color(0xFF004D40);
  final Color textColor = Colors.white70;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _submitForm() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('من فضلك اختر صورة العميل')));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final nationalId = nationalIdController.text.trim();

    List<String> existingClients = prefs.getStringList('clients') ?? [];
    bool alreadyExists = existingClients.any((entry) => entry.contains('الرقم القومي:$nationalId'));

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم التسجيل مسبقًا بهذا الرقم القومي')),
      );
      return;
    }

    int contractNumber = prefs.getInt('last_contract_number') ?? 1000;
    contractNumber++;
    prefs.setInt('last_contract_number', contractNumber);

    DateTime? birthDate = DateTime.tryParse(birthDateController.text);
    int age = 0;
    if (birthDate != null) {
      final today = DateTime.now();
      age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
    }

    final clientMap = {
      'رقم العقد': contractNumber.toString(),
      'الاسم': nameController.text,
      'تاريخ الميلاد': birthDateController.text,
      'العمر': age.toString(),
      'الرقم القومي': nationalId,
      'رقم الموبايل': mobileNumberController.text,
      'رقم موبايل احتياطي': altMobileNumberController.text,
      'العنوان': addressController.text,
      'رقم الجواز': passportNumberController.text,
      'تاريخ الإصدار': passportIssueDateController.text,
      'تاريخ الانتهاء': passportExpiryDateController.text,
      'مكان الإصدار': passportIssuePlaceController.text,
      'الخبرات السابقة': experienceType ?? '',
      'الشركات السابقة': experienceType == 'قديم' ? previousCompaniesController.text : '',
      'اسم المندوب': delegateNameController.text,
      'تاريخ التسجيل': DateTime.now().toIso8601String(),
      'الحالة': 'جديد',
      'مسار الصورة': _pickedImage!.path,
    };

    final dataString = clientMap.entries.map((e) => '${e.key}:${e.value}').join('||');
    existingClients.add(dataString);
    await prefs.setStringList('clients', existingClients);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم التسجيل بنجاح')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ClientProfileScreen(nationalId: nationalId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('تسجيل عميل', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
                    child: _pickedImage == null
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey[300])
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildTextField('الاسم', nameController),
              buildDateField('تاريخ الميلاد', birthDateController),
              buildNationalIdField(),
              buildNumberField('رقم الموبايل', mobileNumberController),
              buildNumberField('رقم موبايل احتياطي', altMobileNumberController, isOptional: true),
              buildTextField('العنوان', addressController),
              buildNumberField('رقم الجواز', passportNumberController),
              buildDateField('تاريخ الإصدار', passportIssueDateController),
              buildDateField('تاريخ الانتهاء', passportExpiryDateController),
              buildNumberField('مكان الإصدار (رقم)', passportIssuePlaceController, maxLength: 3),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'هل لديك خبرة؟',
                  labelStyle: TextStyle(color: textColor),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
                value: experienceType,
                dropdownColor: backgroundColor,
                style: TextStyle(color: Colors.white),
                items: ['قديم', 'جديد']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => experienceType = value),
              ),
              if (experienceType == 'قديم')
                buildTextField('الشركات السابقة', previousCompaniesController),
              buildTextField('اسم المندوب', delegateNameController),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('تسجيل', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: buildInputDecoration(label),
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.text,
        validator: (value) => value == null || value.isEmpty ? 'مطلوب' : null,
      ),
    );
  }

  Widget buildNumberField(String label, TextEditingController controller, {bool isOptional = false, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: buildInputDecoration(label),
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
        validator: (value) {
          if (isOptional) return null;
          return value == null || value.isEmpty ? 'مطلوب' : null;
        },
      ),
    );
  }

  Widget buildNationalIdField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: nationalIdController,
        decoration: buildInputDecoration('الرقم القومي'),
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(14),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) return 'مطلوب';
          if (value.length != 14) return 'الرقم القومي يجب أن يكون 14 رقمًا';
          return null;
        },
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _pickDate(controller),
        decoration: buildInputDecoration(label),
        style: TextStyle(color: Colors.white),
        validator: (value) => value == null || value.isEmpty ? 'مطلوب' : null,
      ),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    );
  }
}
