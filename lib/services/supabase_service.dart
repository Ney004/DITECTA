import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/scan_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final _client = Supabase.instance.client;

  // UID del usuario actual
  String? get _uid => _client.auth.currentUser?.id;
  bool get isLoggedIn => _uid != null;

  // ── Guardar escaneo ─────────────────────────────────────────────
  Future<void> saveScan(ScanModel scan) async {
    if (_uid == null) return;
    await _client.from('scans').insert({
      'user_id': _uid,
      'title': scan.title,
      'date': scan.date,
      'time_ago': scan.timeAgo,
      'severity': scan.severity,
      'disease_type': scan.diseaseType,
      'image_path': scan.imagePath,
      'confidence': scan.confidence,
      'sector': scan.sector,
      'scanned_at': scan.scannedAt.toIso8601String(),
    });
  }

  // ── Guardar lista (migración) ───────────────────────────────────
  Future<void> saveAllScans(List<ScanModel> scans) async {
    if (_uid == null || scans.isEmpty) return;
    final rows = scans
        .map(
          (scan) => {
            'user_id': _uid,
            'title': scan.title,
            'date': scan.date,
            'time_ago': scan.timeAgo,
            'severity': scan.severity,
            'disease_type': scan.diseaseType,
            'image_path': scan.imagePath,
            'confidence': scan.confidence,
            'sector': scan.sector,
            'scanned_at': scan.scannedAt.toIso8601String(),
          },
        )
        .toList();
    await _client.from('scans').insert(rows);
  }

  // ── Leer todos ──────────────────────────────────────────────────
  Future<List<ScanModel>> getAllScans() async {
    if (_uid == null) return [];
    final data = await _client
        .from('scans')
        .select()
        .eq('user_id', _uid!)
        .order('scanned_at', ascending: false);

    return (data as List)
        .map(
          (row) => ScanModel(
            supabaseId: row['id'],
            title: row['title'],
            date: row['date'],
            timeAgo: row['time_ago'],
            severity: row['severity'],
            diseaseType: row['disease_type'],
            imagePath: row['image_path'],
            confidence: (row['confidence'] as num).toDouble(),
            sector: row['sector'],
            scannedAt: DateTime.parse(row['scanned_at']),
          ),
        )
        .toList();
  }

  // ── Stream reactivo ─────────────────────────────────────────────
  Stream<List<ScanModel>> watchAllScans() {
    if (_uid == null) return const Stream.empty();
    return _client
        .from('scans')
        .stream(primaryKey: ['id'])
        .eq('user_id', _uid!)
        .order('scanned_at', ascending: false)
        .map(
          (rows) => rows
              .map(
                (row) => ScanModel(
                  supabaseId: row['id'],
                  title: row['title'],
                  date: row['date'],
                  timeAgo: row['time_ago'],
                  severity: row['severity'],
                  diseaseType: row['disease_type'],
                  imagePath: row['image_path'],
                  confidence: (row['confidence'] as num).toDouble(),
                  sector: row['sector'],
                  scannedAt: DateTime.parse(row['scanned_at']),
                ),
              )
              .toList(),
        );
  }

  // ── Eliminar escaneo ────────────────────────────────────────────
  Future<void> deleteScan(String supabaseId) async {
    await _client.from('scans').delete().eq('id', supabaseId);
  }

  // ── Borrar todo el historial ────────────────────────────────────
  Future<void> clearAllScans() async {
    if (_uid == null) return;
    await _client.from('scans').delete().eq('user_id', _uid!);
  }

  // ── Verificar si ya migró ───────────────────────────────────────
  Future<bool> hasMigratedData() async {
    if (_uid == null) return false;
    final data = await _client
        .from('user_meta')
        .select()
        .eq('user_id', _uid!)
        .maybeSingle();
    return data?['migrated'] == true;
  }

  // ── Marcar migración como completada ───────────────────────────
  Future<void> markAsMigrated() async {
    if (_uid == null) return;
    await _client.from('user_meta').upsert({'user_id': _uid, 'migrated': true});
  }
}
