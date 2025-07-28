import 'package:flutter/material.dart';

class DestinationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String tripName = ModalRoute.of(context)?.settings.arguments as String? ?? 'Unknown Trip';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Trip Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              print('Share destinations for $tripName');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Paris Map Section
            _buildEnhancedMapSection(),
            
            SizedBox(height: 32),
            
            // Places to Visit Section
            _buildPlacesToVisitSection(),
            
            SizedBox(height: 32),
            
            // AI Suggestions Section
            _buildAISuggestionsSection(),
            
            SizedBox(height: 100), // Extra space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildEnhancedMapSection() {
    return Container(
      height: 250,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Detailed map background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE8F4F8),
                    Color(0xFFD0E8F0),
                  ],
                ),
              ),
            ),
            
            // Map areas and districts
            Positioned.fill(
              child: CustomPaint(
                painter: DetailedMapPainter(),
              ),
            ),
            
            // Location pins with labels
            Positioned(
              top: 45,
              left: 50,
              child: _buildLabeledPin('Arc de Triomphe', Colors.purple, true),
            ),
            Positioned(
              top: 70,
              left: 150,
              child: _buildLabeledPin('Palais Garnier', Colors.purple, false),
            ),
            Positioned(
              top: 100,
              left: 280,
              child: _buildLabeledPin('Place de la Bastille', Colors.purple, false),
            ),
            Positioned(
              top: 120,
              left: 180,
              child: _buildLabeledPin('Musée d\'Orsay', Colors.purple, false),
            ),
            Positioned(
              bottom: 80,
              left: 90,
              child: _buildLabeledPin('Tour Eiffel', Colors.purple, true),
            ),
            Positioned(
              bottom: 60,
              right: 60,
              child: _buildLabeledPin('Parc de Belleville', Colors.green, false),
            ),
            
            // District labels
            Positioned(
              top: 20,
              left: 20,
              child: _buildDistrictLabel('17TH ARR.'),
            ),
            Positioned(
              top: 50,
              right: 80,
              child: _buildDistrictLabel('19TH ARR.'),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: _buildDistrictLabel('15TH ARR.'),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: _buildDistrictLabel('20TH ARR.'),
            ),
            
            // Paris label
            Positioned(
              top: 110,
              left: 120,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Paris',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledPin(String label, Color color, bool showLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        if (showLabel) SizedBox(height: 2),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistrictLabel(String district) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        district,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildPlacesToVisitSection() {
    final places = [
      {
        'name': 'Eiffel Tower',
        'description': 'Iconic tower with panoramic views',
      },
      {
        'name': 'Louvre Museum',
        'description': 'World-renowned art museum',
      },
      {
        'name': 'Seine River',
        'description': 'Scenic river cruise',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Places to Visit',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          
          ...places.map((place) => _buildPlaceItem(
            place['name']!,
            place['description']!,
            false,
          )),
        ],
      ),
    );
  }

  Widget _buildAISuggestionsSection() {
    final suggestions = [
      {
        'name': 'Notre Dame',
        'description': 'Historic cathedral with stunning architecture',
      },
      {
        'name': 'Montmartre',
        'description': 'Charming neighborhood with cafes and shops',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Suggestions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          
          ...suggestions.map((suggestion) => _buildPlaceItem(
            suggestion['name']!,
            suggestion['description']!,
            true,
          )),
        ],
      ),
    );
  }

  Widget _buildPlaceItem(String name, String description, bool isAISuggestion) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Location icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isAISuggestion ? Colors.grey.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.grey.shade600,
              size: 24,
            ),
          ),
          
          SizedBox(width: 16),
          
          // Place details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
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
              _buildNavItem(Icons.flight, 'Trips', true),
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

// Custom painter for detailed map
class DetailedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final areaPaint = Paint()
      ..color = Colors.green.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw some park areas
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.7, size.height * 0.1, size.width * 0.25, size.height * 0.15),
      areaPaint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.8, size.height * 0.7, size.width * 0.15, size.height * 0.2),
      areaPaint,
    );

    // Draw main roads
    Path road1 = Path();
    road1.moveTo(0, size.height * 0.6);
    road1.quadraticBezierTo(size.width * 0.3, size.height * 0.4, size.width * 0.7, size.height * 0.5);
    road1.quadraticBezierTo(size.width * 0.9, size.height * 0.6, size.width, size.height * 0.4);
    canvas.drawPath(road1, roadPaint);

    Path road2 = Path();
    road2.moveTo(size.width * 0.1, 0);
    road2.quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.6, size.height * 0.3);
    road2.quadraticBezierTo(size.width * 0.8, size.height * 0.4, size.width, size.height * 0.7);
    canvas.drawPath(road2, roadPaint);

    // Draw Seine river
    final riverPaint = Paint()
      ..color = Color(0xFF4682B4).withOpacity(0.6)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    Path river = Path();
    river.moveTo(0, size.height * 0.75);
    river.quadraticBezierTo(size.width * 0.3, size.height * 0.65, size.width * 0.6, size.height * 0.7);
    river.quadraticBezierTo(size.width * 0.8, size.height * 0.75, size.width, size.height * 0.8);
    canvas.drawPath(river, riverPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}