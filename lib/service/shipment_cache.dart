import 'package:delivery_tracking/models/shipment.dart';

class CacheEntry {
  final List<dynamic> results;
  final DateTime timestamp;
  final String filterType;

  CacheEntry({
    required this.results,
    required this.timestamp,
    required this.filterType,
  });

  bool isValid() {
    // Cache entries are valid for 5 minutes
    return DateTime.now().difference(timestamp).inMinutes < 5;
  }
}

class ShipmentCache {
  static final ShipmentCache _instance = ShipmentCache._internal();
  factory ShipmentCache() => _instance;
  ShipmentCache._internal();

  final Map<String, CacheEntry> _cache = {};

  String _generateKey(String origin, String destination, String filterType) {
    return '$origin-$destination-$filterType';
  }

  void cacheResults(String origin, String destination, String filterType,
      List<dynamic> results) {
    final key = _generateKey(origin, destination, filterType);
    _cache[key] = CacheEntry(
      results: results,
      timestamp: DateTime.now(),
      filterType: filterType,
    );
  }

  List<dynamic>? getResults(
      String origin, String destination, String filterType) {
    final key = _generateKey(origin, destination, filterType);
    final entry = _cache[key];

    if (entry != null && entry.isValid() && entry.filterType == filterType) {
      return entry.results;
    }

    // Remove expired entry if it exists
    if (entry != null) {
      _cache.remove(key);
    }

    return null;
  }

  void clearCache() {
    _cache.clear();
  }
}
