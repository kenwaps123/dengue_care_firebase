import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class UserDengueHeatMapPage extends StatefulWidget {
  const UserDengueHeatMapPage({super.key});

  @override
  State<UserDengueHeatMapPage> createState() => _UserDengueHeatMapPageState();
}

class _UserDengueHeatMapPageState extends State<UserDengueHeatMapPage> {
  late MapboxMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            onMapCreated: (ctrl) {
              controller = ctrl;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(7.113932, 125.624737),
              zoom: 17,
            ),
            accessToken:
                'pk.eyJ1IjoicmFkb29vMTIzMyIsImEiOiJjbG1leGMzcDUxY3M1M3BqcjA2cW54MzNnIn0.bPXRrLqk3bwMKvKnJdiCyA',
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              heroTag: 'Map',
              child: const Icon(Icons.satellite),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
