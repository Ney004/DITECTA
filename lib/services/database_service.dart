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
      try {
        await _supabase.saveScan(scan);
      } catch (e) {
        debugPrint('❌ Sin internet, guardando localmente...');
        // Guardar con supabaseId vacío para identificarlo como pendiente
        final localScan = ScanModel(
          supabaseId: '', // ← vacío = pendiente de sincronizar
          title: scan.title,
          date: scan.date,
          timeAgo: scan.timeAgo,
          severity: scan.severity,
          diseaseType: scan.diseaseType,
          imagePath: scan.imagePath,
          confidence: scan.confidence,
          sector: scan.sector,
          scannedAt: scan.scannedAt,
        );
        await box.add(localScan.toMap());
        _notifyListeners();
        debugPrint('✅ Guardado localmente con supabaseId vacío');
      }
    } else {
      await box.add(scan.toMap());
      _notifyListeners();
    }
  }

  // ── Sincronizar escaneos locales pendientes con Supabase ─────────
  Future<void> syncPendingScans() async {
    if (!isLoggedIn) return;

    try {
      final allKeys = box.keys.toList();
      debugPrint('📦 Total en Hive: ${allKeys.length}');

      final localScans = allKeys
          .map((key) => ScanModel.fromMap(box.get(key), key as int))
          .where((scan) => scan.supabaseId.isEmpty)
          .toList();

      debugPrint('📦 Pendientes (supabaseId vacío): ${localScans.length}');

      if (localScans.isEmpty) {
        debugPrint('ℹ️ No hay escaneos pendientes');
        // Limpiar Hive de todas formas si hay sesión activa
        await box.clear();
        return;
      }

      for (final scan in localScans) {
        debugPrint('📤 Subiendo: ${scan.title}');
        await _supabase.saveScan(scan);
      }

      await box.clear();
      debugPrint('✅ Hive limpiado — ${localScans.length} escaneos subidos');
    } catch (e) {
      debugPrint('❌ Error: $e');
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
      // Crear un StreamController que emite primero el caché local
      final controller = StreamController<List<ScanModel>>();

      // Emitir caché local INMEDIATAMENTE
      final cached = getAllScans();
      if (cached.isNotEmpty) {
        controller.add(cached);
      }

      // Luego escuchar Supabase
      _supabase.watchAllScans().listen(
        (scans) {
          _updateLocalCache(scans);
          if (!controller.isClosed) controller.add(scans);
        },
        onError: (e) {
          debugPrint('❌ Stream error (sin internet): $e');
          // En error, emitir caché local y cerrar con datos
          if (!controller.isClosed) {
            controller.add(getAllScans());
          }
        },
      );

      return controller.stream;
    }

    // Sin sesión: stream de Hive local
    Future.microtask(() => _notifyListeners());
    return _controller.stream;
  }

  // ── Actualizar caché local en background ────────────────────────
  void _updateLocalCache(List<ScanModel> scans) async {
    try {
      await box.clear();
      for (final scan in scans) {
        // Guardar el supabaseId en el mapa para poder recuperarlo
        final map = scan.toMap();
        map['supabaseId'] = scan.supabaseId; // ← agrega esto
        await box.add(map);
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
        final map = scan.toMap();
        map['supabaseId'] = scan.supabaseId; // ← agrega esto
        await box.add(map);
      }
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
