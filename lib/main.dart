import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/cache_helper.dart';
import 'package:flutter_application_1/ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const MyApp());
}

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
