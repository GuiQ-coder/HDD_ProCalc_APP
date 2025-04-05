import 'package:flutter/material.dart';


class MedidasRoscasPage extends StatefulWidget {
  const MedidasRoscasPage({super.key});
  @override
  MedidasRoscasPageState createState() => MedidasRoscasPageState();
}

class MedidasRoscasPageState extends State<MedidasRoscasPage> {
  // Lista de tipos de roscas
  final List<String> tiposRoscas = [
    'Roscas Regular',
    '2-3/8" A.P.I Regular',
    '2-7/8" A.P.I Regular',
    '3-1/2" A.P.I Regular',
    '4-1/2" A.P.I Regular',
    '4-1/2" A.P.I Regular x',
    '5-1/2" A.P.I Regular',
    '6-5/8" A.P.I Regular',
    '7-5/8" A.P.I Regular',
    'Roscas I.F. Internal Flush',
    '2-3/8" A.P.I InternalFlush',
    '2-7/8" A.P.I InternalFlush',
    '3-1/2" A.P.I InternalFlush',
    '3-1/2" A.P.I InternalFlush x',
    '4-1/2" A.P.I InternalFlush',
    '4-1/2" A.P.I InternalFlush x',
    '5-1/2" A.P.I InternalFlush',
    '6-5/8" A.P.I InternalFlush',
    '7-5/8" A.P.I InternalFlush',
    'Roscas FULL HOLE',
    '2-3/8" A.P.I Full Hole',
    '2-7/8" A.P.I Full Hole',
    '3-1/2" A.P.I Full Hole',
    '4" A.P.I Full Hole',    
    '4-1/2" A.P.I Full Hole',
    '4-1/2" A.P.I Full Hole x',
    '5-1/2" A.P.I Full Hole',
    '6-5/8" A.P.I Full Hole',
  ];

  // Mapa con las medidas de cada rosca
  final Map<String, Map<String, double>> medidasRoscas = {
    'Roscas Regular': {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0, 'F': 0, 'd': 0, 'Peso': 0},
    '2-3/8" A.P.I Regular': {'A': 66.7, 'B': 68.3, 'C': 47.6, 'D': 79.4, 'E': 76.2, 'F': 92.1, 'd': 25.4, 'Peso': 9.82},
    '2-7/8" A.P.I Regular': {'A': 76.2, 'B': 77.8, 'C': 54, 'D': 95.2, 'E': 88.9, 'F': 104.8, 'd': 31.7, 'Peso': 15.47},
    '3-1/2" A.P.I Regular': {'A': 88.9, 'B': 90.5, 'C': 65.1, 'D': 107.9, 'E': 95.2, 'F':111.1, 'd': 38.1, 'Peso': 19.78},
    '4-1/2" A.P.I Regular': {'A': 117.5, 'B': 119.1, 'C': 90.5, 'D': 139.7, 'E': 107.9, 'F': 123.8, 'd': 57.1, 'Peso': 24.69},
    '4-1/2" A.P.I Regular x': {'A': 117.5, 'B': 119.1, 'C': 90.5, 'D': 139.7, 'E': 107.9, 'F': 123.8, 'd': 57.1, 'Peso': 24.69},
    '5-1/2" A.P.I Regular': {'A': 104.2, 'B': 141.7, 'C': 109.9, 'D': 171.4, 'E': 120.6, 'F': 136.5, 'd': 68.8, 'Peso': 32.58},
    '6-5/8" A.P.I Regular': {'A': 152.2, 'B': 154.4, 'C': 131, 'D': 196.8, 'E': 127, 'F': 142.9, 'd': 88.9, 'Peso': 37.49},
    '7-5/8" A.P.I Regular': {'A': 177.8, 'B': 180.2, 'C': 144.5, 'D': 225.4, 'E': 133.3, 'F': 142.9, 'd': 101.6, 'Peso': 43.44},

    'Roscas I.F. Internal Flush': {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0, 'F': 0, 'd': 0, 'Peso': 0},
    '2-3/8" A.P.I InternalFlush': {'A': 73.1, 'B': 74.6, 'C': 60.4, 'D': 85.7, 'E': 76.2, 'F': 92.1, 'd': 44.4, 'Peso': 9.82},
    '2-7/8" A.P.I InternalFlush': {'A': 86.1, 'B': 87.7, 'C': 71.3, 'D': 104.8, 'E': 88.9, 'F': 104.98, 'd': 54, 'Peso': 15.47},
    '3-1/2" A.P.I InternalFlush': {'A': 102, 'B': 103.6, 'C': 85.1, 'D': 120.6, 'E': 101.6, 'F':117.5, 'd': 68.3, 'Peso': 19.78},
    '3-1/2" A.P.I InternalFlush x': {'A': 102, 'B': 103.6, 'C': 85.1, 'D': 127, 'E': 101.6, 'F':117.5, 'd': 68.3, 'Peso': 23.06},
    '4" A.P.I InternalFlush': {'A': 122.8, 'B': 124.6, 'C': 103.7, 'D': 146, 'E': 114.3, 'F': 130.2, 'd': 82.5, 'Peso': 20.83},
    '4-1/2" A.P.I InternalFlush': {'A': 133.3, 'B': 134.9, 'C': 114.3, 'D': 155.6, 'E': 114.3, 'F': 130.2, 'd': 95.2, 'Peso': 24.69},
    '4-1/2" A.P.I InternalFlush x': {'A': 133.3, 'B': 134.9, 'C': 114.3, 'D': 158.7, 'E': 114.3, 'F': 130.2, 'd': 95.2, 'Peso': 29.75},    

        'Roscas FULL HOLE': {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'E': 0, 'F': 0, 'd': 0, 'Peso': 0},
    '3-1/2" A.P.I Full Hole': {'A': 101.4, 'B': 102.8, 'C': 77.6, 'D': 117.5, 'E': 95.2, 'F':111.1, 'd': 61.9, 'Peso': 19.78},
    '4" A.P.I Full Hole': {'A': 108.4, 'B': 110.3, 'C': 89.7, 'D': 133.3, 'E': 114.3, 'F':130.2, 'd': 71.4, 'Peso': 20.83},
    '4-1/2" A.P.I Full Hole': {'A': 121.7, 'B': 123.8, 'C': 96.3, 'D': 146, 'E': 101.6, 'F': 117.5, 'd': 76.2, 'Peso': 24.69},
    '4-1/2" A.P.I Full Hole x': {'A': 121.7, 'B': 123.8, 'C': 96.3, 'D': 152.4, 'E': 101.6, 'F': 117.5, 'd': 80.2, 'Peso': 44.63},
    '5-1/2" A.P.I Full Hole': {'A': 148, 'B': 150, 'C': 126.8, 'D': 177.8, 'E': 127, 'F': 142.9,  'd': 101.6, 'Peso': 32.58},
    '6-5/8" A.P.I Full Hole': {'A': 171.5, 'B': 173.8, 'C': 150.4, 'D': 203.2, 'E': 127, 'F': 142.9, 'd': 127, 'Peso': 37.49},
  };

  String _roscaSeleccionada = 'Roscas Regular'; // Roscas seleccionada por defecto
  Map<String, double>? _medidasActuales; // Medidas de la rosca seleccionada

  void _mostrarMedidas() {
    setState(() {
      _medidasActuales = medidasRoscas[_roscaSeleccionada];
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Medidas de Roscas'),
    ),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16), // Agrega un padding opcional
      child: Column(
        children: [
            Image.asset(
              'assets/icon/medidasroscasimg.png', // Asegúrate de que la imagen esté en la carpeta correcta
              width: 300,
              height: 300,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 100, color: Colors.red);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Selecciona el tipo de rosca y presiona "Mostrar" para ver las medidas.',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _roscaSeleccionada,
              items: tiposRoscas.map((String rosca) {
                return DropdownMenuItem<String>(
                  value: rosca,
                  child: Text(rosca),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _roscaSeleccionada = value!;
                });
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white, // Color del texto
              ),
              onPressed: _mostrarMedidas,
              child: Text('Mostrar Medidas'),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GaleriaRoscasPage()),
                );
              },
              child: Text('Ver Galería de Roscas', 
                style: TextStyle(color: Colors.white)),
              ),
            
            SizedBox(height: 15),

            if (_medidasActuales != null)
              Column(
                children: [
                  Text('Medidas de la rosca:', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),
                  DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text('Medida')),
                      DataColumn(label: Text(' Valor')),
                    ],
                    rows: [
                    DataRow(cells: [DataCell(Text(' A')), DataCell(Text('${_medidasActuales!['A']} mm'))]),
                    DataRow(cells: [DataCell(Text(' B')), DataCell(Text('${_medidasActuales!['B']} mm'))]),
                    DataRow(cells: [DataCell(Text(' C')), DataCell(Text('${_medidasActuales!['C']} mm'))]),
                    DataRow(cells: [DataCell(Text(' D')), DataCell(Text('${_medidasActuales!['D']} mm'))]),
                    DataRow(cells: [DataCell(Text(' E')), DataCell(Text('${_medidasActuales!['E']} mm'))]),
                    DataRow(cells: [DataCell(Text(' F')), DataCell(Text('${_medidasActuales!['F']} mm'))]),
                    DataRow(cells: [DataCell(Text(' d')), DataCell(Text('${_medidasActuales!['d']} mm'))]),
                    DataRow(cells: [DataCell(Text('Peso')), DataCell(Text('${_medidasActuales!['Peso']} kg/m'))])
                    ]),

            SizedBox(height: 20),
                ]
              ),
          ],
        ),
      ),
    );
  }
}


class GaleriaRoscasPage extends StatefulWidget {
  @override
  GaleriaRoscasPageState createState() => GaleriaRoscasPageState();
}

class GaleriaRoscasPageState extends State<GaleriaRoscasPage> {
  // Lista de todas las categorías de imágenes
  final List<String> categorias = [
    'api', 'case', 'dw', 'ez', 'if', 'rad', 'vermeer'
  ];
  
  // Mapa con el rango de imágenes por categoría
  final Map<String, List<int>> rangos = {
    'api': [1, 10],
    'case': [1, 2],
    'dw': [1, 26],
    'ez': [1, 16],
    'if': [1, 2],
    'rad': [1, 5],
    'vermeer': [1, 18],
  };
  
  String categoriaSeleccionada = 'api';
  String busqueda = '';
  List<String> imagenesFiltradas = [];

  @override
  void initState() {
    super.initState();
    _filtrarImagenes();
  }

  void _filtrarImagenes() {
    setState(() {
      imagenesFiltradas = [];
      
      // Si no hay búsqueda, mostrar todas las imágenes de la categoría seleccionada
      if (busqueda.isEmpty) {
        int inicio = rangos[categoriaSeleccionada]![0];
        int fin = rangos[categoriaSeleccionada]![1];
        
        for (int i = inicio; i <= fin; i++) {
          imagenesFiltradas.add('${categoriaSeleccionada}$i.png');
        }
      } else {
        // Si hay búsqueda, buscar en todas las categorías
        for (var categoria in categorias) {
          int inicio = rangos[categoria]![0];
          int fin = rangos[categoria]![1];
          
          for (int i = inicio; i <= fin; i++) {
            String nombreImagen = '${categoria}$i.png';
            if (nombreImagen.toLowerCase().contains(busqueda.toLowerCase())) {
              imagenesFiltradas.add(nombreImagen);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galería de Roscas API'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar imagen',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                busqueda = value;
                _filtrarImagenes();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: categoriaSeleccionada,
              isExpanded: true,
              items: categorias.map((String categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  categoriaSeleccionada = value!;
                  busqueda = ''; // Resetear búsqueda al cambiar categoría
                });
                _filtrarImagenes();
              },
            ),
          ),
          Expanded(
            child: imagenesFiltradas.isEmpty
                ? Center(child: Text('No se encontraron imágenes'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columnas
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 1.0, // Relación cuadrada
                    ),
                    itemCount: imagenesFiltradas.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleImagenPage(
                                imagenPath: imagenesFiltradas[index]),
                            ),
                          );
                        },
                        child: Card(
                          child: Image.asset(
                            'assets/hddradius/${imagenesFiltradas[index]}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, color: Colors.red),
                                    Text('Imagen no encontrada'),
                                    Text(imagenesFiltradas[index]),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DetalleImagenPage extends StatelessWidget {
  final String imagenPath;

  const DetalleImagenPage({Key? key, required this.imagenPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imagenPath),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.asset(
            'assets/hddradius/$imagenPath',
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 50, color: Colors.red),
                  SizedBox(height: 20),
                  Text('No se pudo cargar la imagen:'),
                  Text(imagenPath),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
