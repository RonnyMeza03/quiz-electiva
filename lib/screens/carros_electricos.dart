import 'package:flutter/material.dart';
import 'package:quiz/service/login_service.dart';

class CarrosElectricosScreen extends StatefulWidget {
  @override
  _CarrosElectricosScreenState createState() => _CarrosElectricosScreenState();
}

class _CarrosElectricosScreenState extends State<CarrosElectricosScreen> {
  late Future<List<dynamic>?> _carrosFuture;

  @override
  void initState() {
    super.initState();
    _carrosFuture = LoginService.obtenerCarros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carros Eléctricos'),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: _carrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los carros'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final carros = snapshot.data!;
            return ListView.builder(
              itemCount: carros.length,
              itemBuilder: (context, index) {
                final carro = carros[index];
                return ListTile(
                  title: Text(carro['placa'] ?? 'Sin nombre'),
                  subtitle: Text(carro['conductor'] ?? 'Sin modelo'),
                );
              },
            );
          } else {
            return Center(child: Text('No se encontraron carros'));
          }
        },
      ),
    );
  }
}