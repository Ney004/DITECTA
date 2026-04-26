import '../services/database_service.dart';
import '../models/scan_model.dart';

class ScanData {
  static List<ScanModel> getRecentScans() => DatabaseService().getRecentScans();
  static List<ScanModel> getAllScans() => DatabaseService().getAllScans();
}
