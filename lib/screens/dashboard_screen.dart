// lib/screens/dashboard_screen.dart

import 'package:delivery_tracking/widgets/left_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:delivery_tracking/screens/shipment_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LeftSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  floating: true,
                  pinned: true,
                  title: const Text('Delivery Dashboard'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80',
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.5,
                          children: [
                            _buildStatCard(
                              context,
                              'Active Shipments',
                              '12',
                              Icons.local_shipping_outlined,
                              const Color(0xFF6366F1),
                            ),
                            _buildStatCard(
                              context,
                              'In Transit',
                              '8',
                              Icons.timeline_outlined,
                              const Color(0xFF8B5CF6),
                            ),
                            _buildStatCard(
                              context,
                              'Delivered',
                              '5',
                              Icons.done_all_outlined,
                              const Color(0xFF10B981),
                            ),
                            _buildStatCard(
                              context,
                              'Delayed',
                              '2',
                              Icons.warning_outlined,
                              const Color(0xFFEF4444),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Quick Actions
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.bolt,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Quick Actions',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildActionButton(
                                      context,
                                      'New Shipment',
                                      Icons.add_box_outlined,
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ShipmentFormScreen(),
                                        ),
                                      ),
                                    ),
                                    _buildActionButton(
                                      context,
                                      'Track',
                                      Icons.search_outlined,
                                      () {},
                                    ),
                                    _buildActionButton(
                                      context,
                                      'Reports',
                                      Icons.bar_chart_outlined,
                                      () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Recent Shipments
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B5CF6)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.local_shipping_outlined,
                                        color: Color(0xFF8B5CF6),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Recent Shipments',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('View All'),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              _buildShipmentItem(
                                'SH001',
                                'New York Port',
                                'Shanghai Port',
                                'In Transit',
                                const Color(0xFF6366F1),
                              ),
                              const Divider(height: 1),
                              _buildShipmentItem(
                                'SH002',
                                'Los Angeles Port',
                                'Singapore Port',
                                'Delayed',
                                const Color(0xFFEF4444),
                              ),
                              const Divider(height: 1),
                              _buildShipmentItem(
                                'SH003',
                                'Miami Port',
                                'Rotterdam Port',
                                'On Schedule',
                                const Color(0xFF10B981),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon,
      VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentItem(String id, String origin, String destination,
      String status, Color statusColor) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipment $id',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$origin → $destination',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
