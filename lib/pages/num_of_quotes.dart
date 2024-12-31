import 'package:daily_quotes/data/api_service.dart';
import 'package:daily_quotes/pages/choose_catagories.dart';
import 'package:flutter/material.dart';

class QuoteCountPage extends StatefulWidget {
  @override
  _QuoteCountPageState createState() => _QuoteCountPageState();
}

class _QuoteCountPageState extends State<QuoteCountPage> {
  int? selectedQuoteCount; // Variable to store the selected quote count
  bool isLoading = false; // Variable to manage loading state

  void _navigateToNextPage() async {
    if (selectedQuoteCount != null) {
      ApiService apiService = ApiService();
      setState(() {
        isLoading = true; // Start loading
      });

      // Call the putDailyQuotesSelection method to save the selected quote count
      bool success = await apiService.putDailyQuotesSelection(selectedQuoteCount!);

      setState(() {
        isLoading = false; // Stop loading
      });

      if (success) {
        // If the API call was successful, navigate to the CategorySelectionPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategorySelectionPage(),
          ),
        );
      } else {
        // If the API call failed, show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to save the selected quote count. Please try again.')),
        );
      }
    } else {
      // If no quote count is selected, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a quote count to proceed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<int> quoteOptions = [5, 10, 15, 20, 25]; // Quote options

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Select Quotes Per Day'),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How many quotes would you like to see daily?',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: quoteOptions.length,
                itemBuilder: (context, index) {
                  final count = quoteOptions[index];
                  final isSelected = selectedQuoteCount == count;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedQuoteCount = count;
                      });
                    },
                    child: Container(
                      width: double.infinity, // Full width
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple[300] : Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: isSelected ? Colors.deepPurple[900]! : Colors.deepPurple[200]!,
                          width: 2.0,
                        ),
                      ),
                      child: Text(
                        '$count Quotes',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.deepPurple[900],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : _navigateToNextPage, // Disable button while loading
              child: isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text('Next'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full-width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
