import 'destination.dart';

class Trip {
  final int? id;
  final String title;
  final String startDate;
  final String endDate;
  final String? notes;
  final List<Destination> destinations;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final String? imageAttribution;

  Trip({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.notes,
    this.destinations = const [],
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.imageAttribution,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    List<Destination> destinationList = [];
    if (json['destinations'] != null) {
      destinationList = (json['destinations'] as List)
          .map((destinationJson) => Destination.fromJson(destinationJson))
          .toList();
    }

    return Trip(
      id: json['id'],
      title: json['title'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      notes: json['notes'],
      destinations: destinationList,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      imageUrl: json['imageUrl'],
      imageAttribution: json['imageAttribution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
      'destinations': destinations.map((destination) => destination.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'imageUrl': imageUrl,
      'imageAttribution': imageAttribution,
    };
  }

  // Helper methods for UI
  String get formattedDates {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      final startMonth = _getMonthAbbreviation(start.month);
      final endMonth = _getMonthAbbreviation(end.month);
      
      if (start.month == end.month) {
        return '$startMonth ${start.day} - ${end.day}';
      } else {
        return '$startMonth ${start.day} - $endMonth ${end.day}';
      }
    } catch (e) {
      return '$startDate - $endDate';
    }
  }

  String get timeUntilTrip {
    try {
      final start = DateTime.parse(startDate);
      final now = DateTime.now();
      final difference = start.difference(now);
      
      if (difference.isNegative) {
        return 'Past trip';
      } else if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Tomorrow';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).round();
        return weeks == 1 ? '1 week' : '$weeks weeks';
      } else {
        final months = (difference.inDays / 30).round();
        return months == 1 ? '1 month' : '$months months';
      }
    } catch (e) {
      return '';
    }
  }

  bool get isPastTrip {
    try {
      final end = DateTime.parse(endDate);
      return end.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Helper methods for destinations
  String get destinationSummary {
    if (destinations.isEmpty) {
      return 'No destinations';
    }
    if (destinations.length == 1) {
      return destinations.first.name;
    }
    if (destinations.length <= 3) {
      return destinations.map((d) => d.name).join(', ');
    }
    return '${destinations.first.name} + ${destinations.length - 1} more';
  }

  bool get hasDestinations => destinations.isNotEmpty;

  int get destinationCount => destinations.length;

  List<String> get destinationNames => destinations.map((d) => d.name).toList();

  // Compatibility getters for backward compatibility with existing screens
  String? get destination => destinationSummary;
  String? get description => notes;
}