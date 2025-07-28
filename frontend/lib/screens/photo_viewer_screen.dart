import 'package:flutter/material.dart';
import 'trip_details_screen.dart';

class PhotoViewerScreen extends StatefulWidget {
  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  final TextEditingController _commentController = TextEditingController();
  
  // Sample comments data
  List<Comment> comments = [
    Comment(
      id: '1',
      userName: 'Liam Carter',
      userAvatar: 'assets/liam_avatar.jpg',
      text: 'Absolutely stunning view! Makes me want to go back.',
      timeAgo: '2d',
    ),
    Comment(
      id: '2',
      userName: 'Sophia Bennett',
      userAvatar: 'assets/sophia_avatar.jpg',
      text: 'I agree, Liam! The colors are incredible. Did you use a filter?',
      timeAgo: '1d',
    ),
    Comment(
      id: '3',
      userName: 'Liam Carter',
      userAvatar: 'assets/liam_avatar.jpg',
      text: 'No filter, Sophia! Just the natural beauty of the place.',
      timeAgo: '1d',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Get photo data from navigation arguments
    final Photo? photo = ModalRoute.of(context)?.settings.arguments as Photo?;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Photo Section
          _buildPhotoSection(photo),
          
          // Photo Stats
          _buildPhotoStats(photo),
          
          // Comments Section
          Expanded(
            child: _buildCommentsSection(),
          ),
          
          // Add Comment Section
          _buildAddCommentSection(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildPhotoSection(Photo? photo) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Mountain landscape illustration
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF5E6D3), // Warm beige sky
                    Color(0xFFE8D5C4), // Lighter beige
                  ],
                ),
              ),
            ),
            
            // Mountain silhouettes
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(double.infinity, 200),
                painter: MountainPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoStats(Photo? photo) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Likes
          Row(
            children: [
              Icon(Icons.favorite_border, size: 20, color: Colors.grey.shade600),
              SizedBox(width: 4),
              Text(
                '${photo?.likes ?? 23}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          
          SizedBox(width: 24),
          
          // Comments
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey.shade600),
              SizedBox(width: 4),
              Text(
                '${photo?.comments ?? 12}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          
          SizedBox(width: 24),
          
          // Shares
          Row(
            children: [
              Icon(Icons.share_outlined, size: 20, color: Colors.grey.shade600),
              SizedBox(width: 4),
              Text(
                '${photo?.shares ?? 5}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          
          Spacer(),
          
          // Action buttons
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.collections_outlined),
                onPressed: () {
                  // Open collage functionality
                },
                tooltip: 'Collage',
              ),
              IconButton(
                icon: Icon(Icons.videocam_outlined),
                onPressed: () {
                  // Open video functionality
                },
                tooltip: 'Video',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return _buildCommentItem(comments[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: comment.userName == 'Liam Carter' 
                ? Colors.blue.shade200 
                : Colors.orange.shade200,
            child: Text(
              comment.userName[0],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          SizedBox(width: 12),
          
          // Comment content
          Expanded(
            child: