import 'package:flutter/material.dart';

class DriverInfoCard extends StatelessWidget {
  const DriverInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Text('PO'),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Philip Osborne',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Driver · USA', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.email_outlined, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Text('philiposborne@gmail.com'),
              Icon(Icons.copy, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.phone_outlined, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Text('(208) 555-0112'),
              Icon(Icons.copy, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}