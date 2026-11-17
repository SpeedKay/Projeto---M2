import 'package:flutter/material.dart';

import '../feature/home/presentation/home_page.dart';

class MuralFyiApp extends StatefulWidget {
  const MuralFyiApp({super.key});

  @override
  State<MuralFyiApp> createState() => _MuralFyiAppState();
}

class _MuralFyiAppState extends State<MuralFyiApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mural FYI — Achados e Perdidos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B60)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      home: HomePage(),
    );
  }
}