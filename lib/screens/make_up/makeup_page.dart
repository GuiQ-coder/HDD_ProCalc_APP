import 'package:flutter/material.dart';

class MakeupPage extends StatefulWidget {
  const MakeupPage({super.key});
  @override
  MakeupPageState createState() => MakeupPageState();
}

class MakeupPageState extends State<MakeupPage> {
  String _selectedSize = '2 3/8"';
  
  // Datos extraídos del PDF PipeTables.pdf
  final Map<String, Map<String, dynamic>> _pipeData = {
    '2 3/8"': {
      'Common Connections': ['NC26', 'HT26', 'SLH90'],
      'Make-up Torque Range (ft-lb)': '3,700 - 5,200',
      'Tensile Yield Strength (lb)': '138,200 - 276,400',
      'Tool Joint OD (in)': '3 1/4" - 3 3/8"',
      'Tool Joint ID (in)': '1 5/8" - 1 13/16"',
    },
    '2 7/8"': {
      'Common Connections': ['NC26', 'NC31', 'HT26', 'HT31', 'XT26', 'XT31'],
      'Make-up Torque Range (ft-lb)': '3,700 - 8,900',
      'Tensile Yield Strength (lb)': '135,900 - 428,700',
      'Tool Joint OD (in)': '3 1/4" - 4 1/8"',
      'Tool Joint ID (in)': '1 5/8" - 2 5/32"',
    },
    '3 1/2"': {
      'Common Connections': ['NC38', 'NC31', 'HT31', 'HT38', 'XT31', 'XT38'],
      'Make-up Torque Range (ft-lb)': '6,400 - 15,200',
      'Tensile Yield Strength (lb)': '194,300 - 645,500',
      'Tool Joint OD (in)': '4" - 5"',
      'Tool Joint ID (in)': '2" - 2 11/16"',
    },
    '4"': {
      'Common Connections': ['NC40', 'HT40', 'XT40'],
      'Make-up Torque Range (ft-lb)': '12,400 - 26,400',
      'Tensile Yield Strength (lb)': '230,800 - 661,100',
      'Tool Joint OD (in)': '4 3/4" - 6 1/4"',
      'Tool Joint ID (in)': '2" - 3 1/4"',
    },
    '4 1/2"': {
      'Common Connections': ['NC46', 'HT46', 'XT46', 'NC50', 'HT50', 'XT50'],
      'Make-up Torque Range (ft-lb)': '17,600 - 48,700',
      'Tensile Yield Strength (lb)': '330,600 - 824,700',
      'Tool Joint OD (in)': '5 7/8" - 6 5/8"',
      'Tool Joint ID (in)': '2 5/8" - 3 3/4"',
    },
    '5"': {
      'Common Connections': ['NC50', 'HT50', 'XT50'],
      'Make-up Torque Range (ft-lb)': '19,800 - 48,700',
      'Tensile Yield Strength (lb)': '395,600 - 791,200',
      'Tool Joint OD (in)': '6" - 7"',
      'Tool Joint ID (in)': '3" - 3 3/4"',
    },
    '5 1/2"': {
      'Common Connections': ['NC50', 'HT50', 'XT50'],
      'Make-up Torque Range (ft-lb)': '23,400 - 48,700',
      'Tensile Yield Strength (lb)': '530,100 - 742,200',
      'Tool Joint OD (in)': '6 1/4" - 7"',
      'Tool Joint ID (in)': '3 1/4" - 4"',
    },
    '6 5/8"': {
      'Common Connections': ['NC61', 'HT61', 'XT61'],
      'Make-up Torque Range (ft-lb)': '38,100 - 75,200',
      'Tensile Yield Strength (lb)': '939,100 - 1,085,500',
      'Tool Joint OD (in)': '7 1/4" - 8"',
      'Tool Joint ID (in)': '4" - 4 3/4"',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Makeup Torque Specifications'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selector de tamaño
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedSize,
                isExpanded: true,
                underline: SizedBox(),
                items: _pipeData.keys.map((String size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSize = value!;
                  });
                },
              ),
            ),
            
            SizedBox(height: 20),
            
            // Tarjeta con los detalles
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_selectedSize Specifications',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    
                    SizedBox(height: 12),
                    
                    ..._pipeData[_selectedSize]!.entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${entry.key}: ', 
                              style: TextStyle(fontWeight: FontWeight.bold)),
                            Flexible(
                              child: Text(entry.value.toString(),
                                style: TextStyle(fontSize: 15)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nota sobre los datos
            Text('Data extracted from Grant Prideco Drill Pipe Data Tables',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),


            SizedBox(height: 20),
              
            Text(
              'Recuerde que las especificaciones pueden varíar segun el fabricante, consulte con su manual.',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),

            
          ],
        ),
      ),
    );
  }
}
