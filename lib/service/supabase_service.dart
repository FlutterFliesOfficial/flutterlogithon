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

    static Future<int> createOrder(String status) async {
    final response = await client
        .from('orders')
        .insert({
          'customer_id': '0fc4d7e3-a280-4aa2-a4b4-b0f6344a6a64', // Replace with your constant customer_id
          'status': status,
        })
        .select()
        .single();

    return response['id'] as int;
  }

   static Future<void> createOrderTracking({
    required int orderId,
    required String status,
    required String trackingDetails,
    required String location,
    required String route,
  }) async {
    await client.from('order_tracking').insert({
      'order_id': orderId,
      'status': status,
      'tracking_details': trackingDetails,
      'location': location,
      'route': route,
    });
  }
}
