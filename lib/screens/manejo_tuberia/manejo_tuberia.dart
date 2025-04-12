import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManejodeTuberiasPage extends StatefulWidget {
  const ManejodeTuberiasPage({super.key});
  @override
  ManejodeTuberiasPageState createState() => ManejodeTuberiasPageState();
}

class ManejodeTuberiasPageState extends State<ManejodeTuberiasPage> {
  double diametroExterno = 0.0;
  double diametroTubosPequenos = 0.0;
  int _cantidadTubos = 0;
  int _cantidadTubosTotales = 0;
  bool _mostrarAdvertencia = false;
  List<Offset> _tubosPosiciones = [];
  List<int> _tubosPorAnillo = [];
  double _areaGrande = 0.0;
  double _areaPequena = 0.0;
  double _areaTotalPequena = 0.0;
  double _ratioArea = 0.0;

  final TextEditingController _diametroExternoController = TextEditingController();
  final TextEditingController _diametroPequenosController = TextEditingController();

  void _calcularTubos() {
    setState(() {
      _mostrarAdvertencia = false;
      
      diametroExterno = double.tryParse(_diametroExternoController.text) ?? 0.0;
      diametroTubosPequenos = double.tryParse(_diametroPequenosController.text) ?? 0.0;

      if (diametroExterno > 0 && diametroTubosPequenos > 0) {
        // Validar proporción mínima
        if (diametroTubosPequenos < diametroExterno * 0.05) {
          _mostrarDialogoAdvertencia;
        }

        // Calcular disposición
        _calcularDisposicionTubos();
        
        // Aplicar límites para visualización
        const MAX_TUBOS = 300;
        _cantidadTubosTotales = _tubosPosiciones.length;
        
        if (_cantidadTubosTotales > MAX_TUBOS) {
          _mostrarAdvertencia = true;
          _tubosPosiciones = _tubosPosiciones.sublist(0, MAX_TUBOS);
          _cantidadTubos = MAX_TUBOS;
        } else {
          _cantidadTubos = _cantidadTubosTotales;
        }
        
        // Calcular áreas
        _calcularAreas();
      } else {
        _cantidadTubos = 0;
        _cantidadTubosTotales = 0;
        _tubosPosiciones.clear();
        _tubosPorAnillo.clear();
      }
    });
  }

  void _mostrarDialogoAdvertencia() {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(l10n.suboptimalProportion, 
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Text(l10n.proportionWarning, 
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK', 
                    style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
            ),
          ],
        ),
      );
    }

  void _calcularDisposicionTubos() {
    _tubosPosiciones.clear();
    _tubosPorAnillo.clear();
    
    double radioExterno = diametroExterno / 2;
    double radioPequeno = diametroTubosPequenos / 2;
    
    if (radioPequeno >= radioExterno) return;
    
    // Tubo central
    _tubosPosiciones.add(Offset(0, 0));
    _tubosPorAnillo.add(1);
    
    double radioDisponible = radioExterno - radioPequeno;
    if (radioDisponible < radioPequeno) return;
    
    // Calcular anillos
    int anillo = 1;
    while (true) {
      double radioAnillo = anillo * radioPequeno * 2;
      if (radioAnillo > radioDisponible) break;
      
      double circunferencia = 2 * pi * radioAnillo;
      int tubosEnAnillo = (circunferencia / (radioPequeno * 2)).floor();
      
      // Ajuste empírico para anillos exteriores
      if (anillo > 3) {
        tubosEnAnillo = (tubosEnAnillo * 1.04).floor();
      }
      
      List<Offset> posicionesAnillo = [];
      for (int i = 0; i < tubosEnAnillo; i++) {
        double angulo = 2 * pi * i / tubosEnAnillo;
        double x = radioAnillo * cos(angulo);
        double y = radioAnillo * sin(angulo);
        
        if (sqrt(x*x + y*y) + radioPequeno <= radioExterno) {
          posicionesAnillo.add(Offset(x, y));
        }
      }
      
      if (posicionesAnillo.isEmpty) break;
      
      _tubosPosiciones.addAll(posicionesAnillo);
      _tubosPorAnillo.add(posicionesAnillo.length);
      anillo++;
    }
  }

  void _calcularAreas() {
    _areaGrande = pi * pow(diametroExterno / 2, 2);
    _areaPequena = pi * pow(diametroTubosPequenos / 2, 2);
    _areaTotalPequena = _cantidadTubosTotales * _areaPequena;
    _ratioArea = (_areaTotalPequena / _areaGrande) * 100;
  }

   @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pipeCalculator),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      l10n.pipeConfiguration,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _diametroExternoController,
                      decoration: InputDecoration(
                        labelText: l10n.outerPipeDiameter,
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _diametroPequenosController,
                      decoration: InputDecoration(
                        labelText: l10n.smallPipesDiameter,
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calcularTubos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      child: Text(
                        l10n.calculate,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_cantidadTubos > 0) ...[
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          l10n.results,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(color: Colors.white),
                      SizedBox(height: 10),
                      _buildResultRow(l10n.maxSmallPipes, '$_cantidadTubosTotales'),
                      if (_mostrarAdvertencia)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            l10n.showingFirst150,
                            style: TextStyle(
                              color: Colors.orange[300],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      SizedBox(height: 8),
                      _buildResultRow(l10n.ringDistribution, _tubosPorAnillo.join(", ")),
                      SizedBox(height: 8),
                      _buildResultRow(l10n.outerPipeArea, '${_areaGrande.toStringAsFixed(2)} mm²'),
                      SizedBox(height: 8),
                      _buildResultRow(l10n.singleSmallPipeArea, '${_areaPequena.toStringAsFixed(2)} mm²'),
                      SizedBox(height: 8),
                      _buildResultRow(l10n.totalSmallPipesArea, '${_areaTotalPequena.toStringAsFixed(2)} mm²'),
                      SizedBox(height: 8),
                      _buildResultRow(l10n.areaRatio, '${_ratioArea.toStringAsFixed(1)}%'),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        l10n.pipeArrangement, 
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 300,
                        width: 300,
                        child: CustomPaint(
                          painter: TubosPainter(
                            diametroExterno: diametroExterno,
                            diametroTubosPequenos: diametroTubosPequenos,
                            cantidadTubos: _cantidadTubos,
                            posiciones: _tubosPosiciones,
                            tubosPorAnillo: _tubosPorAnillo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildResultRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _diametroExternoController.dispose();
    _diametroPequenosController.dispose();
    super.dispose();
  }
}

class TubosPainter extends CustomPainter {
  final double diametroExterno;
  final double diametroTubosPequenos;
  final int cantidadTubos;
  final List<Offset> posiciones;
  final List<int> tubosPorAnillo;

  TubosPainter({
    required this.diametroExterno,
    required this.diametroTubosPequenos,
    required this.cantidadTubos,
    required this.posiciones,
    required this.tubosPorAnillo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calcular escala
    double escala = min(size.width, size.height) / (diametroExterno * 1.1);
    
    // Radios escalados
    double radioExterno = (diametroExterno / 2) * escala;
    double radioPequeno = (diametroTubosPequenos / 2) * escala;
    
    // Centrar el dibujo
    Offset centro = Offset(size.width / 2, size.height / 2);
    
    // Dibujar el tubo exterior
    final paintExterno = Paint()
      ..color = Color.fromRGBO(85, 0, 0, 0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(centro, radioExterno, paintExterno);
    
    final paintBordeExterno = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawCircle(centro, radioExterno, paintBordeExterno);
    
    // Colores para diferentes anillos
    final coloresAnillos = [
      Color.fromRGBO(255, 50, 50, 0.7),
      Color.fromRGBO(170, 0, 0, 0.7),
      Color.fromRGBO(85, 0, 0, 0.7),

    ];
    
    final paintBordeInterno = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    // Dibujar tubos por anillos con colores diferentes
    int indiceInicio = 0;
    for (int i = 0; i < tubosPorAnillo.length; i++) {
      Color color = coloresAnillos[i % coloresAnillos.length];
      final paintAnillo = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      for (int j = 0; j < tubosPorAnillo[i]; j++) {
        if (indiceInicio + j < posiciones.length) {
          Offset pos = posiciones[indiceInicio + j];
          Offset centroTubo = Offset(
            centro.dx + pos.dx * escala,
            centro.dy + pos.dy * escala,
          );
          
          canvas.drawCircle(centroTubo, radioPequeno, paintAnillo);
          canvas.drawCircle(centroTubo, radioPequeno, paintBordeInterno);
        }
      }
      indiceInicio += tubosPorAnillo[i];
    }
    
    // Dibujar información en el centro
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(
      text: '$cantidadTubos',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centro.dx - textPainter.width / 2, centro.dy - 8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
