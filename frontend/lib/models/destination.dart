class Destination {
  final int? id;
  final String name;
  final String? fullName;
  final String? type;
  final double? latitude;
  final double? longitude;
  final String? description;
  final int? orderIndex;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Destination({
    this.id,
    required this.name,
    this.fullName,
    this.type,
    this.latitude,
    this.longitude,
    this.description,
    this.orderIndex,
    this.createdAt,
    this.updatedAt,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'] ?? '',
      fullName: json['fullName'],
      type: json['type'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      description: json['description'],
      orderIndex: json['orderIndex'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'orderIndex': orderIndex,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods for UI
  String get displayName => fullName ?? name;
  
  bool get hasCoordinates => latitude != null && longitude != null;
  
  String get coordinatesString => hasCoordinates 
      ? '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}'
      : 'No coordinates';

  // Create destination from Mapbox suggestion
  factory Destination.fromMapboxSuggestion(Map<String, dynamic> suggestion) {
    return Destination(
      name: suggestion['name'] ?? '',
      fullName: suggestion['fullName'],
      type: suggestion['type'],
      latitude: suggestion['latitude']?.toDouble(),
      longitude: suggestion['longitude']?.toDouble(),
    );
  }
}

// For Mapbox search suggestions
class DestinationSuggestion {
  final String name;
  final String fullName;
  final String type;
  final double? latitude;
  final double? longitude;

  DestinationSuggestion({
    required this.name,
    required this.fullName,
    required this.type,
    this.latitude,
    this.longitude,
  });

  factory DestinationSuggestion.fromJson(Map<String, dynamic> json) {
    return DestinationSuggestion(
      name: json['name'] ?? '',
      fullName: json['fullName'] ?? '',
      type: json['type'] ?? 'place',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fullName': fullName,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Convert to Destination for adding to trip
  Destination toDestination() {
    return Destination(
      name: name,
      fullName: fullName,
      type: type,
      latitude: latitude,
      longitude: longitude,
    );
  }
}