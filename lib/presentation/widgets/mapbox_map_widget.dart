import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapboxMapWidget extends StatefulWidget {
  const MapboxMapWidget({super.key});

  @override
  MapboxMapWidgetState createState() => MapboxMapWidgetState();
}

class MapboxMapWidgetState extends State<MapboxMapWidget> {
  MapboxMapController? mapController;
  final String mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? ''; // Aquí obtenemos el token

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Locaciones")),
      body: MapboxMap(
        accessToken: mapboxToken, // Aquí usamos el token obtenido
        initialCameraPosition: const CameraPosition(
          target: LatLng(19.4326, -99.1332), // Ubicación inicial (CDMX)
          zoom: 12.0,
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true, // Habilita la ubicación del usuario
      ),
    );
  }
}
