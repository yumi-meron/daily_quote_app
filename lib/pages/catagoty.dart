import 'package:daily_quotes/entitiy/quote_entity.dart';
import 'package:daily_quotes/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_quotes/data/api_service.dart';

class CategoryPage extends StatefulWidget {
  final int count = 5;
  final String title; // Title of the category.

  CategoryPage({required this.title});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late PageController _pageController;
  late int currentQuoteIndex; // Current quote index.
  final ApiService apiService = ApiService(); // Instantiate the API service.
  List<Quote> quotes = []; // List to hold fetched quotes.

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadCurrentQuoteIndex();
    _fetchQuotes(); // Fetch quotes on initialization.
  }

  // Generate a unique key for each category.
  String _getCategoryKey() {
    return 'currentQuoteIndex_${widget.title}';
  }

  // Load the index from Shared Preferences for the specific category.
  void _loadCurrentQuoteIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentQuoteIndex = prefs.getInt(_getCategoryKey()) ?? 0;
      _pageController = PageController(initialPage: currentQuoteIndex);
    });
  }

  // Fetch quotes based on the category title.
  Future<void> _fetchQuotes() async {
    try {
      List<Quote> fetchedQuotes = []; // Initialize fetchedQuotes
      // print(widget.title);

      // Fetch quotes based on the category.
      if (widget.title == 'Today\'s Quotes') {
        fetchedQuotes = await apiService.getRandomCategory();
      } else if (widget.title == 'Favorites') {
        fetchedQuotes = await apiService.getFavoriteQuotes();
      } else {
        fetchedQuotes = await apiService.getQuotesByCategory(widget.title);
      }

      // Handle empty list with appropriate messages.
      if (fetchedQuotes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Not available yet')),
        );
        Navigator.pop(context); // Navigate back to the previous screen.
      }

      setState(() {
        quotes = fetchedQuotes; // Store fetched quotes in the list.
      });
    } catch (e) {
      // Handle any errors that may occur during fetching.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quotes: ${e.toString()}')),
      );
    }
  }

  // Save the current quote index to Shared Preferences for the specific category.
  void _saveCurrentQuoteIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_getCategoryKey(), currentQuoteIndex);
  }

  // Toggle favorite status for the current quote.
  Future<void> _toggleFavorite() async {
    try {
      final quote = quotes[currentQuoteIndex]; 
      quote.toggleLiked(); // Toggle the like status immediately
      setState(() {}); // Force a rebuild to update UI

      final response = await apiService.addFavoriteQuote(quote);
      if (!response) {
        setState(() {
          quote.toggleLiked(); // Revert like status if API fails
        });
      } 
    } catch (e) {
      // Show an error message if the favorite operation fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Display the card title at the top.
      ),
      body: Column(
        children: [
          // Show the progress indicator only for "Today's Quotes".
          if (widget.title == 'Today\'s Quotes' && quotes.isNotEmpty) ...[
            LinearProgressIndicator(
              value: (currentQuoteIndex + 1) / quotes.length, //  divide by 5.
            ),
            SizedBox(height: 8),
            Text(
              '${(currentQuoteIndex + 1).clamp(1, quotes.length)}/${quotes.length}', // Ensure the range is [1, 5].
              style: TextStyle(fontSize: 16),
            ),
          ],
          Expanded(
            child: quotes.isEmpty // Check if quotes are loaded.
                ? Center(child: CircularProgressIndicator())
                : PageView.builder(
                    controller: _pageController,
                    itemCount: quotes.length,
                    scrollDirection: Axis.vertical, // Vertical scrolling.
                    onPageChanged: (index) {
                      setState(() {
                        currentQuoteIndex = index.clamp(
                            0,
                            quotes.length -
                                1); // Keep within [0, len(quotes)-1] range.
                      });
                    },
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            quotes[index].text, // index for the quote
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Playfair Display',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                widget.title == 'Home' ? Icons.home : Icons.home_outlined,
              ),
              iconSize: 40,
              color: widget.title == 'Home' ? Colors.purple : null,
              onPressed: () {
                if (widget.title != 'Home') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExplorePage(),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: Icon(
                quotes.isNotEmpty && quotes[currentQuoteIndex].liked
                    ? Icons.favorite
                    : Icons.favorite_outline,
              ),
              iconSize: 40,
              color: quotes.isNotEmpty && quotes[currentQuoteIndex].liked
                  ? Colors.red
                  : null, 
              onPressed: _toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _saveCurrentQuoteIndex(); // Save the current index when the page is disposed.
    _pageController.dispose(); // Dispose of the PageController.
    super.dispose();
  }
}