import 'package:flutter/material.dart';
import 'ClientNationalIdScreen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004D40),
      appBar: AppBar(
        backgroundColor: Color(0xFF004D40),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Text(
              'تسجيل دخول',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onSelected: (value) {
              if (value == 'register') {
                Navigator.pushNamed(context, '/clientRegistration');
              } else if (value == 'clientLogin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ClientNationalIdScreen()),
                );
              } else if (value == 'adminLogin') {
                Navigator.pushNamed(context, '/adminLogin');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'register',
                child: Text('تسجيل أول مرة'),
              ),
              PopupMenuItem<String>(
                value: 'clientLogin',
                child: Text('دخول العملاء'),
              ),
              PopupMenuItem<String>(
                value: 'adminLogin',
                child: Text('دخول الإدارة'),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/images/شعار الشركه.png',
                width: 120,
                height: 120,
              ),
              SizedBox(height: 20),
              Text(
                'مرحباً بك في سوليدير مصر',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'نحن شركة مصرية لتوظيف العمالة المصرية للعمل في السعودية. نقدم لك أفضل الخدمات بأعلى جودة.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Divider(color: Colors.white54, thickness: 1),
              SizedBox(height: 20),

              // معلومات التواصل في وسط الشاشة ومنسقة
              Text(
                '📞 أرقام التواصل:',
                style: TextStyle(
                  color: Colors.tealAccent.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '01021634820\n01062228066\n01003614864',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),
              Text(
                '📧 البريد الإلكتروني:',
                style: TextStyle(
                  color: Colors.tealAccent.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'BOLISH638@GMAIL.COM',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),
              Text(
                '📱 رقم الواتساب:',
                style: TextStyle(
                  color: Colors.tealAccent.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '01003614864',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),
              Text(
                '📍 العنوان:',
                style: TextStyle(
                  color: Colors.tealAccent.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '74 ش المحروسه متفرع من ش احمد عرابي - المهندسين',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
