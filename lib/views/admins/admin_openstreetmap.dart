import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denguecare_firebase/views/admins/admin_dataviz.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final PanelController _panelController = PanelController();
final mapController = MapController();

class AdminOpenStreetMap extends StatefulWidget {
  const AdminOpenStreetMap({super.key});

  @override
  State<AdminOpenStreetMap> createState() => _AdminOpenStreetMapState();
}

class _AdminOpenStreetMapState extends State<AdminOpenStreetMap> {
  late Map<String, LatLng> purokList = {};
  int purokCounter = 0;

  @override
  void initState() {
    super.initState();
    // mapController = MapController();
    fetchData();
  }

  // final List<LatLng> points = [
  //   const LatLng(7.113932, 125.624737),
  //   const LatLng(7.11310, 125.624430),
  //   const LatLng(7.1200, 125.624737),
  // ];

  Future<void> fetchData() async {
    try {
      PurokData result = await fetchPurokData();
      Map<String, LatLng> dataMap = result.data;
      int uniquePurokCount = result.uniquePurokCount;
      setState(() {
        purokList = dataMap;
        purokCounter = uniquePurokCount;
      });

      // Now you can use dataMap and uniquePurokCount as needed
      print('Data Map: $dataMap');
      print('Unique Purok Count: $uniquePurokCount');
    } catch (e) {
      // Handle errors
      print('Error fetching data: $e');
    }
  }

  void _showDialog(BuildContext context, LatLng point, String purokName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Point Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Coordinate Count: $purokCounter ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Purok: $purokName ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Latitude: ${point.latitude}, Longitude: ${point.longitude}',
              ),
            ],
          ),
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
    return Scaffold(
      body: SlidingUpPanel(
        backdropEnabled: true,
        backdropTapClosesPanel: true,
        controller: _panelController,
        panel: _floatingPanel(),
        collapsed: _floatingCollapsed(),
        minHeight: 50.0,
        color: const Color.fromRGBO(255, 255, 255, 0),
        body: FlutterMap(
          mapController: mapController,
          options: const MapOptions(
            initialCenter: LatLng(7.113932, 125.624737),
            initialZoom: 15.0,
            maxZoom: 18.0,
            minZoom: 5.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: purokList.entries.map((entry) {
                return Marker(
                  child: GestureDetector(
                    onTap: () => _showDialog(context, entry.value, entry.key),
                    child: Icon(
                      Icons.circle,
                      color: Colors.red[400],
                    ),
                  ),
                  width: 30.0,
                  height: 30.0,
                  point: entry.value,
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

Widget _floatingCollapsed() {
  return GestureDetector(
    onTap: () {
      if (_panelController.isPanelOpen) {
        _panelController.close();
      } else {
        _panelController.open();
      }
    },
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      child: Center(
        child: Text(
          "Filter settings",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget _floatingPanel() {
  return Container(
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20.0,
            color: Colors.grey,
          ),
        ]),
    child: Center(
      child: Text(
        "This is the SlidingUpPanel when open",
        style: GoogleFonts.poppins(),
      ),
    ),
  );
}

Future<PurokData> fetchPurokData() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('reports').get();

    Map<String, LatLng> dataMap = {};
    Set<String> uniquePuroks = {};

    for (var document in querySnapshot.docs) {
      final purok = document['purok'];
      final latitude = document['latitude'];
      final longitude = document['longitude'];
      final coordinates = LatLng(latitude, longitude);

      dataMap[purok] = coordinates;
      uniquePuroks.add(purok);
    }

    int uniquePurokCount = uniquePuroks.length;

    return PurokData(dataMap, uniquePurokCount);
  } catch (e) {
    print('Error fetching data: $e');
    rethrow; // You might want to handle errors differently based on your use case
  }
}

class PurokData {
  final Map<String, LatLng> data;
  final int uniquePurokCount;

  PurokData(this.data, this.uniquePurokCount);
}
