import 'package:daily_quotes/data/api_service.dart';
import 'package:daily_quotes/pages/catagoty.dart'; // Ensure the import matches your folder structure
import 'package:daily_quotes/pages/username.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExplorePage extends StatelessWidget {
  final ApiService apiService = ApiService();
  final List<String> upperImages = [
    'assets/images/general.jpeg',
    'assets/images/favorite2.jpeg',
  ];

  // Define a list of images corresponding to your categories
  final List<String> categoryImages = [
    'assets/images/general3.jpeg',
    'assets/images/gym.jpeg',
    'assets/images/happiness.jpeg',
    
    'assets/images/motivation2.jpeg',
    'assets/images/self_love.jpeg',
    'assets/images/images.png',
    'assets/images/motivation.jpeg',
    'assets/images/general2.jpeg',
    
  ];

  ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: apiService.getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No categories available."));
            }

            final categories = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Quotes and Favorites Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildCard(
                          context,
                          "Today's Quotes",
                          upperImages[0],
                          () {
                            // Navigate to the CategoryPage for Today's Quotes
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                  title:
                                      'Today\'s Quotes', // Title for Today's Quotes
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16), // Space between cards
                      Expanded(
                        child: _buildCard(
                          context,
                          "Favorites",
                          upperImages[1],
                          () {
                            // Navigate to the CategoryPage for Favorites
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                  title: 'Favorites', // Title for Favorites
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // "For You" Section
                  Text(
                    "For You",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),

                  // Categories Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(
                        {
                          "title": categories[index],
                        },
                        index,
                        context,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to show the logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to clear Shared Preferences and navigate to the login screen
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all shared preferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => UsernamePage()), // Navigate to your login page
    );
  }

  // Reusable method to build the Today's Quotes and Favorites cards
  Widget _buildCard(BuildContext context, String title, String imagePath,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150, // Fixed height for consistent sizing
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
      Map<String, String> category, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to category page with title
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              title: category['title']!,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(categoryImages[index % categoryImages.length]),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category['title']!,
                  style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
