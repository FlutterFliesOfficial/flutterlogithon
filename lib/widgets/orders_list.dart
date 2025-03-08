import 'package:flutter/material.dart';
import 'package:delivery_tracking/widgets/order_card.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                OrderCard(
                  orderNumber: '#3565432',
                  status: 'Delivery',
                  customer: 'Albert Flores',
                  fromAddress: '4140 Parker Rd, Allentown, Mexico 31134',
                  toAddress: '3517 W. Gray St, Utica, Pennsylvania 57867',
                ),
                SizedBox(height: 16),
                OrderCard(
                  orderNumber: '#483920',
                  status: 'Transit',
                  customer: 'Guy Hawkins',
                  fromAddress: '6391 Elgin St, Celina, Delaware 10299',
                  toAddress: '8502 Preston Rd, Inglewood, Maine 98380',
                  isSelected: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:delivery_tracking/service/supabase_service.dart';
// import 'package:flutter/material.dart';
// import 'package:delivery_tracking/widgets/order_card.dart';
// // import 'package:delivery_tracking/services/supabase_service.dart';

// class OrdersList extends StatefulWidget {
//   const OrdersList({super.key});

//   @override
//   _OrdersListState createState() => _OrdersListState();
// }

// class _OrdersListState extends State<OrdersList> {
//   late Future<List<Map<String, dynamic>>> _ordersFuture;

//   @override
//   void initState() {
//     super.initState();
//     _ordersFuture = SupabaseService.getOrders(); // Fetch orders
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
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No orders found.'));
//                 }

//                 final orders = snapshot.data!;
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     final order = orders[index];
//                     return Column(
//                       children: [
//                         OrderCard(
//                           orderNumber: '#${order['id']}',
//                           status: order['status'] ?? 'Unknown',
//                           customer: order['customer_name'] ?? 'Unknown',
//                           fromAddress: order['from_address'] ?? 'Unknown',
//                           toAddress: order['to_address'] ?? 'Unknown',
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
