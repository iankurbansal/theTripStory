import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';

class ApiService {
  // Use the backend service URL from nginx proxy or direct backend
  static const String _baseUrl = 'http://localhost/api';
  static const String _fallbackUrl = 'http://localhost:8080/api';

  static Future<List<Trip>> getTrips() async {
    try {
      // Try nginx proxy first, then fallback to direct backend
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

  // Helper method to make HTTP requests with fallback
  static Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    String? body,
    Map<String, String>? headers,
  }) async {
    // Try nginx proxy first
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _sendRequest(method, uri, body: body, headers: headers);
      return response;
    } catch (e) {
      print('Nginx proxy failed, trying direct backend: $e');
      
      // Fallback to direct backend
      final uri = Uri.parse('$_fallbackUrl$endpoint');
      return await _sendRequest(method, uri, body: body, headers: headers);
    }
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