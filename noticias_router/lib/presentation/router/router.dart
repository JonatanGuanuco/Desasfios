import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/sesion_provider.dart';
import '../screens/detalle_screen.dart';
import '../screens/inicio_screen.dart';
import '../screens/login_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/posts_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final logueado = ref.read(sesionProvider);
      final yendoALogin = state.matchedLocation == '/login';

      if (!logueado && !yendoALogin) return '/login';
      if (logueado && yendoALogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const InicioScreen(),
          ),
          GoRoute(
            path: '/posts',
            builder: (context, state) => PostsScreen(
              busqueda: state.uri.queryParameters['search'],
            ),
          ),
          GoRoute(
            path: '/perfil',
            builder: (context, state) => const PerfilScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/posts/:id',
        builder: (context, state) => DetalleScreen(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );
});

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final ruta = GoRouterState.of(context).uri.path;
    final int indice = ruta.startsWith('/posts')
        ? 1
        : ruta.startsWith('/perfil')
            ? 2
            : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: indice,
        onDestinationSelected: (i) {
          if (i == 0) context.go('/');
          if (i == 1) context.go('/posts');
          if (i == 2) context.go('/perfil');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.newspaper), label: 'Posts'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}