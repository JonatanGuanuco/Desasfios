class Alumno {
  final String nombre;
  final String apellido;
  final int edad;
  final List<double> notas; // 3 notas

  Alumno({
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.notas,
  });

  double calcularPromedio() {
    double suma = notas.reduce((a, b) => a + b);
    return suma / notas.length;
  }

  String estadoFinal() {
    double promedio = calcularPromedio();
    if (promedio >= 6) {
      return 'Aprobado';
    } else if (promedio >= 4) {
      return 'Recuperatorio';
    } else {
      return 'Desaprobado';
    }
  }

  @override
  String toString() {
    return '$nombre $apellido — ${estadoFinal()}';
  }
}

void main() {
  List<Alumno> alumnos = [
    Alumno(nombre: 'Lucas', apellido: 'Gómez', edad: 17, notas: [9.0, 8.5, 10.0]),
    Alumno(nombre: 'Valentin', apellido: 'Martinez', edad: 18, notas: [6.0, 5.0, 7.0]),
    Alumno(nombre: 'Sofía', apellido: 'Ramos', edad: 17, notas: [3.0, 4.0, 2.0]),
    Alumno(nombre: 'Lucia', apellido: 'Díaz', edad: 19 , notas: [7.0, 7.5, 8.0]),
    Alumno(nombre: 'Damaris', apellido: 'Romero', edad: 18, notas: [2.0, 3.0, 5.0]),
  ];

  print('--- Estado de cada alumno ---');
  for (Alumno alumno in alumnos) {
    print('$alumno (promedio: ${alumno.calcularPromedio()})');
  }

  var mejor = alumnos.first;
  for (Alumno alumno in alumnos) {
    if (alumno.calcularPromedio() > mejor.calcularPromedio()) {
      mejor = alumno;
    }
  }
  print('\n--- Mejor promedio ---');
  print('$mejor con ${mejor.calcularPromedio()}');

  int aprobados = 0;
  int desaprobados = 0;
  int recuperatorio = 0;
  for (Alumno alumno in alumnos) {
    String estado = alumno.estadoFinal();
    if (estado == 'Aprobado') {
      aprobados++;
    } else if (estado == 'Desaprobado') {
      desaprobados++;
    } else {
      recuperatorio++;
    }
  }
  print('\n--- Conteo ---');
  print('Aprobados: $aprobados');
  print('Desaprobados: $desaprobados');
  print('En recuperatorio: $recuperatorio');

  alumnos.sort((a, b) {
    if (a.calcularPromedio() < b.calcularPromedio()) {
      return 1;
    } else if (a.calcularPromedio() > b.calcularPromedio()) {
      return -1;
    } else {
      return 0;
    }
  });
  print('\n--- Ranking (mayor a menor promedio) ---');
  for (int i = 0; i < alumnos.length; i++) {
    print('${i + 1}. ${alumnos[i]} — ${alumnos[i].calcularPromedio()}');
  }
}