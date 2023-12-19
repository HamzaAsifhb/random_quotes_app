import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>>? _quoteData; // Use nullable Future
  Color quoteColor = Colors.white;
  Color backgroundColor = Colors.white; // Added background color variable

  // Define the _fetchQuote() function inside the _HomeScreenState class
  Future<Map<String, dynamic>> _fetchQuote() async {
    print("Making API call to https://api.quotable.io/random");
    final response =
        await http.get(Uri.parse("https://api.quotable.io/random"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print("API response: $data");
      print("Quote: ${data['content']}");
      print("Author: ${data['author']}");
      return data;
    } else {
      print("API call failed: ${response.statusCode}");
      throw Exception("Failed to fetch quote");
    }
  }

  Color _generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Future<void> _getNextQuote() async {
    setState(() {
      _quoteData = _fetchQuote(); // Fetch the next quote
      quoteColor = _generateRandomColor(); // Update quote container color
      backgroundColor = _generateRandomColor(); // Update page background color
    });
  }

  @override
  void initState() {
    _quoteData = _fetchQuote(); // Fetch quote on initialization
    quoteColor = Colors.blueGrey;
    backgroundColor = Colors.blueGrey; // Set initial background color
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Quote"),
      ),
      backgroundColor: backgroundColor, // Set the background color
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _quoteData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text("Error fetching quote: ${snapshot.error}");
            } else {
              if (snapshot.hasData) {
                final data = snapshot.data!; // Unwrap data only if available
                return Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        quoteColor.withOpacity(0.8),
                        quoteColor.withOpacity(0.3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data['content'],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "- ${data['author']}",
                          style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: _getNextQuote,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                'Next Quote',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // No quote available yet, show placeholder
                return Text("Fetching a new quote...");
              }
            }
          },
        ),
      ),
    );
  }
}
