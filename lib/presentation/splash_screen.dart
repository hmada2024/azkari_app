import 'package:flutter/material.dart';
import 'package:azkari_app/data/services/database_helper.dart';
import 'package:azkari_app/features/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // هذه الدالة هي قلب الحل
  Future<void> _initializeApp() async {
    try {
      // هنا نقوم بالعملية الطويلة (تهيئة قاعدة البيانات)
      await DatabaseHelper.instance.database;
      
      // بعد نجاح التهيئة، ننتقل للشاشة الرئيسية
      // التحقق من أن الويدجت لا يزال موجودًا في الشجرة قبل الانتقال
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      // في حالة فشل تحميل قاعدة البيانات، اعرض رسالة خطأ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تهيئة التطبيق: $e'),
            backgroundColor: Colors.red,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // واجهة بسيطة أثناء تحميل قاعدة البيانات
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              "جاري تهيئة التطبيق...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}