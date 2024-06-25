import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/home/dashboard/dashboard.dart';
import 'package:project/main.dart';

import '../home/dashboard/dashboard_saya.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'project',
      theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      routes: {
        //  '/': (context) => const Login(),
        '/dashboard': (context) => const Dashboard(),
        '/dashboard_saya': (context) => const DashboardSaya(),
      },
    );
  }
}
