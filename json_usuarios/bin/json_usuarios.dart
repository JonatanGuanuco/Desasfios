import 'dart:convert';
import 'package:http/http.dart' as http;

class Address {
  final String city;
  final String zipcode;

  Address({
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      zipcode: json['zipcode'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
    );
  }

  @override
  String toString() => '$name ($username) — $email — ${address.city}';
}

Future<List<User>> obtenerUsuarios() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode != 200) {
    throw Exception('Error del servidor: ${response.statusCode}');
  }

  final List<dynamic> lista = jsonDecode(response.body);
  return lista.map((json) => User.fromJson(json)).toList();
}

void main() async {
  const String textoJson = '''
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "city": "Gwenborough",
      "zipcode": "92998-3874"
    }
  }
  ''';

  final Map<String, dynamic> datos = jsonDecode(textoJson);
  final User usuario = User.fromJson(datos);
  print('Usuario desde texto:');
  print(usuario);

  print('');
  print('Descargando lista de usuarios...');
  final List<User> usuarios = await obtenerUsuarios();
  print('Total de usuarios: ${usuarios.length}');
  for (final u in usuarios) {
    print(u);
  }
}