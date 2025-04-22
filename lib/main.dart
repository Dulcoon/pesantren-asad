import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'pages/login/login_screen.dart';
import 'pages/signup/signup_screen.dart';
import 'pages/home/homePage.dart';
import 'pages/keuangan/keuangan_screen.dart';
import 'pages/profile/profile_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // Untuk inisialisasi locale

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'MaisonNeue'),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/homepage': (context) => const HomePage(),
        '/keuangan': (context) => const KeuanganPage(),
        '/profil': (context) => const ProfilPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
