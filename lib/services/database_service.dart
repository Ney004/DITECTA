import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_model.dart';
import 'supabase_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _boxName = 'scans';
  Box? _box;

  final _controller = StreamController<List<ScanModel>>.broadcast();
  final _supabase = SupabaseService();

  // ── Inicialización ──────────────────────────────────────────────
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Box get box {
    if (_box == null) throw Exception('Hive no inicializado.');
    return _box!;
  }

  bool get isLoggedIn => _supabase.isLoggedIn;

  // ── Guardar ─────────────────────────────────────────────────────
  Future<void> saveScan(ScanModel scan) async {
    if (isLoggedIn) {
      await _supabase.saveScan(scan);
    } else {
      await box.add(scan.toMap());
      _notifyListeners();
    }
  }

  // ── Leer todos (siempre lee Hive como fallback) ─────────────────
  List<ScanModel> getAllScans() {
    return box.keys
        .map((key) => ScanModel.fromMap(box.get(key), key as int))
        .toList()
      ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
  }

  List<ScanModel> getRecentScans({int limit = 3}) =>
      getAllScans().take(limit).toList();

  // ── Stream reactivo ─────────────────────────────────────────────
  Stream<List<ScanModel>> watchAllScans() {
    if (isLoggedIn) {
      // Con sesión: stream de Supabase + actualiza caché local en background
      return _supabase.watchAllScans().map((scans) {
        _updateLocalCache(scans);
        return scans;
      });
    }
    // Sin sesión: stream de Hive local (datos cacheados)
    Future.microtask(() => _notifyListeners());
    return _controller.stream;
  }

  // ── Actualizar caché local en background ────────────────────────
  void _updateLocalCache(List<ScanModel> scans) async {
    try {
      await box.clear();
      for (final scan in scans) {
        await box.add(scan.toMap());
      }
    } catch (e) {
      debugPrint('Error actualizando caché local: $e');
    }
  }

  void _notifyListeners() {
    if (!_controller.isClosed) _controller.add(getAllScans());
  }

  // ── Eliminar ────────────────────────────────────────────────────
  Future<void> deleteScan(int id) async {
    await box.delete(id);
    _notifyListeners();
  }

  // ── Borrar historial ────────────────────────────────────────────
  Future<void> clearAllScans() async {
    if (isLoggedIn) {
      await _supabase.clearAllScans();
    }
    // Siempre limpia también el caché local
    await box.clear();
    _notifyListeners();
  }

  // ── Caché local antes de cerrar sesión ──────────────────────────
  Future<void> cacheSupabaseDataLocally() async {
    if (!isLoggedIn) return;
    try {
      final cloudScans = await _supabase.getAllScans();
      await box.clear();
      for (final scan in cloudScans) {
        await box.add(scan.toMap());
      }
      debugPrint('✅ ${cloudScans.length} escaneos cacheados localmente');
    } catch (e) {
      debugPrint('❌ Error cacheando datos: $e');
    }
  }

  // ── Migrar Hive → Supabase ──────────────────────────────────────
  Future<void> migrateLocalToSupabase() async {
    if (!isLoggedIn) return;

    final alreadyMigrated = await _supabase.hasMigratedData();
    if (alreadyMigrated) return;

    final localScans = box.keys
        .map((key) => ScanModel.fromMap(box.get(key), key as int))
        .toList();

    if (localScans.isNotEmpty) {
      await _supabase.saveAllScans(localScans);
      await box.clear();
      debugPrint('✅ ${localScans.length} escaneos migrados a Supabase');
    }

    await _supabase.markAsMigrated();
  }

  Future<void> close() async {
    await _controller.close();
    await _box?.close();
  }
}
