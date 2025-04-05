import 'package:flutter/material.dart';
import 'dart:math';

class SetBackRigPage extends StatefulWidget {
  const SetBackRigPage({super.key});
  @override
  SetBackRigPageState createState() => SetBackRigPageState();
}

class SetBackRigPageState extends State<SetBackRigPage> {
  double _angle = 8.0;
  double _height = 0.0;
  double _result = 0.0;
  bool _isPercentage = false;
  String _errorMessage = '';

  void _calculate() {
    setState(() {
      if ((_isPercentage && (_angle < 10.5 || _angle > 36.4)) || 
          (!_isPercentage && (_angle < 6 || _angle > 20))) {
        _errorMessage = _isPercentage 
            ? 'El ángulo debe estar entre 10.5% y 36.4% (equivalente a 6°-20°)'
            : 'El ángulo debe estar entre 6° y 20°';
        _result = 0.0;
        return;
      }
      
      _errorMessage = '';
      
      if (_isPercentage) {
        double angleInRadians = atan(_angle / 100);
        _result = _height / tan(angleInRadians);
      } else {
        double angleInRadians = _angle * (pi / 180);
        _result = _height / tan(angleInRadians);
      }
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Calculadora Set Back Rig'),
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
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen representativa
                  Image.asset(
                    'assets/icon/sbricon.png',
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.engineering,
                      size: 100,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Descripción
                  Text(
                    'Calcula la distancia mínima requerida entre la perforadora y el punto de entrada '
                    'basado en el ángulo y la profundidad de entrada.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  
                  // Selector de unidades optimizado
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: constraints.maxWidth < 400 
                        ? _buildVerticalUnitSelector()
                        : _buildHorizontalUnitSelector(),
                  ),
                  SizedBox(height: 16),
                  
                  // Campo de ángulo
                  TextField(
                    decoration: InputDecoration(
                      labelText: _isPercentage 
                          ? 'Ángulo en % (10.5% a 36.4%)' 
                          : 'Ángulo en grados (6° a 20°)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _angle = double.tryParse(value) ?? 0.0;
                      });
                    },
                    controller: TextEditingController(text: _angle.toStringAsFixed(1))
                      ..selection = TextSelection.collapsed(offset: _angle.toStringAsFixed(1).length),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      _isPercentage
                          ? 'Equivalente a ${(_angle != 0 ? (atan(_angle/100) * (180/pi)).toStringAsFixed(1) : 0)}°'
                          : 'Equivalente a ${(_angle != 0 ? (tan(_angle * pi/180) * 100).toStringAsFixed(1) : 0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                
                  // Campo de altura
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Profundidad de entrada (metros)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _height = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  
                  // Botón de cálculo
                  ElevatedButton(
                    onPressed: _calculate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CALCULAR DISTANCIA SET BACK',
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
                            'DISTANCIA SET BACK RIG',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface.withAlpha(255),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_result.toStringAsFixed(2)} metros',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),
                  
                  // Información adicional
                  ExpansionTile(
                    title: Text(
                      'Información técnica',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'El Set Back Rig es la distancia mínima requerida entre la perforadora y el punto '
                          'de entrada del pozo piloto. Esta distancia depende del ángulo de entrada y la '
                          'profundidad. Ángulos típicos en HDD: 6°-20° (10.5%-36.4%).\n\n'
                          'Fórmula utilizada:\n'
                          'Set Back = Profundidad / tan(Ángulo)\n\n'
                          'Donde:\n'
                          '- Profundidad: Distancia vertical desde la superficie al punto de entrada\n'
                          '- Ángulo: Ángulo de entrada en radianes\n\n'
                          'Para convertir porcentaje a grados:\n'
                          'Ángulo(°) = arctan(porcentaje/100) × (180/π)\n\n'
                          'Para convertir grados a porcentaje:\n'
                          'Porcentaje = tan(Ángulo en radianes) × 100',
                          style: TextStyle(
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
          ),
        );
      },
    ),
  );
}

Widget _buildHorizontalUnitSelector() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Flexible(
        child: Padding(
          padding: EdgeInsets.only(right: 12),
          child: Text(
            'Unidades de ángulo:',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(204), // 80% opacity (255 * 0.8)
              fontSize: 14,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ),
      _buildToggleButtons(),
    ],
  );
}

Widget _buildVerticalUnitSelector() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Unidades de ángulo:',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(204), // 80% opacity
          fontSize: 14,
        ),
      ),
      SizedBox(height: 8),
      _buildToggleButtons(),
    ],
  );
}

Widget _buildToggleButtons() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withAlpha(76), // 30% opacity
      ),
    ),
    child: ToggleButtons(
      isSelected: [_isPercentage, !_isPercentage],
      onPressed: (index) {
        setState(() {
          _isPercentage = index == 0;
          _angle = _isPercentage ? 15.0 : 8.0;
        });
      },
      constraints: BoxConstraints(
        minHeight: 40,
        minWidth: 100,
      ),
      selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 60% opacity
      fillColor: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(6),
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('Porcentaje (%)'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('Grados (°)'),
        ),
      ],
    ),
  );
}
}
