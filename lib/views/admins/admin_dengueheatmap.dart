import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class AdminDengueHeatMapPage extends StatefulWidget {
  const AdminDengueHeatMapPage({super.key});

  @override
  State<AdminDengueHeatMapPage> createState() => _AdminDengueHeatMapPageState();
}

class _AdminDengueHeatMapPageState extends State<AdminDengueHeatMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: const LatLng(7.113928, 125.624811),
          zoom: 15.5,
        ),
      ),
    );
  }
}
