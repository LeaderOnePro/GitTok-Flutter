import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repo.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = ''});

  Future<List<Repo>> fetchTrendingRepos({String since = 'daily'}) async {
    final response = await http.get(Uri.parse('$baseUrl/api/trending?since=$since'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Repo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending repos');
    }
  }

  Future<String> fetchSummary(String author, String repo) async {
    final response = await http.get(Uri.parse('$baseUrl/api/summarize?author=$author&repo=$repo'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['summary'];
    } else {
      throw Exception('Failed to load summary');
    }
  }
}