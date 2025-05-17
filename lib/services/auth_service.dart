import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // Define the login method
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse(
      'http://localhost:5000/api/auth/login',
    ); // Replace with your backend API URL

    // Prepare data to be sent as a map
    Map<String, String> loginData = {'email': email, 'password': password};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginData), // Convert Map to JSON
      );

      if (response.statusCode == 200) {
        // Assuming the response body is JSON containing a 'message'
        Map<String, dynamic> responseBody = json.decode(response.body);

        return responseBody; // Return the response body
      } else {
        // Handle unsuccessful response (e.g., statusCode != 200)
        return {'message': 'Login failed: ${response.statusCode}'};
      }
    } catch (error) {
      // Handle network or other errors
      return {'message': 'Error: $error'};
    }
  }

  // Define the signup method
  static Future<Map<String, dynamic>> signup(
    String name,
    String phone,
    String email,
    String address,
    String gender,
    String bloodGroup,
    String dob,
    String password,
  ) async {
    final url = Uri.parse(
      'http://localhost:5000/api/auth/signup',
    ); // Replace with your backend API URL

    // Prepare data to be sent as a map
    Map<String, String> signupData = {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'gender': gender,
      'blood_group': bloodGroup,
      'dob': dob,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(signupData), // Convert Map to JSON
      );

      if (response.statusCode == 200) {
        // Assuming the response body is JSON containing a 'message'
        Map<String, dynamic> responseBody = json.decode(response.body);

        return responseBody; // Return the response body
      } else {
        // Handle unsuccessful response (e.g., statusCode != 200)
        return {'message': 'Signup failed: ${response.statusCode}'};
      }
    } catch (error) {
      // Handle network or other errors
      return {'message': 'Error: $error'};
    }
  }
}
