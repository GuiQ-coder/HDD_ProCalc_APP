import 'package:flutter/material.dart';

class TablaSalidasPage extends StatefulWidget {
  const TablaSalidasPage({super.key});

  @override
  TablaSalidasPageState createState() => TablaSalidasPageState();
}

class TablaSalidasPageState extends State<TablaSalidasPage> {
  final _formKey = GlobalKey<FormState>();
  

  final _barraInicialController = TextEditingController();
  final _flexionController = TextEditingController();
  final _inicialController = TextEditingController();
  final _salidaController = TextEditingController();
  final _largoBarraController = TextEditingController();
  final _elevacionController = TextEditingController();
  

  int _barraInicial = 0;
  double _flexion = 0;
  double _inicial = 0;
  double _salida = 0;
  double _largoBarra = 0;
  double _elevacion = 0;
  
  List<Map<String, dynamic>> _resultados = [];
  int _barraActual = 0;
  
  @override
  void dispose() {
    // Limpia los controladores cuando se destruye el widget
    _barraInicialController.dispose();
    _flexionController.dispose();
    _inicialController.dispose();
    _salidaController.dispose();
    _largoBarraController.dispose();
    _elevacionController.dispose();
    super.dispose();
  }
  
  void _actualizarVariables() {
    _barraInicial = int.tryParse(_barraInicialController.text) ?? 0;
    _flexion = double.tryParse(_flexionController.text) ?? 0;
    _inicial = double.tryParse(_inicialController.text) ?? 0;
    _salida = double.tryParse(_salidaController.text) ?? 0;
    _largoBarra = double.tryParse(_largoBarraController.text) ?? 0;
    _elevacion = double.tryParse(_elevacionController.text) ?? 0;
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _actualizarVariables();
      
      setState(() {
        if (_resultados.isEmpty) {
          _barraActual = _barraInicial + 1;
        } else {
          // Si ya hay resultados, incrementamos una barra más
          _barraActual++;
        }

        // Calculamos profundidad: largo de barra × número de barra
        final distanciaAcumulada = _largoBarra * _barraActual;
        
        // Calculamos pendiente
        double pendiente;
        if (_barraActual <= _barraInicial + 2) {
          
          pendiente = _inicial + _flexion;
        } else {
          
          pendiente = _inicial + _flexion * (_barraActual - _barraInicial);
        }
        

        final elevacionAcumulada = _elevacion * 1.06 * (_barraActual - _barraInicial + 0);
        
        _resultados.add({
          'Barra': _barraActual,
          'Profundidad': distanciaAcumulada,
          'Pendiente': pendiente,
          'Elevacion': elevacionAcumulada,
        });
      });
    }
  }

  void _reiniciar() {
    setState(() {
      _resultados.clear();
      _barraActual = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo Flexible de Perforación'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sección de parámetros
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Parámetros de Cálculo',
                          style: theme.textTheme.titleMedium?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna izquierda
                          Expanded(
                            child: Column(
                              children: [
                                _buildNumberInput(
                                  'Barra inicial',
                                  _barraInicialController,
                                  decimal: false,
                                  min: 1,
                                ),
                                const SizedBox(height: 16),
                                _buildNumberInput(
                                  'Flexión (%)',
                                  _flexionController,
                                  decimal: true,
                                ),
                                const SizedBox(height: 16),
                                _buildNumberInput(
                                  'Inicial (%)',
                                  _inicialController,
                                  decimal: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              children: [
                                _buildNumberInput(
                                  'Salida (%)',
                                  _salidaController,
                                  decimal: true,
                                ),
                                const SizedBox(height: 16),
                                _buildNumberInput(
                                  'Largo de barra (m)',
                                  _largoBarraController,
                                  decimal: true,
                                ),
                                const SizedBox(height: 16),
                                _buildNumberInput(
                                  'Elevación por barra (m)',
                                  _elevacionController,
                                  decimal: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calcular,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.tertiary,
                        foregroundColor: colors.onTertiary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                      ),
                      child: Center(
                        child: Text(
                          _resultados.isEmpty ? 'CALCULAR INICIAL' : 'AGREGAR SIGUIENTE BARRA',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reiniciar,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                      ),
                      child: Center(
                        child: Text(
                          'REINICIAR',
                          style: TextStyle(
                            color: colors.error,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Resultados
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Resultados de Perforación',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.bold)),
                              if (_resultados.isNotEmpty)
                                Text('Barra actual: ${_resultados.last['Barra']}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: colors.onSurface)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _resultados.isEmpty
                              ? Center(
                                  child: Text(
                                    'Ingrese los parámetros y presione CALCULAR',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: colors.onSurface.withOpacity(0.6)),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      columnSpacing: 24,
                                      headingRowColor:
                                          WidgetStatePropertyAll<Color>(
                                              colors.primaryContainer),
                                      headingTextStyle: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colors.onPrimaryContainer),
                                      columns: [
                                        DataColumn(
                                            label: Text('Barra',
                                                style: TextStyle(
                                                    color: colors.onSurface))),
                                        DataColumn(
                                            label: Text('M. Profundidad',
                                                style: TextStyle(
                                                    color: colors.onSurface)),
                                            numeric: true),
                                        DataColumn(
                                            label: Text('Pendiente %',
                                                style: TextStyle(
                                                    color: colors.onSurface)),
                                            numeric: true),
                                        DataColumn(
                                            label: Text('Elevación m',
                                                style: TextStyle(
                                                    color: colors.onSurface)),
                                            numeric: true),
                                      ],
                                      rows: _resultados.map((data) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(data['Barra'].toString(),
                                                style: TextStyle(
                                                    color: colors.onSurface))),
                                            DataCell(
                                                Text(data['Profundidad']
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: colors.onSurface))),
                                            DataCell(
                                                Text(data['Pendiente']
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: colors.onSurface))),
                                            DataCell(
                                                Text(data['Elevacion']
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: colors.onSurface))),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput(
    String label,
    TextEditingController controller,
    {
    bool decimal = false,
    int? min,
    int? max,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      keyboardType:
          decimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo requerido';
        if (decimal) {
          final num = double.tryParse(value);
          if (num == null) return 'Valor inválido';
          if (min != null && num < min) return 'Mínimo $min';
          if (max != null && num > max) return 'Máximo $max';
        } else {
          final num = int.tryParse(value);
          if (num == null) return 'Valor inválido';
          if (min != null && num < min) return 'Mínimo $min';
          if (max != null && num > max) return 'Máximo $max';
        }
        return null;
      },
    );
  }
}