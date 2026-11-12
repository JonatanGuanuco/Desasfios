import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/post.dart';

class ApiService {
  static const String _base = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('$_base/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    }
    throw Exception('Error del servidor: ${response.statusCode}');
  }

  Future<Post> getPostById(int id) async {
    final response = await http.get(Uri.parse('$_base/posts/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error del servidor: ${response.statusCode}');
  }
}