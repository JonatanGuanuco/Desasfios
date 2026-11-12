import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';

class PostsScreen extends StatefulWidget {
  final String? busqueda;

  const PostsScreen({super.key, this.busqueda});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ApiService _api = ApiService();
  late final Future<List<Post>> _future;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _future = _api.getPosts();
    _controller = TextEditingController(text: widget.busqueda ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Buscar por título...',
            border: InputBorder.none,
          ),
          onSubmitted: (texto) {
            context.go(
              '/posts?search=${Uri.encodeQueryComponent(texto.trim())}',
            );
          },
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final termino = (widget.busqueda ?? '').toLowerCase();
          final posts = snapshot.data!
              .where((p) => p.title.toLowerCase().contains(termino))
              .toList();

          if (posts.isEmpty) {
            return const Center(child: Text('No hay posts con esa búsqueda'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(post.title),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => context.push('/posts/${post.id}'),
              );
            },
          );
        },
      ),
    );
  }
}