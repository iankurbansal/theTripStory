import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Trip> trips = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final loadedTrips = await ApiService.getTrips();
      setState(() {
        trips = loadedTrips;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load trips: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _refreshTrips() async {
    await _loadTrips();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Trips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshTrips,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 80),
        child: SizedBox(
          width: 160,
          height: 48,
          child: FloatingActionButton.extended(
            onPressed: () => _navigateToCreateTrip(),
            backgroundColor: Color(0xFFE3F2FD),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 20,
            ),
            label: Text(
              'New Trip',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.flight, 'Trips', true, () {}), // Trips should be selected
                _buildNavItem(Icons.photo_outlined, 'Photos', false, () {}),
                _buildNavItem(Icons.person_outline, 'Profile', false, () => Navigator.pushNamed(context, '/profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTrips,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flight_takeoff, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No trips yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Create your first trip to get started!',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final upcomingTrips = trips.where((trip) => !trip.isPastTrip).toList();
    final pastTrips = trips.where((trip) => trip.isPastTrip).toList();

    return ListView(
      children: [
        if (upcomingTrips.isNotEmpty) ...[
          Text(
            'Upcoming',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          ...upcomingTrips.map((trip) => Column(
            children: [
              _buildTripCard(trip),
              SizedBox(height: 20),
            ],
          )),
          SizedBox(height: 12),
        ],
        if (pastTrips.isNotEmpty) ...[
          Text(
            'Past',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          ...pastTrips.map((trip) => Column(
            children: [
              _buildTripCard(trip),
              SizedBox(height: 20),
            ],
          )),
        ],
        SizedBox(height: 100), // Space for FAB
      ],
    );
  }

  // Navigation functions
  void _navigateToTripDetails(Trip trip) {
    print('🎯 Navigating to trip details: ${trip.title}');
    Navigator.pushNamed(context, '/trip-details', arguments: trip);
  }

  void _navigateToCreateTrip() async {
    print('➕ Navigating to create trip');
    final result = await Navigator.pushNamed(context, '/create-trip');
    // If a trip was created, refresh the list
    if (result == true) {
      _loadTrips();
    }
  }

  // Trip card builder
  Widget _buildTripCard(Trip trip) {
    final colors = [
      Color(0xFF87CEEB),
      Color(0xFFDEB887), 
      Color(0xFF5F9EA0),
      Color(0xFFFFB6C1),
      Color(0xFF98FB98),
    ];
    final icons = [
      Icons.waves,
      Icons.landscape, 
      Icons.location_city,
      Icons.beach_access,
      Icons.forest,
    ];
    
    final colorIndex = trip.id != null ? trip.id! % colors.length : 0;
    final color = colors[colorIndex];
    final icon = icons[colorIndex];

    return _buildSmallTripCard(
      timeLeft: trip.isPastTrip ? null : trip.timeUntilTrip,
      title: trip.title,
      hasCollaborators: false, // TODO: Add collaborators support
      location: trip.destination ?? 'Location TBD',
      dates: trip.formattedDates,
      collaborators: null,
      imageUrl: trip.imageUrl,
      imageAttribution: trip.imageAttribution,
      fallbackColor: color,
      fallbackIcon: icon,
      onTap: () => _navigateToTripDetails(trip),
    );
  }

  Widget _buildSmallTripCard({
    String? timeLeft,
    required String title,
    required bool hasCollaborators,
    required String location,
    required String dates,
    String? collaborators,
    String? imageUrl,
    String? imageAttribution,
    required Color fallbackColor,
    required IconData fallbackIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            // Left side - Trip details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time left
                  if (timeLeft != null) ...[
                    Text(
                      timeLeft,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                  
                  // Title with collaborator icon
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      if (hasCollaborators) ...[
                        SizedBox(width: 8),
                        Icon(
                          Icons.people,
                          size: 18,
                          color: Color(0xFF2196F3),
                        ),
                      ],
                    ],
                  ),
                  
                  SizedBox(height: 4),
                  
                  // Location and dates
                  Text(
                    '$location · $dates',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  // Collaborators info
                  if (collaborators != null) ...[
                    SizedBox(height: 4),
                    Text(
                      collaborators,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            SizedBox(width: 16),
            
            // Right side - Trip image
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: fallbackColor,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 120,
                            height: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: fallbackColor,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: fallbackColor,
                                ),
                                child: Icon(
                                  fallbackIcon,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              );
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: fallbackColor,
                            ),
                            child: Icon(
                              fallbackIcon,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                  ),
                  if (imageAttribution != null)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Unsplash',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFF2196F3) : Colors.grey.shade600,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Color(0xFF2196F3) : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}