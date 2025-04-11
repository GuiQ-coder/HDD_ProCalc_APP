import 'package:flutter/material.dart';

class AditivosPerforacionPage extends StatefulWidget {
  const AditivosPerforacionPage({super.key});
  @override
  AditivosPerforacionPageState createState() => AditivosPerforacionPageState();
}

class AditivosPerforacionPageState extends State<AditivosPerforacionPage> {
  String _tipoTerreno = 'compacto';
  String _concentracion = 'alta';
  double _volumenTunel = 0.0;
  Map<String, double> _resultados = {};

  void _calcularAditivos() {
    setState(() {
      // Aquí puedes agregar la lógica para calcular los aditivos según el tipo de terreno y la concentración
      _resultados = {
        'Controlador de PH y Ca+': 10.0,
        'Gel Premium N': 5.0,
        'DISPAC': 3.0,
        'Clay Free': 2.0,
        'JCPDS RD': 1.0,
        'Lube N': 0.5,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aditivos de Perforación'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _tipoTerreno,
              items: ['compacto', 'arenas', 'arcilla', 'fracturado'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tipoTerreno = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: _concentracion,
              items: ['alta', 'media', 'baja'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _concentracion = value!;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Volumen del túnel final (m³)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _volumenTunel = double.tryParse(value) ?? 0.0;
                });
              },
            ),
          SizedBox(height: 20),

           ElevatedButton(
            onPressed: _calcularAditivos,
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
                itemCount: _resultados.length,
                itemBuilder: (context, index) {
                  String key = _resultados.keys.elementAt(index);
                  return ListTile(
                    title: Text('$key: ${_resultados[key]} kg/unidades'),
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