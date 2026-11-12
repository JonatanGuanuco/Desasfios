import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/sesion_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.newspaper, size: 80),
            const SizedBox(height: 16),
            Text(
              'Noticias',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                ref.read(sesionProvider.notifier).iniciar();
                context.go('/');
              },
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}