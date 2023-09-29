import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class AdminOpenStreetMap extends StatefulWidget {
  const AdminOpenStreetMap({super.key});

  @override
  State<AdminOpenStreetMap> createState() => _AdminOpenStreetMapState();
}

class _AdminOpenStreetMapState extends State<AdminOpenStreetMap> {
  final List<LatLng> points = [
    const LatLng(7.113932, 125.624737),
    const LatLng(7.11310, 125.624430),
    const LatLng(7.1200, 125.624737),
  ];

  void _showDialog(BuildContext context, LatLng point) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Point Details'),
          content: Text(
              'Latitude: ${point.latitude}, Longitude: ${point.longitude}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: const LatLng(7.113932, 125.624737),
        zoom: 15.0,
        maxZoom: 18.0,
        minZoom: 5.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: points.map((point) {
            return Marker(
                width: 30.0,
                height: 30.0,
                point: point,
                builder: (ctx) => GestureDetector(
                      onTap: () => _showDialog(context, point),
                      child: Icon(
                        Icons.circle,
                        color: Colors.red[300],
                      ),
                    ));
          }).toList(),
        )
      ],
    );
  }
}