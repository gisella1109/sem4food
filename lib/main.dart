import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'services/notification_service.dart';

void main() async {
  // Wajib sebelum init plugin
  WidgetsFlutterBinding.ensureInitialized();

  // Init push notification service
  await NotificationService().init();

  runApp(const AplikasiKu());
}

class AplikasiKu extends StatelessWidget {
  const AplikasiKu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Makan Diabetes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2979FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}