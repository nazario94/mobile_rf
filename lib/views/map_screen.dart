import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  final Set<Marker> markers = {
    const Marker(
      markerId: MarkerId("sampleMarker"),
      position: LatLng(0.0, 0.0), // Example LatLng, replace with actual data
      infoWindow: InfoWindow(title: "Signal Strength: -70 dBm"),
    )
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RF Drive Test Map')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
            target: LatLng(0.0, 0.0), zoom: 2),
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
