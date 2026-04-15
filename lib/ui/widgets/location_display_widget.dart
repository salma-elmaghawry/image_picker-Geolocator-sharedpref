import 'package:flutter/material.dart';

class LocationDisplayWidget extends StatelessWidget {
  final String address;
  final double? latitude;
  final double? longitude;
  final VoidCallback onGetLocation;

  const LocationDisplayWidget({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.onGetLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onGetLocation,
            icon: const Icon(Icons.location_on, color: Colors.white),
            label: const Text(
              'Get Your Location',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (address.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (latitude != null && longitude != null) ...[
                  Text(
                    'Latitude: $latitude',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Longitude: $longitude',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  address,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
