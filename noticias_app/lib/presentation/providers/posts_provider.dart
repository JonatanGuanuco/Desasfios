import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post.dart';

class PostsNotifier extends Notifier<List<Post>> {
  @override
  List<Post> build() => [];

  void guardar(List<Post> posts) {
    state = posts;
  }
}

final postsProvider = NotifierProvider<PostsNotifier, List<Post>>(PostsNotifier.new);