import 'package:azkari_app/data/repositories/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:azkari_app/data/services/database_helper.dart';

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

  Future<void> _initializeApp() async {
    try {
      await DatabaseHelper.instance.database;
      if (mounted) {
        // الانتقال إلى AppShell بدلاً من HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AppShell()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تهيئة التطبيق: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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