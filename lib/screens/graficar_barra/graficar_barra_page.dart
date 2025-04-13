import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class GraficarBarraPage extends StatefulWidget {
  const GraficarBarraPage({super.key});
  @override
  _GraficarBarraPageState createState() => _GraficarBarraPageState();
}

class _GraficarBarraPageState extends State<GraficarBarraPage> {
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _gradosController = TextEditingController();
  final List<Map<String, double>> _barras = [];
  double _maxValue = 0;
  double _minValue = 0;
  double _totalDistance = 0;

  void _agregarBarra() {
    final double longitud = double.tryParse(_longitudController.text) ?? 0.0;
    final double grados = double.tryParse(_gradosController.text) ?? 0.0;
    
    if (longitud > 0) {
      setState(() {
        final double pendiente = tan(grados * pi / 180).toDouble();
        final double incrementoY = longitud * pendiente;
        final double yValue = _barras.isEmpty ? 0 : _barras.last['y']! + incrementoY;
        
        _barras.add({
          'longitud': longitud,
          'grados': grados,
          'x': _totalDistance,
          'y': yValue
        });
        
        _totalDistance += longitud;
        _calcularRango();
        _longitudController.clear();
        _gradosController.clear();
      });
    }
  }

  void _eliminarUltimaBarra() {
    if (_barras.isNotEmpty) {
      setState(() {
        _totalDistance -= _barras.last['longitud']!;
        _barras.removeLast();
        _calcularRango();
      });
    }
  }

  void _calcularRango() {
    if (_barras.isEmpty) {
      _maxValue = 10; // Valores por defecto cuando no hay barras
      _minValue = -10;
      return;
    }
    
    final yValues = _barras.map((barra) => barra['y']!).toList();
    _maxValue = yValues.reduce((a, b) => a > b ? a : b) + 5; // Margen adicional
    _minValue = yValues.reduce((a, b) => a < b ? a : b) - 5;
  }

  @override
  void dispose() {
    _longitudController.dispose();
    _gradosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graficar barra a barra'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Entrada de datos
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _longitudController,
                      decoration: const InputDecoration(
                        labelText: 'Longitud (m)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _gradosController,
                      decoration: const InputDecoration(
                        labelText: 'Grados (°)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _agregarBarra,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: const Text('Agregar Barra'),
                  ),
                  ElevatedButton(
                    onPressed: _eliminarUltimaBarra,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: const Text('Eliminar Última'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Gráfico de línea para mostrar la trayectoria
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    minY: _minValue,
                    maxY: _maxValue,
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (group) => Colors.blueGrey,
                        tooltipMargin: 10,
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              'Distancia: ${spot.x.toStringAsFixed(2)} m\nElevación: ${spot.y.toStringAsFixed(2)} m\nÁngulo: ${_barras[spot.barIndex]['grados']!.toStringAsFixed(2)}°',
                              const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toStringAsFixed(0));
                          },
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _barras.map((barra) {
                          return FlSpot(barra['x']!, barra['y']!);
                        }).toList(),
                        isCurved: false,
                        color: Colors.blue,
                        barWidth: 4,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Lista de barras ingresadas
              if (_barras.isNotEmpty) ...[
                const Text(
                  'Barras ingresadas:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _barras.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Barra ${index + 1}: ${_barras[index]['longitud']!.toStringAsFixed(2)} m, ${_barras[index]['grados']!.toStringAsFixed(2)}°'),
                      subtitle: Text('Posición: (${_barras[index]['x']!.toStringAsFixed(2)}, ${_barras[index]['y']!.toStringAsFixed(2)})'),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}