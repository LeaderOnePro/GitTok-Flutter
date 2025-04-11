import 'dart:convert';
import 'package:flutter/foundation.dart'; // Import foundation for kDebugMode
import 'package:http/http.dart' as http;
import '../models/repository.dart';

enum TrendingSince { daily, weekly, monthly }

class ApiService {
  // TODO: Replace with your actual Vercel deployment URL if different
  final String _baseUrl = "https://gittok-leaderonepro.vercel.app/api"; 

  Future<List<Repository>> fetchTrendingRepositories(TrendingSince since) async {
    String sinceParam;
    switch (since) {
      case TrendingSince.daily:
        sinceParam = 'daily';
        break;
      case TrendingSince.weekly:
        sinceParam = 'weekly';
        break;
      case TrendingSince.monthly:
        sinceParam = 'monthly';
        break;
    }

    final url = Uri.parse('$_baseUrl/trending?since=$sinceParam');
    if (kDebugMode) {
      print('Fetching trending repositories from: $url');
    }

    try {
      final response = await http.get(url);

      if (kDebugMode) {
        print('API Response Status Code: ${response.statusCode}');
        // Avoid printing huge bodies in release mode or if too large
        if (response.bodyBytes.length < 1024) { // Limit printing large bodies
           print('API Response Body: ${utf8.decode(response.bodyBytes)}');
        } else {
           print('API Response Body (first 1KB): ${utf8.decode(response.bodyBytes.sublist(0, 1024))}...');
        }
      }

      if (response.statusCode == 200) {
        // Decode response body safely
        String responseBodyString = utf8.decode(response.bodyBytes); // Store the full string
        dynamic decodedBody;
        try {
          decodedBody = jsonDecode(responseBodyString);
          if (kDebugMode) {
            // Print type even if null
            print('Decoded body runtimeType: ${decodedBody.runtimeType}');
          }
        } catch (e) {
           if (kDebugMode) {
             print('Error decoding JSON: $e');
             // Print the string that caused the error
             print('Original response string causing decode error (first 1KB): ${responseBodyString.substring(0, responseBodyString.length > 1024 ? 1024 : responseBodyString.length)}...');
           }
           throw Exception('Failed to decode JSON response from API.');
        }

        // === Explicit Null Check ===
        if (decodedBody == null) {
           if (kDebugMode) {
             print('jsonDecode returned null.');
             // Print the string that resulted in null
             print('Original response string that resulted in null (first 1KB): ${responseBodyString.substring(0, responseBodyString.length > 1024 ? 1024 : responseBodyString.length)}...');
           }
           // Throw a specific exception if null
           throw Exception('API response decoded to null, expected a List.');
        }
        // === End Null Check ===

        // Check if the decoded body is actually a list
        if (decodedBody is List) {
          if (kDebugMode) {
             print('Decoded body is a List. Proceeding with mapping.');
          }
          List<dynamic> data = decodedBody;
          // Add try-catch around map just in case
          try {
            return data.map((json) => Repository.fromJson(json)).toList();
          } catch (e) {
             if (kDebugMode) {
               print('Error mapping decoded JSON list to Repository objects: $e');
               // Potentially print the problematic json item if possible
             }
             throw Exception('Failed to map API data to Repository objects.');
          }
        } else {
          if (kDebugMode) {
            // Log the actual type received
            print('API did not return a JSON list. Received type: ${decodedBody.runtimeType}');
            print('Received value (first 1KB): ${decodedBody.toString().substring(0, decodedBody.toString().length > 1024 ? 1024 : decodedBody.toString().length)}...');
          }
          throw Exception('API did not return the expected list format.');
        }
      } else {
        // Consider more robust error handling
        throw Exception('Failed to load trending repositories: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
       if (kDebugMode) {
         print('Error during API call: $e');
       }
       // Re-throw the exception or handle it as needed
       // Added more specific error message based on previous steps
       if (e is Exception && e.toString().contains('XMLHttpRequest')) {
          throw Exception('Network error or CORS issue likely. Check API CORS headers and browser console. Original error: $e');
       }
       throw Exception('Failed to fetch trending repositories. Error: $e');
    }
  }

  Future<String> fetchSummary(String owner, String repo) async {
    final response = await http.get(Uri.parse('$_baseUrl/summarize?owner=$owner&repo=$repo'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['summary'] ?? 'Summary not available.'; // Handle cases where summary might be missing
    } else {
      // Consider more robust error handling
      throw Exception('Failed to load summary: ${response.statusCode} ${response.body}');
    }
  }
}