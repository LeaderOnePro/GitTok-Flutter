import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitTok Flutter',
      theme: ThemeData(
        brightness: Brightness.dark, // Explicitly set dark brightness
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo, // Changed from Colors.deepPurple to Colors.indigo
          brightness: Brightness.dark, // Ensure seed color generates dark scheme
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
