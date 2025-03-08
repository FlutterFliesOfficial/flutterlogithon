import 'package:flutter/material.dart';
import 'package:delivery_tracking/widgets/menu_item.dart';
//import "main.dart";

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Profile Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.pink[100],
                      child:
                          const Text('R', style: TextStyle(color: Colors.pink)),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Manthan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('manthan@gmail.com',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              // Navigation Menu
              const SizedBox(height: 10),

              // Dashboard
              MenuItem(
                icon: Icons.dashboard_outlined,
                title: 'Dashboard',
                isSelected: ModalRoute.of(context)?.settings.name == '/',
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),

              // Tracking
              MenuItem(
                icon: Icons.location_on_outlined,
                title: 'Tracking',
                isSelected:
                    ModalRoute.of(context)?.settings.name == '/tracking',
                onTap: () {
                  Navigator.pushNamed(context, '/tracking');
                },
              ),

              const MenuItem(
                  icon: Icons.inbox_outlined, title: 'Inbox', badge: '3'),
              const MenuItem(
                  icon: Icons.shopping_cart_outlined, title: 'Orders'),
              const MenuItem(icon: Icons.people_outline, title: 'Customers'),
              const MenuItem(icon: Icons.help_outline, title: 'Help & Support'),
              const MenuItem(icon: Icons.settings_outlined, title: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
