
 
import 'package:flutter/material.dart';
import 'package:movil_inspeccion/view/login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void>  main() async{
  await Supabase.initialize(
    url: 'https://czqgamnqxxgkqdgnazvy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN6cWdhbW5xeHhna3FkZ25henZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3OTc3MDIsImV4cCI6MjA3MzM3MzcwMn0.dsHCfv4AbPpCpTNiaq75_wUQAYSDzEvGrXIOefzFbRE'
  );
  runApp(const Main());

}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}