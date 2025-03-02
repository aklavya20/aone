import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'addproduct.dart';
import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await Hive.openBox('cart');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('authBox');
    final isLoggedIn = box.get('auth_token') != null;
    final role = box.get('role');

    Widget homePage;
    if (isLoggedIn) {
      if (role == 'admin') {
        homePage = const AddProduct();
      } else {
        homePage = const Home();
      }
    } else {
      homePage = const LoginScreen();
    }
    return MaterialApp(
      title: 'Aone',
      debugShowCheckedModeBanner: false,
      home: homePage,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
