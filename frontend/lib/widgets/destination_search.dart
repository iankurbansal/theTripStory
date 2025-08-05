import 'dart:async';
import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/api_service.dart';

class DestinationSearchWidget extends StatefulWidget {
  final Function(DestinationSuggestion) onDestinationSelected;
  final String? hintText;
  final String? initialValue;

  const DestinationSearchWidget({
    Key? key,
    required this.onDestinationSelected,
    this.hintText = 'Search destinations...',
    this.initialValue,
  }) : super(key: key);

  @override
  _DestinationSearchWidgetState createState() => _DestinationSearchWidgetState();
}

class _DestinationSearchWidgetState extends State<DestinationSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<DestinationSuggestion> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text.trim();
    
    // Cancel previous debounce timer
    _debounceTimer?.cancel();
    
    if (query.isEmpty) {
      setState(() {
        _suggestions.clear();
        _showSuggestions = false;
        _isLoading = false;
      });
      return;
    }

    // Debounce the search to avoid too many API calls
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _searchDestinations(query);
    });
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      // Hide suggestions when focus is lost - longer delay to allow tap to register
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showSuggestions = false;
          });
        }
      });
    }
  }

  Future<void> _searchDestinations(String query) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    try {
      final suggestions = await ApiService.searchDestinations(query);
      
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions.clear();
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching destinations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onSuggestionTapped(DestinationSuggestion suggestion) {
    // Immediately hide suggestions to prevent double-tap issues
    setState(() {
      _showSuggestions = false;
    });
    
    // Update text field
    _controller.text = suggestion.fullName;
    
    // Remove focus
    _focusNode.unfocus();
    
    // Notify parent with selected suggestion
    widget.onDestinationSelected(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _suggestions.clear();
                            _showSuggestions = false;
                          });
                        },
                      )
                    : null,
            border: const OutlineInputBorder(),
          ),
          onTap: () {
            if (_suggestions.isNotEmpty) {
              setState(() {
                _showSuggestions = true;
              });
            }
          },
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return GestureDetector(
                  onTapDown: (_) => _onSuggestionTapped(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          _getIconForPlaceType(suggestion.type),
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                suggestion.fullName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  IconData _getIconForPlaceType(String type) {
    switch (type.toLowerCase()) {
      case 'country':
        return Icons.flag;
      case 'region':
        return Icons.map;
      case 'locality':
      case 'place':
        return Icons.location_city;
      case 'postcode':
        return Icons.local_post_office;
      default:
        return Icons.place;
    }
  }
}