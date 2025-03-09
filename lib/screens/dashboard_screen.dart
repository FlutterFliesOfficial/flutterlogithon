import 'package:delivery_tracking/widgets/left_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:delivery_tracking/screens/shipment_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          const LeftSidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.grey[50],
                  elevation: 0,
                  title: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery Dashboard',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Track and manage your shipments efficiently',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShipmentFormScreen(),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text('New Shipment'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Import Data'),
                      ),
                    ],
                  ),
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Cards
                        Row(
                          children: [
                            _buildStatCard(
                              'Active Shipments',
                              '12',
                              'Increased by 25%',
                              Colors.green[700]!,
                              true,
                              Icons.local_shipping_outlined,
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              'In Transit',
                              '8',
                              'On schedule',
                              Colors.blue,
                              false,
                              Icons.timeline_outlined,
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              'Delivered',
                              '5',
                              'Last 24 hours',
                              Colors.orange,
                              false,
                              Icons.done_all_outlined,
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              'Delayed',
                              '2',
                              'Needs attention',
                              Colors.red,
                              false,
                              Icons.warning_outlined,
                            ),
                          ].map((widget) => Expanded(child: widget)).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Shipment Analytics and Quick Actions Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Shipment Analytics
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Shipment Analytics',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: List.generate(
                                        7,
                                        (index) => _buildAnalyticsBar(
                                          height: [60.0, 80.0, 70.0, 100.0, 60.0, 40.0, 50.0][index],
                                          isActive: index == 3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                          .map((day) => Text(
                                                day,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Quick Actions
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Quick Actions',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildQuickActionButton(
                                      context,
                                      'Track Shipment',
                                      Icons.search_outlined,
                                      () {},
                                    ),
                                    const SizedBox(height: 12),
                                    _buildQuickActionButton(
                                      context,
                                      'Generate Report',
                                      Icons.bar_chart_outlined,
                                      () {},
                                    ),
                                    const SizedBox(height: 12),
                                    _buildQuickActionButton(
                                      context,
                                      'Schedule Pickup',
                                      Icons.calendar_today_outlined,
                                      () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Recent Shipments and Progress Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Recent Shipments
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Recent Shipments',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text('View All'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _buildShipmentItem(
                                      'SH001',
                                      'New York Port',
                                      'Shanghai Port',
                                      'In Transit',
                                      Colors.blue,
                                    ),
                                    const Divider(height: 24),
                                    _buildShipmentItem(
                                      'SH002',
                                      'Los Angeles Port',
                                      'Singapore Port',
                                      'Delayed',
                                      Colors.red,
                                    ),
                                    const Divider(height: 24),
                                    _buildShipmentItem(
                                      'SH003',
                                      'Miami Port',
                                      'Rotterdam Port',
                                      'On Schedule',
                                      Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Delivery Progress
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Delivery Progress',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: 150,
                                          width: 150,
                                          child: CircularProgressIndicator(
                                            value: 0.65,
                                            backgroundColor: Colors.grey[200],
                                            color: Colors.green[700],
                                            strokeWidth: 12,
                                          ),
                                        ),
                                        const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '65%',
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'On Time Delivery',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    _buildProgressLegend('On Schedule', Colors.green),
                                    const SizedBox(height: 8),
                                    _buildProgressLegend('In Transit', Colors.blue),
                                    const SizedBox(height: 8),
                                    _buildProgressLegend('Delayed', Colors.red),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

Widget _buildStatCard(
  String title,
  String value,
  String subtitle,
  Color color,
  bool isPrimary,
  IconData icon,
) {
  return Flexible(  // Ensures it doesn't cause overflow
    child: Container(
      padding: const EdgeInsets.all(20), // Reduced padding to avoid overflow
      decoration: BoxDecoration(
        color: isPrimary ? color : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents taking too much space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // Ensures text doesn't overflow
                child: Text(
                  title,
                  style: TextStyle(
                    color: isPrimary ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevents long text issues
                ),
              ),
              Icon(
                icon,
                color: isPrimary ? Colors.white : color,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28, // Slightly reduced font size
              fontWeight: FontWeight.bold,
              color: isPrimary ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.arrow_upward,
                size: 16,
                color: isPrimary ? Colors.white70 : Colors.green,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPrimary ? Colors.white70 : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  // Widget _buildStatCard(String title, String value, String subtitle, Color color, bool isPrimary, IconData icon) {
  //   return Container(
  //     padding: const EdgeInsets.all(40),
  //     decoration: BoxDecoration(
  //       color: isPrimary ? color : Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               title,
  //               style: TextStyle(
  //                 color: isPrimary ? Colors.white : Colors.black,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             Icon(
  //               icon,
  //               color: isPrimary ? Colors.white : color,
  //               size: 24,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: 32,
  //             fontWeight: FontWeight.bold,
  //             color: isPrimary ? Colors.white : Colors.black,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Row(
  //           children: [
  //             Icon(
  //               Icons.arrow_upward,
  //               size: 16,
  //               color: isPrimary ? Colors.white70 : Colors.green,
  //             ),
  //             const SizedBox(width: 4),
  //             Text(
  //               subtitle,
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: isPrimary ? Colors.white70 : Colors.grey[600],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAnalyticsBar({required double height, required bool isActive}) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        color: isActive ? Colors.green[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  Widget _buildShipmentItem(String id, String origin, String destination, String status, Color statusColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.local_shipping_outlined,
            color: statusColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipment $id',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}