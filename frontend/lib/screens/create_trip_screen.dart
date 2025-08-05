import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/destination.dart';
import '../widgets/destination_search.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  
  DateTime? startDate;
  DateTime? endDate;
  String? selectedTripType;
  bool _isLoading = false;
  DestinationSuggestion? selectedDestination;

  final List<Map<String, dynamic>> tripTypes = [
    {'label': 'Business', 'icon': Icons.business_center, 'color': Colors.blue},
    {'label': 'Vacation', 'icon': Icons.beach_access, 'color': Colors.orange},
    {'label': 'Adventure', 'icon': Icons.terrain, 'color': Colors.green},
    {'label': 'Family', 'icon': Icons.family_restroom, 'color': Colors.purple},
    {'label': 'Solo', 'icon': Icons.person, 'color': Colors.teal},
    {'label': 'Romantic', 'icon': Icons.favorite, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => _saveTrip(),
            child: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Plan Your Next Adventure',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              SizedBox(height: 8),
              
              Text(
                'Fill in the details to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              
              SizedBox(height: 32),
              
              // Trip Title
              _buildInputSection(
                'Trip Title',
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Summer in Europe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF2196F3)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a trip title';
                    }
                    return null;
                  },
                ),
              ),
              
              SizedBox(height: 24),
              
              // Destination
              _buildInputSection(
                'Destination',
                DestinationSearchWidget(
                  hintText: 'Where are you going?',
                  initialValue: selectedDestination?.name,
                  onDestinationSelected: (suggestion) {
                    setState(() {
                      selectedDestination = suggestion;
                      _locationController.text = suggestion.fullName;
                    });
                  },
                ),
              ),
              
              SizedBox(height: 24),
              
              // Description
              _buildInputSection(
                'Description',
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Tell us about your trip...',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF2196F3)),
                    ),
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              
              SizedBox(height: 24),
              
              // Dates
              Row(
                children: [
                  // Start Date
                  Expanded(
                    child: _buildInputSection(
                      'Start Date',
                      TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select date',
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF2196F3)),
                          ),
                        ),
                        onTap: () => _selectStartDate(),
                        validator: (value) {
                          if (startDate == null) {
                            return 'Select start date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 16),
                  
                  // End Date
                  Expanded(
                    child: _buildInputSection(
                      'End Date',
                      TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Select date',
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF2196F3)),
                          ),
                        ),
                        onTap: () => _selectEndDate(),
                        validator: (value) {
                          if (endDate == null) {
                            return 'Select end date';
                          }
                          if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
                            return 'End date must be after start date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              // Trip Type
              _buildInputSection(
                'Trip Type',
                Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: tripTypes.map((type) => _buildTripTypeChip(type)).toList(),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _saveTrip(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Creating...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Create Trip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(String label, Widget input) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        input,
      ],
    );
  }

  Widget _buildTripTypeChip(Map<String, dynamic> type) {
    final bool isSelected = selectedTripType == type['label'];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTripType = isSelected ? null : type['label'];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? type['color'].withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? type['color'] : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type['icon'],
              size: 18,
              color: isSelected ? type['color'] : Colors.grey.shade600,
            ),
            SizedBox(width: 8),
            Text(
              type['label'],
              style: TextStyle(
                color: isSelected ? type['color'] : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );
    
    if (picked != null) {
      setState(() {
        startDate = picked;
        _startDateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );
    
    if (picked != null) {
      setState(() {
        endDate = picked;
        _endDateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _saveTrip() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final trip = await ApiService.createTrip(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          destination: _locationController.text.trim(),
          startDate: _formatDateForApi(startDate!),
          endDate: _formatDateForApi(endDate!),
        );

        if (trip != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Trip "${trip.title}" created successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // Navigate back to dashboard and signal that a trip was created
          Navigator.pop(context, true);
        } else {
          throw Exception('Failed to create trip');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create trip: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}