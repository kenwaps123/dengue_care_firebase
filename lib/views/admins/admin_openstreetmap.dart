import 'package:cloud_firestore/cloud_firestore.dart';
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
              markers: points.map((point) {
                return Marker(
                  child: GestureDetector(
                    onTap: () => _showDialog(context, point),
                    child: Icon(
                      Icons.circle,
                      color: Colors.red[300],
                    ),
                  ),
                  width: 30.0,
                  height: 30.0,
                  point: point,
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

class DataFromFirebase extends StatelessWidget {
  const DataFromFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('reports').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> dataForMap =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return null;
          },
        );
      },
    );
  }
}
