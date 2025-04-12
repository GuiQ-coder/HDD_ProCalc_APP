import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PesodeTuboPage extends StatefulWidget {
  const PesodeTuboPage({super.key});
  @override
  PesodeTuboPageState createState() => PesodeTuboPageState();
}

class PesodeTuboPageState extends State<PesodeTuboPage> {
  double diametroPulgadas = 0.0;
  double espesorMM = 0.0;
  double longitudM = 0.0;
  double _peso = 0.0;
  final double densidadAcero = 7850;

  final TextEditingController _diametroController = TextEditingController();
  final TextEditingController _espesorController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();

  void _calcular() {
    setState(() {
      double dpulg = double.tryParse(_diametroController.text) ?? 0.0;
      double emm = double.tryParse(_espesorController.text) ?? 0.0;
      double lm = double.tryParse(_longitudController.text) ?? 0.0;

      if (dpulg > 0 && emm > 0 && lm > 0) {
        double dmm = dpulg * 25.4;
        double dm = dmm / 1000;
        double em = emm / 1000;
        double ddm = dm - 2 * em;
        double area = (3.1416 / 4) * (dm * dm - ddm * ddm);
        _peso = area * lm * densidadAcero;
      } else {
        _peso = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pipeWeightCalculator),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/icon/pesotuboimg.png',
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 100, color: Colors.red);
              },
            ),
            SizedBox(height: 20),

            Text(
              l10n.pipeWeightDescription,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Campo de diámetro
            TextField(
              controller: _diametroController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.outerDiameter,
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.grey[300]),
              cursorColor: Colors.grey[300],
            ),
            SizedBox(height: 20),

            // Campo de espesor
            TextField(
              controller: _espesorController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.pipeThickness,
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.grey[300]),
              cursorColor: Colors.grey[300],
            ),
            SizedBox(height: 20),

            // Campo de longitud
            TextField(
              controller: _longitudController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.pipeLength,
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
                l10n.calculatePipeWeight,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Resultado
            Text(
              l10n.weightResult(_peso.toStringAsFixed(2)),
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),

            // Información técnica
            ExpansionTile(
              title: Text(
                l10n.technicalInformation,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    l10n.technicalInfoPipeWeight,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}