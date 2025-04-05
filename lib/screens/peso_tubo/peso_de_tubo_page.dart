import 'package:flutter/material.dart';



class PesodeTuboPage extends StatefulWidget {
  const PesodeTuboPage({super.key});
  @override
  PesodeTuboPageState createState() => PesodeTuboPageState();
}

class PesodeTuboPageState extends State<PesodeTuboPage> {
  double diametroPulgadas = 0.0; // Entrada en pulgadas
  double espesorMM = 0.0; // Entrada en mm
  double longitudM = 0.0; // Entrada en metros
  double _peso = 0.0; // Resultado en kg

  final double densidadAcero = 7850; // Densidad en kg/m³

  // Controladores para los TextFields
  final TextEditingController _diametroController = TextEditingController();
  final TextEditingController _espesorController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();

  // Método para calcular el peso del tubo
  void _calcular() {
    setState(() {
      double dpulg = double.tryParse(_diametroController.text) ?? 0.0;
      double emm = double.tryParse(_espesorController.text) ?? 0.0;
      double lm = double.tryParse(_longitudController.text) ?? 0.0;

      if (dpulg > 0 && emm > 0 && lm > 0) {
        // Conversión de unidades
        double dmm = dpulg * 25.4; // Convertir pulgadas a mm
        double dm = dmm / 1000; // Convertir mm a metros
        double em = emm / 1000; // Convertir mm a metros
        double ddm = dm - 2 * em; // Diámetro interno

        // Cálculo del área de la sección transversal
        double area = (3.1416 / 4) * (dm * dm - ddm * ddm);

        // Cálculo del peso del tubo
        _peso = area * lm * densidadAcero;
      } else {
        _peso = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Peso de Tubo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen representativa de la función
            Image.asset(
              'assets/icon/pesotuboimg.png', // Asegúrate de que la imagen esté en la carpeta correcta
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 100, color: Colors.red);
              },
            ),
            SizedBox(height: 20),

            // Descripción de la función
            Text(
              'Introduce el diámetro (en pulgadas), el espesor (en mm) y la longitud (en metros) '
              'para calcular el peso del tubo de acero.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Campo de entrada: Diámetro del tubo en pulgadas
            TextField(
              controller: _diametroController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Diámetro exterior (pulgadas)',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.grey[300]),
              cursorColor: Colors.grey[300],
            ),
            SizedBox(height: 20),

            // Campo de entrada: Espesor del tubo en mm
            TextField(
              controller: _espesorController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Espesor del tubo (mm)',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.grey[300]),
              cursorColor: Colors.grey[300],
            ),
            SizedBox(height: 20),

            // Campo de entrada: Longitud del tubo en metros
            TextField(
              controller: _longitudController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Longitud del tubo (m)',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.grey[300]),
              cursorColor: Colors.grey[300],
            ),
            SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _calcular,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CALCULAR PESO DEL TUBO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

            // Resultado del cálculo
            Text(
              'Peso: ${_peso.toStringAsFixed(2)} kg',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
