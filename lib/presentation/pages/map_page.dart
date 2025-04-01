import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState(); // Cambiado a MapPageState
}

class MapPageState extends State<MapPage> { // Cambiado a MapPageState
  late MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: MapboxMap(
        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'], // Token de Mapbox
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Coordenadas de ejemplo (San Francisco)
          zoom: 12.0,
        ),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
