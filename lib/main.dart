import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'display_page.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("Todo");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'River To-Do',
      theme: ThemeData(
        useMaterial3: true,
        // brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}
