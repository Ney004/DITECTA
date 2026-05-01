import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'screens/home.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://kiqhdwicqyeyfpiyezva.supabase.co',
    anonKey: 'sb_publishable_t49ZHOqSovIM5VhqidzaYQ_2YHOSIdG',
  );

  // Inicializar Hive
  await DatabaseService().init();

  // sincronizacion sin internet
  Connectivity().onConnectivityChanged.listen((results) async {
    debugPrint('📡 Conectividad cambió: $results');
    final hasInternet = results.any((r) => r != ConnectivityResult.none);
    if (hasInternet) {
      debugPrint('🌐 Conexión restaurada — sincronizando...');
      await DatabaseService().syncPendingScans();
    }
  });

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
