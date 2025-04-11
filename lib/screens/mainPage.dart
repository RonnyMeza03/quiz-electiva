import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quiz/screens/carros_electricos.dart';
import 'package:quiz/screens/show_car.dart'; // Asegúrate de importar la vista ShowCar

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  String _qrResult = "No se ha escaneado ningún código";

  void _scanQR() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onDetect: (barcode) {
            if (barcode.rawValue != null) {
              setState(() {
                _qrResult = barcode.rawValue!;
              });
              Navigator.pop(context); // Cierra la pantalla del escáner

              // Redirigir a la vista ShowCar con el ID del carro
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowCar(id: _qrResult),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carros Electricos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Bienvenido a la pantalla principal!'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _scanQR,
              child: const Text('Escanear'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarrosElectricosScreen(),
                  ),
                );
              },
              child: const Text('Ver Carros Electricos'),
            ),
            const SizedBox(height: 20),
            Text(
              'Último resultado: $_qrResult',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerScreen extends StatelessWidget {
  final Function(Barcode) onDetect;

  const QRScannerScreen({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código QR'),
      ),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          onDetect(barcode);
        },
      ),
    );
  }
}