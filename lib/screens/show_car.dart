import 'package:flutter/material.dart';
import 'package:quiz/service/carros_service.dart';
import 'package:quiz/screens/carros_electricos.dart'; // Asegúrate de importar la clase CarrosElectricosScreen

class ShowCar extends StatelessWidget {
  final String id;

  const ShowCar({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final carrosService = CarrosService();

    return FutureBuilder<Map<String, dynamic>?>(
      future: carrosService.obtenerCarroPorId(id), // Llama al servicio para obtener el carro por ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error al cargar el carro: ${snapshot.error}')),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final carro = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalles del Carro'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    carro['imagen'] ?? '',
                    height: 150,
                    width: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 150);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Conductor: ${carro['conductor'] ?? 'Desconocido'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Placa: ${carro['placa'] ?? 'Desconocida'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Cerrar la vista
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Crear un nuevo mapa con los valores convertidos a String
                          Map<String, String> carroParaAlmacenar = {
                            'id': carro['id'].toString(),
                            'conductor': carro['conductor']?.toString() ?? '',
                            'placa': carro['placa']?.toString() ?? '',
                            'imagen': carro['imagen']?.toString() ?? '',
                          };
                          
                          await carrosService.almacenarCarro(carroParaAlmacenar);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Carro añadido exitosamente')),
                          );
                          
                          // Redirigir a CarrosElectricosScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CarrosElectricosScreen(),
                            ),
                          );
                        },
                        child: const Text('Añadir Carro'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No se encontraron datos')),
          );
        }
      },
    );
  }
}