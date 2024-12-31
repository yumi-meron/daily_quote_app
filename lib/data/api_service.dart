import 'dart:convert';
import 'package:daily_quotes/entitiy/quote_entity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://quotegen-roan.vercel.app';

  // GET /quotes/:category
  Future<List<Quote>> getQuotesByCategory(String category) async {
    try {
      final url = Uri.parse('$baseUrl/quotes/$category');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map<Quote>((quote) => Quote.fromJson(quote)).toList();
      } else {
        throw Exception('Failed to load quotes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch quotes by category: $e');
    }
  }

  // GET /quotes/random
  Future<List<Quote>> getRandomCategory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) throw Exception('User ID not found');

      final Uri url =
          Uri.parse('$baseUrl/quotes/random').replace(queryParameters: {
        'user_id': userId,
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        dynamic decodedData = jsonDecode(response.body);
        List<dynamic> data = (decodedData is List<dynamic>) ? decodedData : [];
        return data.map<Quote>((quote) => Quote.fromJson(quote)).toList();
      } else {
        throw Exception('Failed to fetch random category quotes');
      }
    } catch (e) {
      throw Exception('Failed to fetch random category quotes: $e');
    }
  }

  // POST /login
  Future<String> login(Map<String, String> credentials) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(credentials),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String userId = responseData['user_id'];
        await _saveUserIdToPreferences(userId);
        return userId;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> _saveUserIdToPreferences(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  // POST /users/:user_id/favorites
  Future<bool> addFavoriteQuote(Quote favoriteQuote) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) throw Exception('User ID not found');

      final url = Uri.parse('$baseUrl/users/$userId/favorites');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'quote_id': favoriteQuote.id}),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      throw Exception('Failed to add favorite quote: $e');
    }
  }

  // GET /users/:user_id/favorites
  Future<List<Quote>> getFavoriteQuotes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) throw Exception('User ID not found');

      final url = Uri.parse('$baseUrl/users/$userId/favorites');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        dynamic decodedData = jsonDecode(response.body);
        List<dynamic> data = (decodedData is List<dynamic>) ? decodedData : [];
        return data.map<Quote>((quote) => Quote.fromJson(quote)).toList();
      } else {
        throw Exception('Failed to fetch favorite quotes');
      }
    } catch (e) {
      throw Exception('Failed to fetch favorite quotes: $e');
    }
  }

  // PUT /users/:user_id/preferences
  Future<bool> putSelectedCategories(List<String> categories) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) throw Exception('User ID not found');

      final url = Uri.parse('$baseUrl/users/$userId/preferences');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'categories': categories}),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Failed to update selected categories: $e');
    }
  }

  // GET /categories
  Future<List<String>> getCategories() async {
    try {
      final url = Uri.parse('$baseUrl/quotes/categories');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return List<String>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // PUT /daily-quotes
  Future<bool> putDailyQuotesSelection(int quoteCount) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      if (userId == null) throw Exception('User ID not found');

      final url = Uri.parse('$baseUrl/users/$userId/preferences');
      print([url, quoteCount, jsonEncode({'limit': quoteCount})]);
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'limit': quoteCount}),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Failed to update daily quotes selection: $e');
    }
  }
}
