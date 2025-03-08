import 'package:flutter/material.dart';
import 'package:delivery_tracking/models/shipment.dart';

class TransportModeSelector extends StatelessWidget {
  final TransportMode? selectedMode;
  final ValueChanged<TransportMode?> onChanged;

  const TransportModeSelector({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Transport Mode (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('Air'),
              selected: selectedMode == TransportMode.air,
              onSelected: (bool selected) {
                onChanged(selected ? TransportMode.air : null);
              },
              avatar: const Icon(Icons.flight_outlined),
            ),
            FilterChip(
              label: const Text('Sea'),
              selected: selectedMode == TransportMode.sea,
              onSelected: (bool selected) {
                onChanged(selected ? TransportMode.sea : null);
              },
              avatar: const Icon(Icons.directions_boat_outlined),
            ),
            FilterChip(
              label: const Text('Land'),
              selected: selectedMode == TransportMode.land,
              onSelected: (bool selected) {
                onChanged(selected ? TransportMode.land : null);
              },
              avatar: const Icon(Icons.local_shipping_outlined),
            ),
          ],
        ),
      ],
    );
  }
}