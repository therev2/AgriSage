import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:agrisage/ColorPage.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  List<LatLng> _polygonPoints = [];
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  bool _drawingMode = false;

  // Default camera position (center of India)
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 5.0,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Check if permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get current location
    locationData = await location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(locationData.latitude!, locationData.longitude!),
          14.0,
        ),
      );
    }
  }

  void _onMapTap(LatLng location) {
    if (!_drawingMode) return;

    setState(() {
      // Add point to polygon
      _polygonPoints.add(location);

      // Add marker at the tapped location
      _markers.add(
        Marker(
          markerId: MarkerId('point_${_polygonPoints.length}'),
          position: location,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );

      // Update polygon if we have at least 3 points
      if (_polygonPoints.length >= 3) {
        _updatePolygon();
      }
    });
  }

  void _updatePolygon() {
    _polygons = {
      Polygon(
        polygonId: const PolygonId('farm_area'),
        points: _polygonPoints,
        fillColor: Colors.green.withValues(alpha: 0.3),
        strokeColor: Colors.green,
        strokeWidth: 2,
      ),
    };
  }

  void _resetDrawing() {
    setState(() {
      _polygonPoints = [];
      _markers = {};
      _polygons = {};
    });
  }

  void _toggleDrawingMode() {
    setState(() {
      _drawingMode = !_drawingMode;
      if (!_drawingMode) {
        // If turning off drawing mode, finalize the polygon
        if (_polygonPoints.length >= 3) {
          _updatePolygon();
        }
      }
    });
  }

  void _saveLocation() async {
    if (_polygonPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please select at least 3 points to define your farm area'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // // Create a map of the polygon points
    // List<Map<String, dynamic>> polygonPoints = _polygonPoints.map((point) => {
    //   'latitude': point.latitude,
    //   'longitude': point.longitude,
    // }).toList();
    //
    // // Create a document with the farm area data
    // Map<String, dynamic> farmArea = {
    //   'polygonPoints': polygonPoints,
    //   'timestamp': DateTime.now().millisecondsSinceEpoch,
    // };

    // TODO :- Save the farm area to Firestore
    try {
      // Save the farm area to Firestore
      // await _firestore.collection('farm_areas').add(farmArea);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farm area saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save farm area: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  double _calculateAreaInHectares() {
    if (_polygonPoints.length < 3) return 0;

    // Simple approximation for small areas
    // For more accurate calculation, use geodesic libraries
    double area = 0;
    for (int i = 0; i < _polygonPoints.length; i++) {
      int j = (i + 1) % _polygonPoints.length;
      area += _polygonPoints[i].latitude * _polygonPoints[j].longitude;
      area -= _polygonPoints[j].latitude * _polygonPoints[i].longitude;
    }
    area = area.abs() * 111319.9 * 111319.9 / 10000; // Convert to hectares
    return area;
  }

  @override
  Widget build(BuildContext context) {
    final isFirstPoint = _polygonPoints.isEmpty;
    final bool hasValidPolygon = _polygonPoints.length >= 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Farm Area',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_drawingMode ? Icons.edit_off : Icons.edit),
            color: Colors.white,
            onPressed: _toggleDrawingMode,
            tooltip: _drawingMode ? 'Exit Drawing Mode' : 'Enter Drawing Mode',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            onPressed: _resetDrawing,
            tooltip: 'Reset Drawing',
          ),
        ],
        backgroundColor: ColorPage.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                _drawingMode
                    ? isFirstPoint
                        ? 'Tap the map to place your first boundary point'
                        : 'Continue tapping to add more boundary points (min 3)'
                    : 'Press the pencil icon to begin marking your farm boundary',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorPage.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.hybrid,
              markers: _markers,
              polygons: _polygons,
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
                _getCurrentLocation();
              },
              onTap: _onMapTap,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                _polygonPoints.isNotEmpty
                    ? Column(
                        children: [
                          Text(
                            'Farm Area: ${_calculateAreaInHectares().toStringAsFixed(2)} hectares',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Boundary Points: ${_polygonPoints.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPage.lightYellowGold1,
                      foregroundColor: ColorPage.textColor,
                      elevation: 2,
                      shadowColor: ColorPage.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'SAVE FARM AREA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
