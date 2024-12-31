import 'package:daily_quotes/data/api_service.dart';
import 'package:daily_quotes/pages/num_of_quotes.dart';
import 'package:flutter/material.dart';

class UsernamePage extends StatefulWidget {
  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();

  String? _validateUsername(String? value) {
    final usernamePattern = r'^[a-zA-Z0-9_]+$'; // Regex for valid username
    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (!RegExp(usernamePattern).hasMatch(value)) {
      return 'Invalid username. Use only letters, numbers, and underscores';
    }
    return null;
  }

  void _submitUsername() async {
    final apiService = ApiService();
    if (_formKey.currentState?.validate() ?? false) {
      String username = _usernameController.text.trim();
      late var response = apiService.login({'username': username});

      if (response == 'error') {
        null;
      } else {
        // Show a loading indicator
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissal by tapping outside
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        
        // Simulate a delay or perform async tasks
        // await Future.delayed(Duration(seconds: 2)); // Simulating loading time

        // Dismiss the progress indicator
        Navigator.of(context).pop();

        // Navigate to QuoteCountPage
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuoteCountPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello! Welcome to Daily Quotes.',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 26),
                  Text(
                    'Create Your Username',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          // hintText: 'Enter a username (e.g., user_123)',
                          fillColor:
                              Colors.deepPurple[90], // Light lavender shade
                          filled: true, // Enable fill color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                24), // Increase border radius
                            borderSide: BorderSide.none, // Remove border
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20), // Add padding
                        ),
                        style: TextStyle(
                          color: Colors
                              .deepPurple[800], // Medium purple text color
                          fontSize: 16,
                        ),
                        validator: _validateUsername,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _submitUsername,
                child: Text('Continue'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
