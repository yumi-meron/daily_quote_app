import 'dart:async';
import 'dart:convert'; // Don't forget to import this for jsonEncode
import 'package:daily_quotes/data/api_service.dart';
import 'package:daily_quotes/pages/catagoty.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure you have this for SharedPreferences

class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> categories = [];
  final List<String> selectedCategories = [];
  bool _isLoading = true;

  final List<IconData> categoryIcons = [
    Icons.favorite,
    Icons.fitness_center,
    Icons.sentiment_satisfied,
    Icons.school,
    Icons.mood,
    Icons.people,
    Icons.star,
    Icons.favorite_border,
    Icons.lightbulb,
    Icons.accessibility,
    Icons.wb_sunny,
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<String> fetchedCategories = await _apiService.getCategories();
      setState(() {
        categories = List.generate(fetchedCategories.length, (index) {
          return {
            "title": fetchedCategories[index],
            "icon": categoryIcons[index],
          };
        });
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch categories: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void toggleSelection(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  Future<void> _submitSelectedCategories() async {
    final success = await _apiService.putSelectedCategories(selectedCategories);
    print(success);
    if (success) {
      // Navigate to the CategoryPage with the title "Random" if the update was successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryPage(
            title: 'Today\'s Quotes',
          ),
        ),
      );
    } else {
      // Show an error message if the update failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to update categories. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'What areas of your life would you like to improve?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Choose at least one to tailor your content so it resonates with you',
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final title = category['title'];
                        final icon = category['icon'];
                        final isSelected = selectedCategories.contains(title);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onTap: () => toggleSelection(title),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.deepPurple[300]
                                    : Colors.deepPurple[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.deepPurple[800]!
                                      : Colors.deepPurple[200]!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 16),
                                  Icon(
                                    icon,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.deepPurple[800],
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.deepPurple[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitSelectedCategories, // Call the new method
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
