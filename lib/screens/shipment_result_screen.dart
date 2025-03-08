import 'package:delivery_tracking/screens/booking_screen.dart';
import 'package:delivery_tracking/service/shipment_cache.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:delivery_tracking/models/shipment.dart';

class ShipmentResultsScreen extends StatefulWidget {
  final Shipment shipment;

  const ShipmentResultsScreen({
    super.key,
    required this.shipment,
    List? cachedResults,
  });

  @override
  State<ShipmentResultsScreen> createState() => _ShipmentResultsScreenState();
}

class _ShipmentResultsScreenState extends State<ShipmentResultsScreen> {
  List<dynamic> routes = [];
  String selectedFilter = "default";
  bool isLoading = true;
  String? error;
  Set<int> expandedCards = {};
  var _cache = ShipmentCache();

  @override
  void initState() {
    super.initState();
    fetchRoutes();
  }

  Future<void> fetchRoutes() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    // Check cache first
    final cachedResults = _cache.getResults(
      widget.shipment.origin,
      widget.shipment.destination,
      selectedFilter,
    );

    if (cachedResults != null) {
      setState(() {
        routes = cachedResults;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Using cached results'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://192.168.76.163:5000/get_route"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "start_port": widget.shipment.origin,
          "end_port": widget.shipment.destination,
          "filter_type": selectedFilter
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final routeResults = jsonResponse['routes'];

        // Cache the results
        _cache.cacheResults(
          widget.shipment.origin,
          widget.shipment.destination,
          selectedFilter,
          routeResults,
        );

        setState(() {
          routes = routeResults;
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to load routes. Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error connecting to server. Please check your connection.";
        isLoading = false;
      });
    }
  }

  void toggleCardExpansion(int index) {
    setState(() {
      if (expandedCards.contains(index)) {
        expandedCards.remove(index);
      } else {
        expandedCards.add(index);
      }
    });
  }

  String _formatPath(List<dynamic> pathData) {
    return pathData.map((e) => e is String ? e : e["name"]).join(" → ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Routes: ${widget.shipment.origin} to ${widget.shipment.destination}"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _cache.clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
              fetchRoutes(); // Refresh routes after clearing cache
            },
            tooltip: 'Clear Cache',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                const Text("Filter by: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedFilter,
                    items: const [
                      DropdownMenuItem(
                          value: "default", child: Text("Default")),
                      DropdownMenuItem(value: "cost", child: Text("Cheapest")),
                      DropdownMenuItem(
                          value: "distance", child: Text("Shortest")),
                      DropdownMenuItem(value: "time", child: Text("Fastest")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedFilter = value;
                        });
                        fetchRoutes();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: fetchRoutes,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: routes.length,
                        itemBuilder: (context, index) {
                          var route = routes[index];
                          bool isExpanded = expandedCards.contains(index);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money,
                                          color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Total Cost: \$${route['totalCost'].toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: Icon(isExpanded
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          label: Text(isExpanded
                                              ? "Hide Details"
                                              : "View Details"),
                                          onPressed: () =>
                                              toggleCardExpansion(index),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 88, vertical: 12),
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BookingPage(
                                                startPort:
                                                    widget.shipment.origin,
                                                endPort:
                                                    widget.shipment.destination,
                                                routeDetails: route,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text("Book Now"),
                                      )
                                    ],
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 16),
                                    const Divider(),
                                    DetailItem(
                                      icon: Icons.route,
                                      label: "Distance",
                                      value: "${route['totalDistance']} km",
                                    ),
                                    DetailItem(
                                      icon: Icons.timer,
                                      label: "Time",
                                      value:
                                          "${route['time'].toStringAsFixed(2)} hours",
                                    ),
                                    DetailItem(
                                      icon: Icons.factory,
                                      label: "Carbon Emission",
                                      value:
                                          "${route['carbonEmission'].toStringAsFixed(2)} kg",
                                    ),
                                    DetailItem(
                                      icon: Icons.fitness_center,
                                      label: "Min Weight",
                                      value: "${route['minWeight']} kg",
                                    ),
                                    DetailItem(
                                      icon: Icons.gavel,
                                      label: "Regulations",
                                      value: route['regulations'].join(", "),
                                    ),
                                    DetailItem(
                                      icon: Icons.directions,
                                      label: "Path",
                                      value: _formatPath(route["Path"]),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
