import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '검색',
                hintText: '오늘 뭐먹지?',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // TODO: Implement your search logic here
    // This is where you would typically make an API call or query a database
    // based on the _searchQuery and display the search results.

    // For demonstration purposes, let's assume there are no search results
    final bool hasData = false;

    return Center(
      child: hasData
          ? ListView()
          : Text(
        '검색 결과 없음',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}