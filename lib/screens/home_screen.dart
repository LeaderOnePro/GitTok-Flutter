import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/repo.dart';
import '../services/api_service.dart';
import '../widgets/repo_item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService(baseUrl: 'http://localhost:3000');
  bool _isLoading = false;
  List<Repo> _repos = [];
  String _currentSince = 'daily';

  @override
  void initState() {
    super.initState();
    _fetchRepos();
  }

  Future<void> _fetchRepos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final repos = await _apiService.fetchTrendingRepos(since: _currentSince);
      setState(() {
        _repos = repos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching repos: $e')),
      );
      setState(() {
        _repos = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitTok', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background (you can replace this with an image)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue, Colors.purple],
              ),
            ),
          ),
          // Frosted glass effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          // Content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, left: 8, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimeRangeButton('今日', 'daily'),
                    _buildTimeRangeButton('本周', 'weekly'),
                    _buildTimeRangeButton('本月', 'monthly'),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _repos.isEmpty
                        ? const Center(child: Text('No trending repositories found.'))
                        : ListView.builder(
                            itemCount: _repos.length,
                            itemBuilder: (context, index) {
                              return RepoItem(repo: _repos[index]);
                            },
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(String text, String since) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentSince = since;
        });
        _fetchRepos();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentSince == since ? Theme.of(context).primaryColor : Colors.grey[300],
        foregroundColor: _currentSince == since ? Colors.white : Colors.black,
      ),
      child: Text(text),
    );
  }
}