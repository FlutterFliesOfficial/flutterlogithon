// import 'package:delivery_tracking/service/supabase_service.dart';
// import 'package:flutter/material.dart';
// import 'package:delivery_tracking/widgets/order_card.dart';
// // import 'package:delivery_tracking/services/supabase_service.dart';

// class OrdersList extends StatefulWidget {
//     final Function(List<LatLng>) onOrderSelected; // Callback to update map

//   const OrdersList({super.key, required this.onOrderSelected});
//   // const OrdersList({super.key});

//   @override
//   _OrdersListState createState() => _OrdersListState();
// }

// class _OrdersListState extends State<OrdersList> {
//   late Future<List<Map<String, dynamic>>> _ordersFuture;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _ordersFuture = SupabaseService.getOrders(); // Fetch orders
//   // }
//   @override
//   void initState() {
//     super.initState();
//     _ordersFuture = fetchOrders();
//   }

//   Future<List<Map<String, dynamic>>> fetchOrders() async {
//     final response = await SupabaseService.client
//         .from('orders')
//         .select('id, status, order_tracking(*), users(username)')
//         .order('created_at', ascending: false);

//     return List<Map<String, dynamic>>.from(response);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 350,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           right: BorderSide(color: Colors.grey[200]!),
//         ),
//       ),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Tracking Delivery',
//                     style:
//                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 Icon(Icons.more_vert),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: _ordersFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   print('Error fetching orders: ${snapshot.error}');
//                   return Center(
//                     child: Text('Error loading orders: ${snapshot.error}'),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No orders available'));
//                 }

//                 final orders = snapshot.data!;
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     final order = orders[index];

//                     // Extract username from users table
//                     final String customerName =
//                         order['users']['username'] ?? 'Unknown';

//                     // // Extract tracking status
//                     // final List<dynamic> trackingData =
//                     //     order['order_tracking'] ?? [];
//                     // final String trackingStatus = trackingData.isNotEmpty
//                     //     ? trackingData.first['status'] ?? 'Unknown'
//                     //     : 'No Tracking Info';
//                     final dynamic trackingDataRaw =
//                         order['order_tracking']; // Get raw data

// // Ensure it's a list, otherwise convert it
//                     final List<dynamic> trackingData = trackingDataRaw is List
//                         ? trackingDataRaw
//                         : (trackingDataRaw is Map ? [trackingDataRaw] : []);

//                     final String trackingStatus =
//                         trackingData.isNotEmpty && trackingData.first is Map
//                             ? trackingData.first['status'] ?? 'Unknown'
//                             : 'No Tracking Info';

//                     // // Extract from_address and to_address from routes JSON
//                     // final List<dynamic> routes = order['routes'] ?? [];
//                     // final String fromAddress =
//                     //     routes.isNotEmpty ? routes.first.toString() : 'Unknown';
//                     // final String toAddress =
//                     //     routes.length > 1 ? routes.last.toString() : 'Unknown';
//                     final dynamic routesData =
//                         trackingData.first['route']; // Get raw data

//                     // Ensure it's a list, otherwise convert it
//                     final List<dynamic> routes = routesData is List
//                         ? routesData
//                         : (routesData is Map ? [routesData] : []);

//                     final String fromAddress =
//                         routes.isNotEmpty ? routes.first.toString() : 'Unknown';
//                     final String toAddress =
//                         routes.length > 1 ? routes.last.toString() : 'Unknown';

//                     print('Routes Data: ${trackingData}');
//                     print('Routes Data: ${routesData}');
//                     print('Type of Routes: ${trackingData.runtimeType}');

//                     return Column(
//                       children: [
//                         OrderCard(
//                           orderNumber: '#${order['id']}',
//                           status: trackingStatus,
//                           customer: customerName,
//                           fromAddress: fromAddress,
//                           toAddress: toAddress,
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:delivery_tracking/widgets/order_card.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:delivery_tracking/service/supabase_service.dart';

// class OrdersList extends StatefulWidget {
//   final Function(List<LatLng>) onOrderSelected; // Callback to update the map

//   const OrdersList({super.key, required this.onOrderSelected});

//   @override
//   _OrdersListState createState() => _OrdersListState();
// }

// class _OrdersListState extends State<OrdersList> {
//   late Future<List<Map<String, dynamic>>> _ordersFuture;

//   @override
//   void initState() {
//     super.initState();
//     _ordersFuture = fetchOrders();
//   }

//   Future<List<Map<String, dynamic>>> fetchOrders() async {
//     final response = await SupabaseService.client
//         .from('orders')
//         .select('id, status, order_tracking(*), users(username)')
//         .order('created_at', ascending: false);

//     return List<Map<String, dynamic>>.from(response);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 350,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(right: BorderSide(color: Colors.grey[200]!)),
//       ),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Tracking Delivery',
//                     style:
//                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 Icon(Icons.more_vert),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: _ordersFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                       child: Text('Error loading orders: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No orders available'));
//                 }

//                 final orders = snapshot.data!;
//                 print('Orders: $orders');
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     final order = orders[index];

//                     final String customerName =
//                         order['users']['username'] ?? 'Unknown';
//                     final dynamic trackingDataRaw = order['order_tracking'];

//                     final List<dynamic> trackingData = trackingDataRaw is List
//                         ? trackingDataRaw
//                         : (trackingDataRaw is Map ? [trackingDataRaw] : []);

//                     final String trackingStatus =
//                         trackingData.isNotEmpty && trackingData.first is Map
//                             ? trackingData.first['status'] ?? 'Unknown'
//                             : 'No Tracking Info';

//                     final dynamic routesData = trackingData.first['route'];

//                     final List<dynamic> routes = routesData is List
//                         ? routesData
//                         : (routesData is Map ? [routesData] : []);

//                     final String fromAddress =
//                         routes.isNotEmpty ? routes.first.toString() : 'Unknown';
//                     final String toAddress =
//                         routes.length > 1 ? routes.last.toString() : 'Unknown';

//                     // Extract coordinates for the route
//                     final List<LatLng> routeCoordinates = routes
//                         .where((route) =>
//                             route is Map &&
//                             route.containsKey('lat') &&
//                             route.containsKey('lng'))
//                         .map((route) => LatLng(route['lat'], route['lng']))
//                         .toList();

//                     return GestureDetector(
//                       onTap: () {
//                         widget.onOrderSelected(
//                             routeCoordinates); // Send coordinates to MapSection
//                       },
//                       child: Column(
//                         children: [
//                           OrderCard(
//                             orderNumber: '#${order['id']}',
//                             status: trackingStatus,
//                             customer: customerName,
//                             fromAddress: fromAddress,
//                             toAddress: toAddress,
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:delivery_tracking/widgets/order_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_tracking/service/supabase_service.dart';
import 'dart:convert';

class OrdersList extends StatefulWidget {
  final Function(List<LatLng>) onOrderSelected; // Callback to update the map

  const OrdersList({super.key, required this.onOrderSelected});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final response = await SupabaseService.client
        .from('orders')
        .select('id, status, order_tracking(*), users(username)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tracking Delivery',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.more_vert),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error loading orders: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No orders available'));
                }

                final orders = snapshot.data!;
                print('Orders: $orders');
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    final String customerName =
                        order['users']['username'] ?? 'Unknown';
                    final dynamic trackingDataRaw = order['order_tracking'];

                    final List<dynamic> trackingData = trackingDataRaw is List
                        ? trackingDataRaw
                        : (trackingDataRaw is Map ? [trackingDataRaw] : []);

                    final String trackingStatus =
                        trackingData.isNotEmpty && trackingData.first is Map
                            ? trackingData.first['status'] ?? 'Unknown'
                            : 'No Tracking Info';

                    final dynamic routesData = trackingData.first['route'];

                    // Ensure `route` is always a list
                    final List<dynamic> routes = routesData is List
                        ? routesData
                        : (routesData is Map ? [routesData] : []);

                    final String fromAddress = routes.isNotEmpty
                        ? (routes.first is Map &&
                                routes.first.containsKey('name')
                            ? routes.first['name']
                            : 'Unknown')
                        : 'Unknown';

                    final String toAddress = routes.length > 1
                        ? (routes.last is Map && routes.last.containsKey('name')
                            ? routes.last['name']
                            : 'Unknown')
                        : 'Unknown';
                    print(order['order_tracking']['route']);

                    // }

// Check if the decoded data contains 'latitude' and 'longitude'
                    // if (routeData.containsKey('latitude') &&
                    //     routeData.containsKey('longitude')) {
                    //   final latitude = routeData['latitude'];
                    //   final longitude = routeData['longitude'];

                    //   // Now you can create LatLng
                    //   final LatLng coordinates = LatLng(latitude, longitude);
                    //   print('LatLng: $coordinates');
                    // }
// Check if `route` is a string or list
                    List<LatLng> routeCoordinates = [];
                    if (order['order_tracking']['route'] is String) {
                      // If it's a string, you can either print, parse, or skip it
                      print(
                          'Route is a string: ${order['order_tracking']['route']}');
                      // Handle the string here if needed, for example by extracting coordinates
                    } else if (order['order_tracking']['route'] is List) {
                      // If it's a list, loop through the list and extract coordinates
                      for (var route in order['order_tracking']['route']) {
                        if (route is Map &&
                            route.containsKey('latitude') &&
                            route.containsKey('longitude')) {
                          final latitude = route['latitude'];
                          final longitude = route['longitude'];
                          routeCoordinates.add(LatLng(latitude, longitude));
                        }
                      }
                    }

                    print(routeCoordinates); // Output the coordinates
//eturn empty list if `route` is not a valid list

                    return GestureDetector(
                      onTap: () {
                        widget.onOrderSelected(
                            routeCoordinates); // Send coordinates to MapSection
                        print('Route Coordinates: $routeCoordinates');
                      },
                      child: Column(
                        children: [
                          OrderCard(
                            orderNumber: '#${order['id']}',
                            status: trackingStatus,
                            customer: customerName,
                            fromAddress: fromAddress,
                            toAddress: toAddress,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
