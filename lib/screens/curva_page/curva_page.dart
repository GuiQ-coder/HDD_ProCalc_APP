import 'package:flutter/material.dart';

class CurvaCompletaPage extends StatefulWidget {
  const CurvaCompletaPage({super.key});
  @override
  CurvaCompletaPageState createState() => CurvaCompletaPageState();
}

class CurvaCompletaPageState extends State<CurvaCompletaPage> {
  double _anguloEntrada = 0.0;
  double _longitudBarra = 0.0;
  double _radio = 0.0;
  double _profundidadRequerida = 0.0;
  double _resultado = 0.0;

  void _calcular() {
    setState(() {
      _resultado = (_anguloEntrada * _longitudBarra) / (_radio * _profundidadRequerida);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Curva Completa'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            SizedBox(height: 15,),

            Image.asset(
              'assets/icon/curvacompletaimg.png',
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.circle_outlined,
                size: 100,
                color: Colors.blue,
              ),
            ),

            SizedBox(height: 15),




            TextField(
              decoration: InputDecoration(labelText: 'Ángulo de entrada'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _anguloEntrada = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Longitud de barra (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _longitudBarra = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Radio (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _radio = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Profundidad requerida (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _profundidadRequerida = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Text(
              'Resultado: ${_resultado.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
