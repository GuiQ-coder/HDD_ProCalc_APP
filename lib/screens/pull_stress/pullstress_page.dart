import 'package:flutter/material.dart';
import 'dart:math';

class PullStressHDPEPage extends StatefulWidget {
  const PullStressHDPEPage({super.key});
  @override
  PullStressHDPEPageState createState() => PullStressHDPEPageState();
}

class PullStressHDPEPageState extends State<PullStressHDPEPage> {
  double _diametroExterno = 0.0;
  double _espesorPared = 0.0;
  double _resultado = 0.0;
  String _tipoMaterial = 'PE100';
  String _errorMessage = '';

  final Map<String, double> resistenciaMaterial = {
    'PE100': 25.0, // MPa (valor típico según normas)
    'PE80': 20.0,  // MPa (valor típico según normas)
  };

  void _calcularResistencia() {
    setState(() {
      if (_diametroExterno <= 0 || _espesorPared <= 0) {
        _errorMessage = 'Ingrese valores válidos mayores a cero';
        _resultado = 0.0;
        return;
      }
      
      if (_espesorPared >= _diametroExterno / 2) {
        _errorMessage = 'El espesor no puede ser mayor o igual al radio';
        _resultado = 0.0;
        return;
      }
      
      _errorMessage = '';
      double resistencia = resistenciaMaterial[_tipoMaterial] ?? 25.0;
      double areaSeccion = pi * (_diametroExterno - _espesorPared) * _espesorPared;
      _resultado = resistencia * areaSeccion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resistencia a la Tracción HDPE'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen representativa
                  Image.asset(
                    'assets/icon/pipeline.png', // Asegúrate de tener esta imagen en assets
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Descripción
                  Text(
                    'Calcula la resistencia máxima a la tracción que puede soportar una tubería HDPE '
                    'basado en su diámetro, espesor y tipo de material.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  
                  // Selector de material
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _tipoMaterial,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                      items: resistenciaMaterial.keys.map((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text('Material: $key (${resistenciaMaterial[key]} MPa)'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoMaterial = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Campo de diámetro externo
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Diámetro Externo (mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _diametroExterno = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      'Ejemplo: 250 mm para tubería de 10"',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Campo de espesor de pared
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Espesor de Pared (mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _espesorPared = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      'Ejemplo: 14.8 mm para DR11 (PE100)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Botón de cálculo
                  ElevatedButton(
                    onPressed: _calcularResistencia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CALCULAR RESISTENCIA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Mostrar error si existe
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  // Resultado
                  Card(
                    margin: EdgeInsets.only(top: 20),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'RESISTENCIA MÁXIMA A LA TRACCIÓN',
                            style: TextStyle(
                              fontSize: 16,
                              color:Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_resultado.toStringAsFixed(2)} N',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          Text(
                            '${(_resultado / 1000).toStringAsFixed(2)} kN', // Conversión a kN
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Ficha técnica
                  ExpansionTile(
                    title: Text(
                      'Información Técnica',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¿Para qué sirve este cálculo?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Determinar la fuerza máxima de jalado (pullback) en instalaciones HDD\n'
                              '• Prevenir fallas durante la instalación de tuberías\n'
                              '• Seleccionar el equipo adecuado para el pullback\n'
                              '• Verificar que la tubería soportará las tensiones de instalación',
                              style: TextStyle(height: 1.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Fórmula utilizada:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Resistencia (N) = Esfuerzo de Tracción (MPa) × Área Transversal (mm²)\n'
                              'Área = π × (DE - e) × e\n\n'
                              'Donde:\n'
                              'DE = Diámetro externo (mm)\n'
                              'e = Espesor de pared (mm)\n'
                              'π = 3.1416',
                              style: TextStyle(height: 1.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recomendaciones:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Use factor de seguridad mínimo 2:1 (resistencia ≥ 2 × fuerza estimada)\n'
                              '• Para suelos abrasivos use 3:1\n'
                              '• PE100 tiene ≈25% más resistencia que PE80\n'
                              '• Considere reducción de resistencia por temperatura (>20°C)\n'
                              '• Verifique siempre las especificaciones del fabricante',
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
