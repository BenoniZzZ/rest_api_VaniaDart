import 'dart:convert';
import 'dart:typed_data'; // Untuk menangani tipe Uint8List
import 'package:bcrypt/bcrypt.dart'; // Untuk hash password
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class AuthController {
  // POST /register
  static Future<Response> register(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // Validasi input
      if (data['username'] == null || data['email'] == null || data['password'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // Hash password
      final hashedPassword = BCrypt.hashpw(data['password'], BCrypt.gensalt());

      final conn = await DatabaseProvider.getConnection();
      print('Connection established: $conn');

      await conn.query(
        'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
        [data['username'], data['email'], hashedPassword],
      );
      print('User registered successfully.');

      return Response(
        201,
        body: jsonEncode({'message': 'User registered successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error registering user: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to register user'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /login
  static Future<Response> login(Request request) async {
  try {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    // Validasi input
    if (data['username'] == null || data['password'] == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'Invalid data'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final conn = await DatabaseProvider.getConnection();
    final results = await conn.query(
      'SELECT user_id, username, email, password FROM users WHERE username = ?',
      [data['username']],
    );

    if (results.isEmpty) {
      return Response(
        401,
        body: jsonEncode({'error': 'Invalid username or password'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final user = results.first;

    // Ambil password dari database
    var hashedPassword = user['password'];

    // Konversi tipe data jika diperlukan
    if (hashedPassword is Uint8List || hashedPassword.runtimeType.toString() == 'Blob') {
      hashedPassword = utf8.decode(hashedPassword);
      print('Password converted from Blob: $hashedPassword');
    } else if (hashedPassword is String) {
      print('Password is already a String: $hashedPassword');
    } else {
      print('Password type is unexpected: ${hashedPassword.runtimeType}');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to process login'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    // Verifikasi password
    if (!BCrypt.checkpw(data['password'], hashedPassword)) {
      return Response(
        401,
        body: jsonEncode({'error': 'Invalid username or password'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.ok(
      jsonEncode({'message': 'Login successful'}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    print('Error logging in user: $e');
    return Response.internalServerError(
      body: jsonEncode({'error': 'Failed to login'}),
      headers: {'Content-Type': 'application/json'},
    );
    }
  }
}
