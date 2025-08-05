import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';
import '../models/destination.dart';
import 'auth_service.dart';

class ApiService {
  // Production backend URL - using current stable deployment
  static const String _baseUrl = 'https://thetripstory-production.up.railway.app/api';

  static Future<List<Trip>> getTrips() async {
    try {
      // Make request to production backend
      final response = await _makeRequest('GET', '/trips');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Trip.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trips: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }

  static Future<Trip?> createTrip({
    required String title,
    required String description,
    required String destination,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final body = json.encode({
        'title': title,
        'description': description,
        'destination': destination,
        'startDate': startDate,
        'endDate': endDate,
      });

      final response = await _makeRequest(
        'POST',
        '/trips',
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Trip.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to create trip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating trip: $e');
      return null;
    }
  }

  static Future<Trip?> getTripById(int id) async {
    try {
      final response = await _makeRequest('GET', '/trips/$id');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Trip.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load trip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching trip: $e');
      return null;
    }
  }

  static Future<Trip?> updateTrip(int id, Map<String, dynamic> updateData) async {
    try {
      final body = json.encode(updateData);

      final response = await _makeRequest(
        'PUT',
        '/trips/$id',
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Trip.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to update trip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating trip: $e');
      return null;
    }
  }

  static Future<bool> deleteTrip(int id) async {
    try {
      final response = await _makeRequest('DELETE', '/trips/$id');
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('Error deleting trip: $e');
      return false;
    }
  }

  // Search destinations using Mapbox integration
  static Future<List<DestinationSuggestion>> searchDestinations(String query, {int limit = 5}) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await _makeRequest('GET', '/destinations/search?query=$encodedQuery&limit=$limit');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => DestinationSuggestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search destinations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching destinations: $e');
      return [];
    }
  }

  // Helper method to make HTTP requests to production backend with auth
  static Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    String? body,
    Map<String, String>? headers,
  }) async {
    // Get Firebase ID token for authentication
    final idToken = await AuthService.getIdToken();
    
    print('Making $method request to: $_baseUrl$endpoint');
    print('ID Token present: ${idToken != null}');
    if (idToken != null) {
      print('Token length: ${idToken.length}');
      print('Token starts with: ${idToken.substring(0, 20)}...');
    }
    
    // Prepare headers with authentication
    final authHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (idToken != null) 'Authorization': 'Bearer $idToken',
      ...?headers,
    };

    print('Request headers: ${authHeaders.keys.toList()}');

    final uri = Uri.parse('$_baseUrl$endpoint');
    return await _sendRequest(method, uri, body: body, headers: authHeaders);
  }

  static Future<http.Response> _sendRequest(
    String method,
    Uri uri, {
    String? body,
    Map<String, String>? headers,
  }) async {
    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, body: body, headers: headers);
      case 'PUT':
        return await http.put(uri, body: body, headers: headers);
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }
}