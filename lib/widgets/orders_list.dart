// import 'package:flutter/material.dart';
// import 'package:delivery_tracking/widgets/order_card.dart';

// class OrdersList extends StatelessWidget {
//   const OrdersList({super.key});

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
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: const [
//                 OrderCard(
//                   orderNumber: '#3565432',
//                   status: 'Delivery',
//                   customer: 'Albert Flores',
//                   fromAddress: '4140 Parker Rd, Allentown, Mexico 31134',
//                   toAddress: '3517 W. Gray St, Utica, Pennsylvania 57867',
//                 ),
//                 SizedBox(height: 16),
//                 OrderCard(
//                   orderNumber: '#483920',
//                   status: 'Transit',
//                   customer: 'Guy Hawkins',
//                   fromAddress: '6391 Elgin St, Celina, Delaware 10299',
//                   toAddress: '8502 Preston Rd, Inglewood, Maine 98380',
//                   isSelected: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:delivery_tracking/service/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:delivery_tracking/widgets/order_card.dart';
// import 'package:delivery_tracking/services/supabase_service.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _ordersFuture = SupabaseService.getOrders(); // Fetch orders
  // }
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
        border: Border(
          right: BorderSide(color: Colors.grey[200]!),
        ),
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
          // Expanded(
          //   child: FutureBuilder<List<Map<String, dynamic>>>(
          //     future: _ordersFuture,
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else if (snapshot.hasError) {
          //         return Center(child: Text('Error: ${snapshot.error}'));
          //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //         return const Center(child: Text('No orders found.'));
          //       }

          //       final orders = snapshot.data!;
          //       return ListView.builder(
          //         padding: const EdgeInsets.all(16),
          //         itemCount: orders.length,
          //         itemBuilder: (context, index) {
          //           final order = orders[index];
          //           return Column(
          //             children: [
          //               OrderCard(
          //                 orderNumber: '#${order['id']}',
          //                 status: order['status'] ?? 'Unknown',
          //                 customer: order['customer_name'] ?? 'Unknown',
          //                 fromAddress: order['']['from_address'] ?? 'Unknown',
          //                 toAddress: order['to_address'] ?? 'Unknown',
          //               ),
          //               const SizedBox(height: 16),
          //             ],
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error fetching orders: ${snapshot.error}');
                  return Center(
                    child: Text('Error loading orders: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No orders available'));
                }

                final orders = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    // Extract username from users table
                    final String customerName =
                        order['users']['username'] ?? 'Unknown';

                    // // Extract tracking status
                    // final List<dynamic> trackingData =
                    //     order['order_tracking'] ?? [];
                    // final String trackingStatus = trackingData.isNotEmpty
                    //     ? trackingData.first['status'] ?? 'Unknown'
                    //     : 'No Tracking Info';
                    final dynamic trackingDataRaw =
                        order['order_tracking']; // Get raw data

// Ensure it's a list, otherwise convert it
                    final List<dynamic> trackingData = trackingDataRaw is List
                        ? trackingDataRaw
                        : (trackingDataRaw is Map ? [trackingDataRaw] : []);

                    final String trackingStatus =
                        trackingData.isNotEmpty && trackingData.first is Map
                            ? trackingData.first['status'] ?? 'Unknown'
                            : 'No Tracking Info';

                    // // Extract from_address and to_address from routes JSON
                    // final List<dynamic> routes = order['routes'] ?? [];
                    // final String fromAddress =
                    //     routes.isNotEmpty ? routes.first.toString() : 'Unknown';
                    // final String toAddress =
                    //     routes.length > 1 ? routes.last.toString() : 'Unknown';
                    final dynamic routesData =
                        trackingData.first['route']; // Get raw data

                    // Ensure it's a list, otherwise convert it
                    final List<dynamic> routes = routesData is List
                        ? routesData
                        : (routesData is Map ? [routesData] : []);

                    final String fromAddress =
                        routes.isNotEmpty ? routes.first.toString() : 'Unknown';
                    final String toAddress =
                        routes.length > 1 ? routes.last.toString() : 'Unknown';

                    print('Routes Data: ${trackingData}');
                    print('Routes Data: ${routesData}');
                    print('Type of Routes: ${trackingData.runtimeType}');

                    return Column(
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
