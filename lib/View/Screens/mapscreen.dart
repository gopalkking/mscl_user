// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class MapScreen extends StatefulWidget {
  final String lat;
  final String lon;
  const MapScreen({super.key, required this.lat, required this.lon});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;
  LatLng? _initialPosition;
  double lat = 0; 
  double lon = 0; 

  // Initial map position (fallback location)
 // final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Example: San Francisco

  @override
  void initState() {
    super.initState();
     lat = _parseCoordinate(widget.lat, fallback: 9.939093);
    lon = _parseCoordinate(widget.lon, fallback: 78.121719);
    _checkPermission();
    _setInitialLocation();
  }

  double _parseCoordinate(String value, {required double fallback}) {
    if (value.isEmpty) return fallback;
    try {
      return double.parse(value);
    } catch (e) {
      return fallback; // Fallback if parsing fails
    }
  }
 Future<void> _setInitialLocation() async {
    try {
 
      setState(() {
        _initialPosition = LatLng(lat,lon);
        selectedLocation = _initialPosition; // Mark the initial location
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get current location: $e')),
      );
    }
  }

  Future<void> _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      // Move the map to the current location
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 15.0),
      );

      setState(() {
        selectedLocation = currentLocation;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get current location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition!,
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                selectedLocation = location;
              });
               ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected Location: $location')),
           );
            },
            markers: selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: selectedLocation!,
                    ),
                  }
                : {},
          ),
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
            Positioned(
            bottom: 16,
            right: 150,
            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.withOpacity(0.75),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  )
                                ),
                                onPressed: (){
                            if (selectedLocation != null) {
    Navigator.pop(context, selectedLocation); 
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a location on the map')),
    );
  }
                                 
                                }, 
                               child: const Center(
                                 child: Text('Pick Location',style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                  ),),
                               )),
          ),


        ],
      ),
    );
  }
}

