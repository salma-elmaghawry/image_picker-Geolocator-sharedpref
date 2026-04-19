import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/screens/home_screen.dart';
import 'package:flutter_application_1/services/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const MyApp());
}

/// MyApp is the root widget of the application
/// This is a StatelessWidget because the app configuration doesn't change
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const HomeScreen(),
    );
  }
}
