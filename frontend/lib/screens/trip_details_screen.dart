import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../widgets/trip_map.dart';

class TripDetailsScreen extends StatefulWidget {
  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  List<PackingItem> packingItems = [
    PackingItem(name: 'Passport', isChecked: false),
    PackingItem(name: 'Travel Insurance', isChecked: false),
    PackingItem(name: 'Camera', isChecked: false),
  ];

  @override
  Widget build(BuildContext context) {
    final Trip? trip = ModalRoute.of(context)?.settings.arguments as Trip?;
    
    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Trip Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Trip not found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Unable to load trip details',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(trip.title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              print('Share ${trip.title}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive Map Section
            TripMapWidget(
              trip: trip,
              onDestinationAdded: (destination) {
                print('🗺️ Destination added: ${destination.name}');
                // Here you can save the destination to the trip
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added ${destination.name} to trip!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            
            // Trip Info Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        trip.destination ?? 'Destination TBD',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        trip.formattedDates,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (trip.description != null && trip.description!.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Text(
                      trip.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Packing List Section
            _buildPackingListSection(),
            
            SizedBox(height: 32),
            
            // Photo Gallery Section
            _buildPhotoGallerySection(trip),
            
            SizedBox(height: 100), // Extra space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }


  Widget _buildPackingListSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Packing List',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          
          ...packingItems.map((item) => _buildPackingItem(item)),
        ],
      ),
    );
  }

  Widget _buildPackingItem(PackingItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                item.isChecked = !item.isChecked;
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.isChecked ? Colors.blue : Colors.white,
                border: Border.all(
                  color: item.isChecked ? Colors.blue : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: item.isChecked
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                decoration: item.isChecked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallerySection(Trip trip) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photo Gallery',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          
          // Show Unsplash image if available
          if (trip.imageUrl != null) ...[
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  trip.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(Icons.image_not_supported, 
                                   size: 50, 
                                   color: Colors.grey.shade400),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (trip.imageAttribution != null) ...[
              SizedBox(height: 8),
              Text(
                trip.imageAttribution!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: 24),
          ],
          
          // Photo grid
          Row(
            children: [
              // Large photo on left (Eiffel Tower view)
              Expanded(
                flex: 2,
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Container(
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
                        ),
                        // Eiffel Tower silhouette
                        Positioned(
                          bottom: 40,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 80,
                              child: CustomPaint(
                                painter: EiffelTowerPainter(),
                              ),
                            ),
                          ),
                        ),
                        // Arch frame
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 8,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 8),
              
              // Two smaller photos on right
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Top photo (Louvre)
                    Container(
                      height: 116,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange.shade100,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Color(0xFFF4A460),
                            ),
                            // Louvre pyramid
                            Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                child: CustomPaint(
                                  painter: PyramidPainter(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Bottom photo (Seine River)
                    Container(
                      height: 116,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue.shade200,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
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
                            ),
                            // Seine river buildings
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(4, (index) => 
                                    Container(
                                      width: 8,
                                      height: 20 + (index % 2) * 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
              _buildNavItem(Icons.home_outlined, 'Dashboard', false),
              _buildNavItem(Icons.flight, 'Trips', true), // Trip details should show Trips as selected
              _buildNavItem(Icons.photo_outlined, 'Photos', false),
              _buildNavItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
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
    );
  }
}


// Custom painter for Eiffel Tower
class EiffelTowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Simple Eiffel Tower shape
    Path tower = Path();
    tower.moveTo(size.width * 0.5, 0); // Top
    tower.lineTo(size.width * 0.3, size.height * 0.7); // Left base
    tower.lineTo(size.width * 0.7, size.height * 0.7); // Right base
    tower.close();
    
    // Horizontal bars
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.3),
      Offset(size.width * 0.65, size.height * 0.3),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.5),
      paint,
    );
    
    canvas.drawPath(tower, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for Pyramid
class PyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    Path pyramid = Path();
    pyramid.moveTo(size.width * 0.5, 0); // Top
    pyramid.lineTo(0, size.height); // Bottom left
    pyramid.lineTo(size.width, size.height); // Bottom right
    pyramid.close();
    
    canvas.drawPath(pyramid, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Packing item model
class PackingItem {
  String name;
  bool isChecked;

  PackingItem({required this.name, required this.isChecked});
}