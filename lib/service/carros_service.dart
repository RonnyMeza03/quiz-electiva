import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CarrosService {
  final _storage = const FlutterSecureStorage();
  final String _key = 'carros';

  // Función para almacenar un carro
  Future<void> almacenarCarro(Map<String, dynamic> carro) async {
    final carros = await obtenerCarros() ?? [];
    // Convierte el Map<String, dynamic> a Map<String, String>
    final carroString = carro.map((key, value) => MapEntry(key, value.toString()));
    carros.add(carroString);
    await _storage.write(key: _key, value: jsonEncode(carros));
  }

  // Función para obtener todos los carros
  Future<List<Map<String, String>>?> obtenerCarros() async {
    final data = await _storage.read(key: _key);
    if (data != null) {
      final decodedData = jsonDecode(data) as List<dynamic>;
      return decodedData.map((item) {
        // Convertir cada elemento a Map<String, String>
        return Map<String, String>.from(item.map((key, value) => 
          MapEntry(key.toString(), value.toString())));
      }).toList();
    }
    return [];
  }

  // Nueva función para obtener un carro por ID desde la API
  Future<Map<String, dynamic>?> obtenerCarroPorId(String id) async {
    final url = 'https://67f7d1812466325443eadd17.mockapi.io/carros/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Error al obtener el carro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}