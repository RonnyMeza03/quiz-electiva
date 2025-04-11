import 'package:flutter/material.dart';
import 'package:quiz/service/carros_service.dart';

class CarrosElectricosScreen extends StatefulWidget {
  const CarrosElectricosScreen({super.key});

  @override
  _CarrosElectricosScreenState createState() => _CarrosElectricosScreenState();
}

class _CarrosElectricosScreenState extends State<CarrosElectricosScreen> {
  late Future<List<Map<String, String>>?> _carrosFuture;
  final CarrosService _carrosService = CarrosService();

  @override
  void initState() {
    super.initState();
    _carrosFuture = _carrosService.obtenerCarros(); // Consumir el servicio para obtener los carros
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carros Eléctricos'),
      ),
      body: FutureBuilder<List<Map<String, String>>?>(
        future: _carrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los carros'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final carros = snapshot.data!;
            return ListView.builder(
              itemCount: carros.length,
              itemBuilder: (context, index) {
                final carro = carros[index];
                return ListTile(
                  leading: carro['imagen'] != null
                      ? Image.network(
                          carro['imagen']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported);
                          },
                        )
                      : const Icon(Icons.car_rental),
                  title: Text(carro['placa'] ?? 'Sin placa'),
                  subtitle: Text(carro['conductor'] ?? 'Sin conductor'),
                  onTap: () {
                    // Navegar a la pantalla de detalles del carro
                    Navigator.pushNamed(
                      context,
                      '/show_car',
                      arguments: carro['id'],
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No se encontraron carros'));
          }
        },
      ),
    );
  }
}