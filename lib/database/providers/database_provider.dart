import 'package:mysql1/mysql1.dart';
import 'package:dotenv/dotenv.dart';

class DatabaseProvider {
  static MySqlConnection? _connection;

  static Future<MySqlConnection> getConnection() async {
    if (_connection == null) {
      print('Database connection is null. Establishing a new connection...');
      _connection = await _createConnection();
    } else {
      try {
        // Coba jalankan query sederhana untuk memastikan koneksi aktif
        await _connection!.query('SELECT 1');
        print('Database connection is active.');
      } catch (e) {
        print('Database connection is inactive. Reconnecting...');
        _connection = await _createConnection();
      }
    }
    return _connection!;
  }

  static Future<MySqlConnection> _createConnection() async {
    final dotenv = DotEnv()..load();
    final settings = ConnectionSettings(
      host: dotenv['DB_HOST'] ?? 'localhost',
      port: int.parse(dotenv['DB_PORT'] ?? '3306'),
      user: dotenv['DB_USERNAME'] ?? 'root',
      password: dotenv['DB_PASSWORD'] ?? '',
      db: dotenv['DB_DATABASE'] ?? 'test_api',
    );
    return await MySqlConnection.connect(settings);
  }
}
