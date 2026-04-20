
 
import 'package:flutter/material.dart';
import 'package:movil_inspeccion/view/login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void>  main() async{
  await Supabase.initialize(
    url: 'https://flqfnpfxbpashpbgpqcx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZscWZucGZ4YnBhc2hwYmdwcWN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1OTYwNDcsImV4cCI6MjA4MDE3MjA0N30.WfmVU7cEwFrR4dv1CXIW-4etJvjZDX3aEX-97hZW6zU'
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