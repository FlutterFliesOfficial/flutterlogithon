import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  final String startPort;
  final String endPort;
  final dynamic routeDetails;

  const BookingPage({
    Key? key,
    required this.startPort,
    required this.endPort,
    required this.routeDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Your Route"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Booking Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "From: $startPort",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "To: $endPort",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Cost: \$${routeDetails['totalCost'].toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "Complete your booking by filling out the details below:",
              style: TextStyle(fontSize: 16),
            ),
            // Booking form would go here
          ],
        ),
      ),
    );
  }
}
