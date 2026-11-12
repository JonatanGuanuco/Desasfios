import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _modoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        modoOscuro: _modoOscuro,
        alCambiarModo: (bool valor) {
          setState(() => _modoOscuro = valor);
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) alCambiarModo;

  const HomeScreen({
    super.key,
    required this.modoOscuro,
    required this.alCambiarModo,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil', 'Configuración'];

  void _irA(int indice) {
    Navigator.pop(context);
    setState(() => _seccion = indice);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final List<Widget> pantallas = [
      InicioScreen(),
      TareasScreen(),
      PerfilScreen(),
      ConfigScreen(
        modoOscuro: widget.modoOscuro,
        alCambiarModo: widget.alCambiarModo,
      ),
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(_titulos[_seccion]),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jonatan Nahuel Guanuco',
                    style: TextStyle(color: cs.onPrimary, fontSize: 16),
                  ),
                  Text(
                    'Técnico en Informática',
                    style: TextStyle(color: cs.onPrimary, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              selected: _seccion == 0,
              selectedTileColor: cs.primaryContainer,
              onTap: () => _irA(0),
            ),
            ListTile(
              leading: Icon(Icons.task_alt),
              title: Text('Tareas'),
              selected: _seccion == 1,
              selectedTileColor: cs.primaryContainer,
              onTap: () => _irA(1),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              selected: _seccion == 2,
              selectedTileColor: cs.primaryContainer,
              onTap: () => _irA(2),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              selected: _seccion == 3,
              selectedTileColor: cs.primaryContainer,
              onTap: () => _irA(3),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar sesión', style: TextStyle(color: cs.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: pantallas[_seccion],
      floatingActionButton: _seccion == 1
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nueva tarea')),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int indice) {
          setState(() => _seccion = indice);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Config.',
          ),
        ],
      ),
    );
  }
}

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '¡Hola, Jonatan!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Organizá tus tareas del día',
                  style: TextStyle(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Estadistica(numero: '12', etiqueta: 'Tareas'),
              Estadistica(numero: '8', etiqueta: 'Hechas'),
              Estadistica(numero: '4', etiqueta: 'Pendientes'),
            ],
          ),
        ],
      ),
    );
  }
}

class Estadistica extends StatelessWidget {
  final String numero;
  final String etiqueta;

  const Estadistica({
    super.key,
    required this.numero,
    required this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          numero,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        Text(etiqueta, style: TextStyle(color: cs.onSurface)),
      ],
    );
  }
}

class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    List<String> tareas = [
      'Estudiar Dart',
      'Hacer el Desafío 3',
      'Subir el proyecto a GitHub',
      'Repasar Material 3',
      'Armar el currículum',
    ];

    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: cs.primary,
            child: Text(
              '${index + 1}',
              style: TextStyle(color: cs.onPrimary),
            ),
          ),
          title: Text(
            tareas[index],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Pendiente'),
          trailing: Icon(Icons.arrow_forward_ios, size: 14),
        );
      },
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          SizedBox(height: 16),
          Text(
            'Jonatan Nahuel Guanuco',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Técnico en Informática',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class ConfigScreen extends StatelessWidget {
  final bool modoOscuro;
  final Function(bool) alCambiarModo;

  const ConfigScreen({
    super.key,
    required this.modoOscuro,
    required this.alCambiarModo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: Text('Modo oscuro'),
          subtitle: Text('Cambia entre tema claro y oscuro'),
          value: modoOscuro,
          onChanged: (bool nuevoValor) {
            alCambiarModo(nuevoValor);
          },
        ),
      ],
    );
  }
}