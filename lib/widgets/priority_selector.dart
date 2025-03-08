import 'package:flutter/material.dart';
import 'package:delivery_tracking/models/shipment.dart';

class PrioritySelector extends StatelessWidget {
  final ShipmentPriority priority;
  final ValueChanged<ShipmentPriority> onChanged;

  const PrioritySelector({
    super.key,
    required this.priority,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Priority',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ShipmentPriority>(
          segments: const [
            ButtonSegment<ShipmentPriority>(
              value: ShipmentPriority.cost,
              label: Text('Lowest Cost'),
              icon: Icon(Icons.savings_outlined),
            ),
            ButtonSegment<ShipmentPriority>(
              value: ShipmentPriority.balanced,
              label: Text('Balanced'),
              icon: Icon(Icons.balance_outlined),
            ),
            ButtonSegment<ShipmentPriority>(
              value: ShipmentPriority.time,
              label: Text('Fastest'),
              icon: Icon(Icons.speed_outlined),
            ),
          ],
          selected: {priority},
          onSelectionChanged: (Set<ShipmentPriority> selected) {
            onChanged(selected.first);
          },
        ),
      ],
    );
  }
}