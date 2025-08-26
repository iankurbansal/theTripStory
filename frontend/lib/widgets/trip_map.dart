import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../models/trip.dart';
import '../models/destination.dart';
import '../services/api_service.dart';
import '../config/environment.dart';

class TripMapWidget extends StatefulWidget {
  final Trip trip;
  final Function(DestinationSuggestion)? onDestinationAdded;

  const TripMapWidget({
    Key? key,
    required this.trip,
    this.onDestinationAdded,
  }) : super(key: key);

  @override
  _TripMapWidgetState createState() => _TripMapWidgetState();
}

class _TripMapWidgetState extends State<TripMapWidget> {
  MapboxMap? mapboxMap;
  List<DestinationSuggestion> tripDestinations = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initializeDestinations();
  }

  void _initializeDestinations() async {
    try {
      // For now, create a sample destination from the trip's main destination
      if (widget.trip.destination != null && widget.trip.destination!.isNotEmpty) {
        // Try to get coordinates for the main destination
        await _searchAndAddDestination(widget.trip.destination!);
      }
    } catch (e) {
      print('Error initializing destinations: $e');
      setState(() {
        error = 'Failed to load destinations';
        isLoading = false;
      });
    }
  }

  Future<void> _searchAndAddDestination(String query) async {
    try {
      final suggestions = await ApiService.searchDestinations(query, limit: 1);
      if (suggestions.isNotEmpty) {
        setState(() {
          tripDestinations.add(suggestions.first);
          isLoading = false;
        });
      } else {
        // If no API results, create a default destination for demo
        setState(() {
          tripDestinations.add(DestinationSuggestion(
            name: query,
            fullName: query,
            type: 'place',
            latitude: 48.8566, // Default to Paris coordinates
            longitude: 2.3522,
          ));
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error searching destination: $e');
      // Add default destination for demo
      setState(() {
        tripDestinations.add(DestinationSuggestion(
          name: query,
          fullName: query,
          type: 'place',
          latitude: 48.8566, // Default to Paris coordinates
          longitude: 2.3522,
        ));
        isLoading = false;
      });
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _addDestinationPins();
    _fitMapToDestinations();
  }

  void _addDestinationPins() async {
    if (mapboxMap == null) return;

    for (int i = 0; i < tripDestinations.length; i++) {
      final destination = tripDestinations[i];
      if (destination.latitude != null && destination.longitude != null) {
        await _addPin(
          destination.latitude!,
          destination.longitude!,
          destination.name,
          i,
        );
      }
    }
  }

  Future<void> _addPin(double lat, double lng, String title, int index) async {
    if (mapboxMap == null) return;

    try {
      // Create point annotation
      final pointAnnotationManager = await mapboxMap!.annotations.createPointAnnotationManager();
      
      final pointAnnotation = PointAnnotationOptions(
        geometry: Point(coordinates: Position(lng, lat)),
      );

      await pointAnnotationManager.create(pointAnnotation);
    } catch (e) {
      print('Error adding pin: $e');
    }
  }

  void _fitMapToDestinations() async {
    if (mapboxMap == null || tripDestinations.isEmpty) return;

    try {
      if (tripDestinations.length == 1) {
        final dest = tripDestinations.first;
        if (dest.latitude != null && dest.longitude != null) {
          await mapboxMap!.setCamera(CameraOptions(
            center: Point(coordinates: Position(dest.longitude!, dest.latitude!)),
            zoom: 12.0,
          ));
        }
      } else {
        // Calculate bounds for multiple destinations
        double minLat = tripDestinations.first.latitude!;
        double maxLat = tripDestinations.first.latitude!;
        double minLng = tripDestinations.first.longitude!;
        double maxLng = tripDestinations.first.longitude!;

        for (final dest in tripDestinations) {
          if (dest.latitude != null && dest.longitude != null) {
            minLat = dest.latitude! < minLat ? dest.latitude! : minLat;
            maxLat = dest.latitude! > maxLat ? dest.latitude! : maxLat;
            minLng = dest.longitude! < minLng ? dest.longitude! : minLng;
            maxLng = dest.longitude! > maxLng ? dest.longitude! : maxLng;
          }
        }

        final bounds = CoordinateBounds(
          southwest: Point(coordinates: Position(minLng, minLat)),
          northeast: Point(coordinates: Position(maxLng, maxLat)),
          infiniteBounds: false,
        );

        await mapboxMap!.setBounds(CameraBoundsOptions(bounds: bounds));
      }
    } catch (e) {
      print('Error fitting map to destinations: $e');
    }
  }

  void _onMapTap(MapContentGestureContext context) async {
    if (mapboxMap == null) return;

    try {
      final point = context.point;
      _showAddDestinationDialog(point.coordinates.lat.toDouble(), point.coordinates.lng.toDouble());
    } catch (e) {
      print('Error handling map tap: $e');
    }
  }

  Widget _buildStaticMapFallback() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB),
            Color(0xFF4682B4),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Destination pins representation
          if (tripDestinations.isNotEmpty)
            ...tripDestinations.asMap().entries.map((entry) {
              int index = entry.key;
              var destination = entry.value;
              return Positioned(
                left: 50.0 + (index * 30.0) % 100,
                top: 60.0 + (index * 25.0) % 80,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              );
            }).toList(),
          
          // Center message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 48,
                  color: Colors.white.withOpacity(0.8),
                ),
                SizedBox(height: 8),
                Text(
                  'Static Map View',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (tripDestinations.isNotEmpty)
                  Text(
                    '${tripDestinations.length} destination${tripDestinations.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDestinationDialog(double lat, double lng) {
    showDialog(
      context: context,
      builder: (context) => AddDestinationDialog(
        latitude: lat,
        longitude: lng,
        onDestinationAdded: (destination) {
          setState(() {
            tripDestinations.add(destination);
          });
          _addPin(lat, lng, destination.name, tripDestinations.length - 1);
          if (widget.onDestinationAdded != null) {
            widget.onDestinationAdded!(destination);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if Mapbox token is available
    if (Environment.mapboxAccessToken.isEmpty) {
      return Container(
        height: 200,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.orange.shade50,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.key_off, size: 48, color: Colors.orange),
              SizedBox(height: 8),
              Text(
                'Mapbox token required',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Interactive map disabled',
                style: TextStyle(
                  color: Colors.orange.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (isLoading) {
      return Container(
        height: 200,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Loading map...'),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Container(
        height: 200,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.red.shade50,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 8),
              Text(error!, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 200,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Create a static map fallback instead of interactive MapWidget
            _buildStaticMapFallback(),
            
            // Trip title overlay
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.trip.destination ?? widget.trip.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            // Destination count overlay
            if (tripDestinations.isNotEmpty)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tripDestinations.length} ${tripDestinations.length == 1 ? 'destination' : 'destinations'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
            // Map info overlay
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Interactive map requires valid Mapbox token',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddDestinationDialog extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Function(DestinationSuggestion) onDestinationAdded;

  const AddDestinationDialog({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.onDestinationAdded,
  }) : super(key: key);

  @override
  _AddDestinationDialogState createState() => _AddDestinationDialogState();
}

class _AddDestinationDialogState extends State<AddDestinationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  void _addDestination() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Create destination suggestion
      final destination = DestinationSuggestion(
        name: _nameController.text.trim(),
        fullName: _descriptionController.text.trim().isEmpty
            ? _nameController.text.trim()
            : _descriptionController.text.trim(),
        type: 'place',
        latitude: widget.latitude,
        longitude: widget.longitude,
      );

      widget.onDestinationAdded(destination);
      Navigator.pop(context);
    } catch (e) {
      print('Error adding destination: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add destination')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Destination'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Destination Name',
              hintText: 'e.g., Eiffel Tower',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'e.g., Famous landmark in Paris',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          SizedBox(height: 8),
          Text(
            'Coordinates: ${widget.latitude.toStringAsFixed(4)}, ${widget.longitude.toStringAsFixed(4)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _addDestination,
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}