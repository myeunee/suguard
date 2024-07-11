import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/drink.dart';
import '../models/cafe.dart';
import '../models/user.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<List<Drink>> fetchDrinks() async {
    final response = await http.get(Uri.parse('$baseUrl/drinks'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((drink) => Drink.fromJson(drink)).toList();
    } else {
      throw Exception('Failed to load drinks');
    }
  }

  Future<Drink> fetchDrink(int drinkId) async {
    final response = await http.get(Uri.parse('$baseUrl/drinks/$drinkId/'), headers: headers);
    if (response.statusCode == 200) {
      return Drink.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load drink');
    }
  }

  Future<List<Cafe>> fetchCafes() async {
    final response = await http.get(Uri.parse('$baseUrl/cafes'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((cafe) => Cafe.fromJson(cafe)).toList();
    } else {
      throw Exception('Failed to load cafes');
    }
  }

  Future<Cafe> fetchCafe(int cafeId) async {
    final response = await http.get(Uri.parse('$baseUrl/cafes/$cafeId/'), headers: headers);
    if (response.statusCode == 200) {
      return Cafe.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load cafe');
    }
  }

  Future<User> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/'), headers: headers);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Drink>> fetchDrinksByCafe(int cafeId) async {
    final response = await http.get(Uri.parse('$baseUrl/cafes/$cafeId/drinks'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((drink) => Drink.fromJson(drink)).toList();
    } else {
      throw Exception('Failed to load drinks');
    }
  }

  Future<List<Drink>> fetchLikedDrinksByCafe(int cafeId) async {
    final response = await http.get(Uri.parse('$baseUrl/cafes/$cafeId/likes'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((drink) => Drink.fromJson(drink)).toList();
    } else {
      throw Exception('Failed to load liked drinks');
    }
  }

  Future<List<Drink>> searchDrinks(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/drinks?search=$query'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((drink) => Drink.fromJson(drink)).toList();
    } else {
      throw Exception('Failed to load drinks');
    }
  }

  Future<List<Drink>> searchDrinksByCafe(int cafeId, String query) async {
    final response = await http.get(Uri.parse('$baseUrl/cafes/$cafeId/drinks?search=$query'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((drink) => Drink.fromJson(drink)).toList();
    } else {
      throw Exception('Failed to load drinks');
    }
  }

  Future<List<Drink>> fetchDrinksByDate(int userId, String date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/consumptions?date=$date'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((consumption) => Drink.fromJson(consumption['drink'])).toList();
    } else {
      throw Exception('Failed to load drinks');
    }
  }

  Future<List<Drink>> fetchFilteredDrinks(String filter) async {
    final response = await http.get(Uri.parse('$baseUrl/drinks?sort_by=$filter'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((drink) => Drink.fromJson(drink)).toList();
    } else {
      throw Exception('Failed to load drinks');
    }
  }

  Future<Map<String, dynamic>> fetchConsumptionStats(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/stats/weekly'), headers: headers);
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load stats');
    }
  }

  Future<List<Map<String, dynamic>>> fetchWeeklySugarIntake(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/stats/weekly_sugar_intake'), headers: headers);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load weekly sugar intake');
    }
  }

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> signup(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'), headers: headers, body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to sign up');
    }
  }

  Future<void> recordConsumption(int userId, int drinkId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/consumptions/'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'drink_id': drinkId,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to record consumption');
    }
  }

  Future<void> likeDrink(int userId, int drinkId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/likes/'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'drink_id': drinkId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to like drink');
    }
  }

  Future<void> unlikeDrink(int userId, int drinkId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/likes/'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'drink_id': drinkId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to unlike drink');
    }
  }

  Future<bool> checkIfLiked(int userId, int drinkId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/likes/check?user_id=$userId&drink_id=$drinkId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['liked'];
    } else {
      throw Exception('Failed to check like status');
    }
  }
}
