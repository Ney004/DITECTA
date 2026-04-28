import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://kiqhdwicqyeyfpiyezva.supabase.co',
    anonKey:
        'sb_publishable_t49ZHOqSovIM5VhqidzaYQ_2YHOSIdG', 
  );

  // Inicializar Hive
  await DatabaseService().init();

  runApp(
    MaterialApp(
      title: 'DITECTA',
      debugShowCheckedModeBanner: false,
      home: const Home(),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFAFAF5),
          brightness: Brightness.light,
        ),
      ),
    ),
  );
}
