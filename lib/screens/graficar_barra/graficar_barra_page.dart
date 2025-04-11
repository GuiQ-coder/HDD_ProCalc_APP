import 'package:flutter/material.dart';

class GraficarBarraPage extends StatefulWidget {
  const GraficarBarraPage({super.key});
  @override
  _GraficarBarraPageState createState() => _GraficarBarraPageState();
}

class _GraficarBarraPageState extends State<GraficarBarraPage> {
  double _porcentaje = 0.0;
  double _largoBarra = 0.0;
  List<double> _datos = [];

  void _calcular() {
    setState(() {
      _datos = List.generate(10, (index) => _porcentaje * _largoBarra * (index + 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graficar Barra por Barra'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Porcentaje (%)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _porcentaje = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Largo de barra (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _largoBarra = double.tryParse(value) ?? 0.0;
                });
              },
            ),
          SizedBox(height: 20),

           ElevatedButton(
            onPressed: _calcular,
            style: ElevatedButton.styleFrom(
               backgroundColor: Theme.of(context).colorScheme.secondary,
               foregroundColor: Colors.white,
               padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
               ),
             ),
             child: Text(
               'CALCULAR',
               style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.bold,
               ),
            ),
          ),
          SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _datos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Barra ${index + 1}: ${_datos[index].toStringAsFixed(2)} metros'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
