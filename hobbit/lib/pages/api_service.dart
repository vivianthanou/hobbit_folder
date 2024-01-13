import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> fetchUserByUsername(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/api/user/$username'));

    if (response.statusCode == 200) {
      // Parse and return the user data
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      // Handle case when the user is not found
      throw Exception('User not found');
    } else {
      // Handle other errors
      throw Exception('Failed to load user data');
    }
  }
}
