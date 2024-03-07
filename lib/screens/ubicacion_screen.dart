import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rentawayapp/models/propiedad.dart'; // Asegúrate de importar el modelo de propiedad correctamente

class UbicacionScreen extends StatefulWidget {
  final Propiedad propiedad;

  const UbicacionScreen({super.key, required this.propiedad});

  @override
  // ignore: library_private_types_in_public_api
  _UbicacionScreenState createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addPropertyMarker();
  }

  void _addPropertyMarker() {
    final propertyLocation = LatLng(
      widget.propiedad.coordenadas['lat'],
      widget.propiedad.coordenadas['lng'],
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(
              "propiedad_${widget.propiedad.id}"), // Asegúrate de que Propiedad tenga un id o usa otro identificador único
          position: propertyLocation,
          infoWindow: InfoWindow(
            title: widget
                .propiedad.titulo, // Asume que Propiedad tiene un campo nombre
            snippet: 'Haz clic para más detalles',
          ),
        ),
      );
    });
  }

  CameraPosition _initialCameraPosition() {
    final lat = widget.propiedad.coordenadas['lat'];
    final lng = widget.propiedad.coordenadas['lng'];
    return CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14.4746,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ubicacion de la Propiedad",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
        iconTheme: const IconThemeData(
          color:
              Colors.white, // Cambia el color de la flecha de regreso a blanco
        ),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialCameraPosition(),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
