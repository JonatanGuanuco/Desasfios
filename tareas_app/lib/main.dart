import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class Tarea {
  final String titulo;
  final bool completada;
  final String prioridad;

  const Tarea({
    required this.titulo,
    this.completada = false,
    this.prioridad = 'media',
  });
}

class TasksState {
  final List<Tarea> tareas;

  const TasksState({this.tareas = const []});

  int get pendientes => tareas.where((t) => !t.completada).length;

  int get completadas => tareas.length - pendientes;
}

class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  void agregar(String titulo, String prioridad) {
    state = TasksState(
      tareas: [...state.tareas, Tarea(titulo: titulo, prioridad: prioridad)],
    );
  }

  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);
    state = TasksState(tareas: nuevas);
  }

  void toggleCompletada(int indice) {
    final nuevas = [...state.tareas];
    final t = nuevas[indice];
    nuevas[indice] = Tarea(
      titulo: t.titulo,
      completada: !t.completada,
      prioridad: t.prioridad,
    );
    state = TasksState(tareas: nuevas);
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);

Color colorPrioridad(String prioridad) {
  if (prioridad == 'alta') {
    return Colors.red;
  } else if (prioridad == 'media') {
    return Colors.orange;
  } else {
    return Colors.green;
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 77, 26, 22),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Yo'];

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
    ];

    return Scaffold(
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
                    'Jonatan Guanuco',
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
              title: Text('Casa'),
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
              title: Text('Yo'),
              selected: _seccion == 2,
              selectedTileColor: cs.primaryContainer,
              onTap: () => _irA(2),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar', style: TextStyle(color: cs.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: pantallas[_seccion],
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
        ],
      ),
    );
  }
}

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final state = ref.watch(tasksProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Mis tareas pendientes', style: TextStyle(fontSize: 18)),
          Text(
            '${state.pendientes}',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Completadas: ${state.completadas}',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          Text(
            'Total: ${state.tareas.length}',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController _tareaCtrl = TextEditingController();
  String _prioridad = 'media';

  @override
  void dispose() {
    _tareaCtrl.dispose();
    super.dispose();
  }

  void _agregar() {
    String texto = _tareaCtrl.text.trim();
    if (texto.isEmpty) {
      return;
    }
    ref.read(tasksProvider.notifier).agregar(texto, _prioridad);
    _tareaCtrl.clear();
  }

  Widget _botonPrioridad(String valor, String texto, Color color) {
    bool elegido = _prioridad == valor;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => _prioridad = valor),
        style: ElevatedButton.styleFrom(
          backgroundColor: elegido ? color : null,
          foregroundColor: elegido ? Colors.white : null,
        ),
        child: Text(texto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _tareaCtrl,
                decoration: InputDecoration(
                  labelText: 'Nueva tarea',
                  hintText: 'Escribí una tarea',
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _botonPrioridad('alta', 'Alta', Colors.red),
                  SizedBox(width: 8),
                  _botonPrioridad('media', 'Media', Colors.orange),
                  SizedBox(width: 8),
                  _botonPrioridad('baja', 'Baja', Colors.green),
                ],
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _agregar,
                icon: Icon(Icons.add),
                label: Text('Agregar tarea'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.tareas.length,
            itemBuilder: (context, i) {
              final t = state.tareas[i];
              return ListTile(
                leading: Checkbox(
                  value: t.completada,
                  onChanged: (bool? nuevoValor) {
                    ref.read(tasksProvider.notifier).toggleCompletada(i);
                  },
                ),
                title: Text(
                  t.titulo,
                  style: TextStyle(
                    decoration: t.completada
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  'Prioridad ${t.prioridad}',
                  style: TextStyle(
                    color: colorPrioridad(t.prioridad),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(tasksProvider.notifier).eliminar(i);
                  },
                ),
              );
            },
          ),
        ),
      ],
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