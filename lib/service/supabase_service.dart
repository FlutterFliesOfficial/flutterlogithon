import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _client;

  static Future<void> initialize() async {
    await dotenv.load();

    await Supabase.initialize(
      url: dotenv.env['VITE_SUPABASE_URL']!,
      anonKey: dotenv.env['VITE_SUPABASE_ANON_KEY']!,
    );

    _client = Supabase.instance.client;
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase client not initialized');
    }
    return _client!;
  }

  // Orders
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await client
        .from('orders')
        .select('*, order_tracking(*)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> getOrderById(String id) async {
    final response = await client
        .from('orders')
        .select('*, order_tracking(*)')
        .eq('id', id)
        .single();

    return response;
  }

  // Order Tracking
  static Future<List<Map<String, dynamic>>> getOrderTracking(
      String orderId) async {
    final response = await client
        .from('order_tracking')
        .select()
        .eq('order_id', orderId)
        .order('updated_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
