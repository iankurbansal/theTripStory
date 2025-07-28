import 'package:flutter/material.dart';

class PackingListScreen extends StatefulWidget {
  @override
  _PackingListScreenState createState() => _PackingListScreenState();
}

class _PackingListScreenState extends State<PackingListScreen> {
  final TextEditingController _newItemController = TextEditingController();
  
  // Sample packing list data based on the mockup
  List<PackingItem> essentials = [
    PackingItem(name: 'Passport', isChecked: true),
    PackingItem(name: 'Travel Insurance', isChecked: true),
    PackingItem(name: 'Visa (if required)', isChecked: false),
  ];
  
  List<PackingItem> clothing = [
    PackingItem(name: 'Shirts (5)', isChecked: true),
    PackingItem(name: 'Pants (2)', isChecked: true),
    PackingItem(name: 'Underwear (7)', isChecked: true),
    PackingItem(name: 'Socks (7)', isChecked: false),
    PackingItem(name: 'Jacket', isChecked: false),
  ];
  
  List<PackingItem> toiletries = [
    PackingItem(name: 'Toothbrush', isChecked: true),
    PackingItem(name: 'Toothpaste', isChecked: true),
    PackingItem(name: 'Shampoo', isChecked: false),
    PackingItem(name: 'Soap', isChecked: false),
  ];
  
  List<PackingItem> aiSuggestions = [
    PackingItem(name: 'Sunscreen (SPF 30+)', isChecked: false),
    PackingItem(name: 'Sunglasses', isChecked: false),
    PackingItem(name: 'Swimsuit', isChecked: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packing List'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share packing list functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            _buildProgressSection(),
            
            SizedBox(height: 24),
            
            // Essentials section
            _buildPackingSection('Essentials', essentials),
            
            SizedBox(height: 24),
            
            // Clothing section
            _buildPackingSection('Clothing', clothing),
            
            SizedBox(height: 24),
            
            // Toiletries section
            _buildPackingSection('Toiletries', toiletries),
            
            SizedBox(height: 24),
            
            // AI Suggestions section
            _buildPackingSection('AI Suggestions', aiSuggestions),
            
            SizedBox(height: 100), // Extra space for bottom elements
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProgressSection() {
    int totalItems = essentials.length + clothing.length + toiletries.length + aiSuggestions.length;
    int checkedItems = [
      ...essentials,
      ...clothing,
      ...toiletries,
      ...aiSuggestions,
    ].where((item) => item.isChecked).length;
    
    double progress = totalItems > 0 ? checkedItems / totalItems : 0;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Packing Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.blue.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 8),
          Text(
            '$checkedItems of $totalItems items packed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackingSection(String title, List<PackingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        
        ...items.map((item) => _buildPackingItem(item, items)).toList(),
      ],
    );
  }

  Widget _buildPackingItem(PackingItem item, List<PackingItem> itemList) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: item.isChecked,
            onChanged: (bool? value) {
              setState(() {
                item.isChecked = value ?? false;
              });
            },
            activeColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          
          // Item name
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 16,
                decoration: item.isChecked ? TextDecoration.lineThrough : null,
                color: item.isChecked ? Colors.grey.shade500 : Colors.black,
              ),
            ),
          ),
          
          // Delete button
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.grey.shade400,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                itemList.remove(item);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, // Packing List tab is selected
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Packing List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        }
      },
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item'),
          content: TextField(
            controller: _newItemController,
            decoration: InputDecoration(
              hintText: 'Enter item name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _newItemController.clear();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newItemController.text.trim().isNotEmpty) {
                  setState(() {
                    // Add to AI suggestions by default, or you could add category selection
                    aiSuggestions.add(
                      PackingItem(
                        name: _newItemController.text.trim(),
                        isChecked: false,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                  _newItemController.clear();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _newItemController.dispose();
    super.dispose();
  }
}

// Packing item model
class PackingItem {
  String name;
  bool isChecked;

  PackingItem({
    required this.name,
    required this.isChecked,
  });
}