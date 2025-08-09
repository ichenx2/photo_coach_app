import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://127.0.0.1:8000/api'; 

  // 取得所有技能清單
  static Future<List<dynamic>> fetchSkills() async {
    final response = await http.get(Uri.parse('$baseUrl/skills'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('無法取得技能資料');
    }
  }

  // 使用者的技能進度清單
  static Future<List<dynamic>> fetchUserSkills(int userId) async {
    final url = Uri.parse('http://10.0.2.2:8000/learning_records/users/$userId/skills');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } 
    else {
      throw Exception('Failed to load user skills');
    }
  }
}
