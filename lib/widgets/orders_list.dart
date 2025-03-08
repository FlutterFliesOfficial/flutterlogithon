import 'package:flutter/material.dart';
import 'package:delivery_tracking/widgets/order_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersList extends StatelessWidget {
  final Function(List<LatLng>) onOrderSelected; // Callback to update map

  const OrdersList({super.key, required this.onOrderSelected});

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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Order 1: New York → Chicago
                GestureDetector(
                  onTap: () {
                    onOrderSelected([
                      const LatLng(40.7128, -74.0060), // New York
                      const LatLng(41.8781, -87.6298), // Chicago
                    ]);
                  },
                  child: const OrderCard(
                    orderNumber: '#3565432',
                    status: 'Delivery',
                    customer: 'Albert Flores',
                    fromAddress: 'New York',
                    toAddress: 'Chicago',
                  ),
                ),
                const SizedBox(height: 16),

                // Order 2: Los Angeles → San Francisco
                GestureDetector(
                  onTap: () {
                    onOrderSelected([
                      const LatLng(34.0522, -118.2437), // Los Angeles
                      const LatLng(37.7749, -122.4194), // San Francisco
                    ]);
                  },
                  child: const OrderCard(
                    orderNumber: '#483920',
                    status: 'Transit',
                    customer: 'Guy Hawkins',
                    fromAddress: 'Los Angeles',
                    toAddress: 'San Francisco',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
