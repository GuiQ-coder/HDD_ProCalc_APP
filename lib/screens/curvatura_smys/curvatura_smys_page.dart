import 'package:flutter/material.dart';

class RadioSMYSPage extends StatefulWidget {
  const RadioSMYSPage({super.key});
  @override
  RadioSMYSPageState createState() => RadioSMYSPageState();
}

class RadioSMYSPageState extends State<RadioSMYSPage> {
  double _diametro = 0.0;
  double _limiteCedencia = 0.0;
  double _longitudTubo = 0.0;
  double _radioCurvatura = 0.0;
  double _gradosPorTubo = 0.0;
  double _porcentajePorBarra = 0.0;
  
  final FocusNode _diametroFocus = FocusNode();
  final FocusNode _limiteFocus = FocusNode();
  final FocusNode _longitudFocus = FocusNode();

  void _calcular() {
    FocusManager.instance.primaryFocus?.unfocus(); // Cierra el teclado
    setState(() {
      _radioCurvatura = (_diametro * 1000) / (2 * _limiteCedencia);
      _gradosPorTubo = 360 / (_longitudTubo / _radioCurvatura);
      _porcentajePorBarra = (_gradosPorTubo / 360) * 100;
    });
  }

  @override
  void dispose() {
    _diametroFocus.dispose();
    _limiteFocus.dispose();
    _longitudFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio por SMYS'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'assets/icon/radiocurvatura.png',
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.circle_outlined,
                  size: 100,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Campo de diámetro
              TextField(
                focusNode: _diametroFocus,
                decoration: InputDecoration(
                  labelText: 'Diámetro (pulgadas)',
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onChanged: (value) => setState(() {
                  _diametro = double.tryParse(value) ?? 0.0;
                }),
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_limiteFocus),
              ),
              const SizedBox(height: 16),
              
              // Campo de límite de cedencia
              TextField(
                focusNode: _limiteFocus,
                decoration: InputDecoration(
                  labelText: 'Límite de cedencia (PSI)',
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onChanged: (value) => setState(() {
                  _limiteCedencia = double.tryParse(value) ?? 0.0;
                }),
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_longitudFocus),
              ),
              const SizedBox(height: 16),
              
              // Campo de longitud
              TextField(
                focusNode: _longitudFocus,
                decoration: InputDecoration(
                  labelText: 'Longitud del tubo (metros)',
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                onChanged: (value) => setState(() {
                  _longitudTubo = double.tryParse(value) ?? 0.0;
                }),
                onSubmitted: (_) => _calcular(),
              ),
              const SizedBox(height: 24),
              
              // Botón de cálculo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calcular,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CALCULAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Resultados
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'RESULTADOS',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildResultRow('Radio de curvatura:', '${_radioCurvatura.toStringAsFixed(2)} m', theme),
                    _buildResultRow('Grados por tubo:', '${_gradosPorTubo.toStringAsFixed(2)}°', theme),
                    _buildResultRow('Porcentaje por barra:', '${_porcentajePorBarra.toStringAsFixed(2)}%', theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          Text(value, 
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}