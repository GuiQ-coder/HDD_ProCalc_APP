import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

class ROPCalculatorPage extends StatefulWidget {
  const ROPCalculatorPage({super.key});
  @override
  ROPCalculatorPageState createState() => ROPCalculatorPageState();
}

class ROPCalculatorPageState extends State<ROPCalculatorPage> {
  // Controladores para los campos de entrada
  final TextEditingController _diametroMayorController = TextEditingController();
  final TextEditingController _diametroAnteriorController = TextEditingController();
  final TextEditingController _longitudBarraController = TextEditingController();
  final TextEditingController _caudalTriplexController = TextEditingController();
  final TextEditingController _factorController = TextEditingController();
  final TextEditingController _anguloController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _rpmController = TextEditingController();

  // Variables de estado
  double _resultadoROP = 0.0;
  double _tiempoPorBarra = 0.0; // Nuevo: tiempo estimado por barra
  List<double> _historialROP = [];
  bool _showAdvanced = false;

  @override
  void dispose() {
    _diametroMayorController.dispose();
    _diametroAnteriorController.dispose();
    _longitudBarraController.dispose();
    _caudalTriplexController.dispose();
    _factorController.dispose();
    _anguloController.dispose();
    _pesoController.dispose();
    _rpmController.dispose();
    super.dispose();
  }

  // Método principal de cálculo - Versión mejorada con fórmula real
void _calcularROP({bool advanced = false}) {
  // Obtener valores de entrada (convertir a unidades base)
  final diametroMayor = (double.tryParse(_diametroMayorController.text) ?? 0.0) / 1000; // mm → m
  final diametroAnterior = (double.tryParse(_diametroAnteriorController.text) ?? 0.0) / 1000; // mm → m
  final longitudBarra = double.tryParse(_longitudBarraController.text) ?? 0.0; // m
  final caudalTriplex = (double.tryParse(_caudalTriplexController.text) ?? 0.0) / 60000; // lts/min → m³/s
  final factor = (double.tryParse(_factorController.text) ?? 0.0).clamp(0, 7);

  // Cálculo de áreas (m²)
  final areaHoyo = pi * pow(diametroMayor, 2) / 4;
  final areaBarra = pi * pow(diametroAnterior, 2) / 4;
  final areaAnular = areaHoyo - areaBarra;

  // Fórmula ROP realista (m/s)
  double rop = 0.0;
  if (areaAnular > 0 && caudalTriplex > 0) {
    rop = (caudalTriplex * factor) / areaAnular;
  }

  // Convertir a m/h para uso industrial
  rop *= 3600; // m/s → m/h

  // Cálculo tiempo por barra (min/barra)
  double tiempoBarra = 0.0;
  if (rop > 0) {
    tiempoBarra = (longitudBarra / rop) * 60;
  }

  // Ajustes avanzados (con límites físicos)
  if (advanced) {
    final anguloInclinacion = (double.tryParse(_anguloController.text) ?? 0.0).clamp(0, 90);
    final pesoSobreBarrena = double.tryParse(_pesoController.text) ?? 0.0;
    final rpm = double.tryParse(_rpmController.text) ?? 0.0;

    // Factores con límites físicos realistas
    final ajusteInclinacion = 1 - (anguloInclinacion / 200).clamp(0.5, 1.0);
    final ajustePeso = log(pesoSobreBarrena.clamp(1000, 50000) / log(5000)).clamp(0.8, 1.2);
    final ajusteRPM = (rpm.clamp(50, 200) / 120).clamp(0.7, 1.5);

    rop *= ajusteInclinacion * ajustePeso * ajusteRPM;
    rop = rop.clamp(1, 50); // Límite físico realista para ROP

    // Recalcular tiempo con ROP ajustado
    if (rop > 0) {
      tiempoBarra = (longitudBarra / rop) * 60;
    }
  }

  setState(() {
    _resultadoROP = rop;
    _tiempoPorBarra = tiempoBarra;
    _historialROP.add(rop);
    if (_historialROP.length > 5) {
      _historialROP.removeAt(0);
    }
  });
}

  // Métodos auxiliares para UI
  Color _getRopColor(double rop) {
    if (rop <= 0) return Colors.grey;
    if (rop < 5) return Colors.red;
    if (rop < 15) return Colors.orange;
    if (rop < 30) return Colors.lightGreen;
    return Colors.green;
  }

  String _getRopInterpretation(double rop, AppLocalizations l10n) {
    if (rop <= 0) return l10n.invalidData;
    if (rop < 5) return l10n.verySlowROP;
    if (rop < 15) return l10n.moderateROP;
    if (rop < 30) return l10n.goodROP;
    return l10n.excellentROP;
  }

  String _getTiempoBarraInterpretation(double tiempo, AppLocalizations l10n) {
    if (tiempo <= 0) return l10n.timeNotCalculable;
    if (tiempo > 10) return l10n.excessiveTime;
    if (tiempo > 5) return l10n.highTime;
    if (tiempo > 2) return l10n.acceptableTime;
    return l10n.optimalTime;
  }

@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ropCalculator),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Sección de entrada de datos básicos
            Card(
              elevation: 4,
              color: Colors.grey[900],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      l10n.basicParameters,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildInputField(_diametroMayorController, l10n.majorDiameter),
                    _buildInputField(_diametroAnteriorController, l10n.previousDiameter),
                    _buildInputField(_longitudBarraController, l10n.rodLength),
                    _buildInputField(_caudalTriplexController, l10n.triplexFlow),
                    _buildInputField(_factorController, l10n.cleaningFactor),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Botón para mostrar/ocultar parámetros avanzados
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: TextButton(
                onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color.fromRGBO(85, 0, 0, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _showAdvanced ? l10n.hideAdvanced : l10n.showAdvanced,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Sección de parámetros avanzados
            if (_showAdvanced)
              Card(
                elevation: 4,
                color: Colors.grey[900],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        l10n.advancedParameters,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInputField(_anguloController, l10n.inclinationAngle),
                      _buildInputField(_pesoController, l10n.bitWeight),
                      _buildInputField(_rpmController, 'RPM'),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 16),

            // Botones de cálculo
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () => _calcularROP(advanced: false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(170, 0, 0, 1),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.basicROP,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showAdvanced)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () => _calcularROP(advanced: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(170, 0, 0, 1),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.advancedROP,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Sección de resultados
           if (_resultadoROP > 0) ...[
              SizedBox(height: 20),
              Card(
                elevation: 4,
                color: Colors.grey[900],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        l10n.ropResult(_resultadoROP.toStringAsFixed(2)),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: (_resultadoROP / 50).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[800],
                        color: _getRopColor(_resultadoROP),
                        minHeight: 20,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _getRopInterpretation(_resultadoROP, l10n),
                        style: TextStyle(
                          fontSize: 16,
                          color: _getRopColor(_resultadoROP),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        l10n.estimatedTime(_tiempoPorBarra.toStringAsFixed(2)),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[200],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _getTiempoBarraInterpretation(_tiempoPorBarra, l10n),
                        style: TextStyle(
                          fontSize: 16,
                          color: _tiempoPorBarra > 5 ? Colors.orange : Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        l10n.rodsPerHour(_tiempoPorBarra > 0 ? (60 / _tiempoPorBarra).toStringAsFixed(2) : "N/A"),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Gráfico de tendencia
             Card(
                elevation: 4,
                color: Colors.grey[900],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        l10n.ropTrend,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                             bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      l10n.calculation((value.toInt() + 1).toString()), // Forma correcta
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.grey),
                            ),
                            minX: 0,
                            maxX: _historialROP.length > 1 ? _historialROP.length - 1 : 1,
                            minY: 0,
                            maxY: _historialROP.isNotEmpty ? _historialROP.reduce(max) * 1.2 : 50,
                            lineBarsData: [
                              LineChartBarData(
                                spots: _historialROP.asMap().entries.map((e) {
                                  return FlSpot(e.key.toDouble(), e.value);
                                }).toList(),
                                isCurved: true,
                                color: Color.fromRGBO(170, 0, 0, 1),
                                barWidth: 3,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Color.fromRGBO(170, 0, 0, 0.1),
                                ),
                                dotData: FlDotData(show: true),
                              ),
                            ],
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

  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}