
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DarEnElBlancoPage extends StatefulWidget {
  const DarEnElBlancoPage({super.key});
  @override
  DarEnElBlancoPageState createState() => DarEnElBlancoPageState();
}

class DarEnElBlancoPageState extends State<DarEnElBlancoPage> {
  double _profundidadActual = 0.0;
  double _distanciaHorizontal = 0.0;
  double _profundidadRequerida = 0.0;
  double _anguloNecesario = 0.0;
  bool _pendientePositiva = true;

  final _formKey = GlobalKey<FormState>();
  final _profundidadActualController = TextEditingController();
  final _distanciaHorizontalController = TextEditingController();
  final _profundidadRequeridaController = TextEditingController();

  void _calcular() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        final diferenciaProfundidad = _profundidadRequerida - _profundidadActual;
        
        if (_pendientePositiva) {
          _anguloNecesario = atan(diferenciaProfundidad / _distanciaHorizontal) * (180 / pi);
        } else {
          _anguloNecesario = atan(-diferenciaProfundidad / _distanciaHorizontal) * (180 / pi);
        }
      });
    }
  }

  void _togglePendiente() {
    setState(() {
      _pendientePositiva = !_pendientePositiva;
    });
  }

  @override
  void dispose() {
    _profundidadActualController.dispose();
    _distanciaHorizontalController.dispose();
    _profundidadRequeridaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.hitTargetTitle),
        backgroundColor: theme.colorScheme.primary,
      ),
      // Agregamos SingleChildScrollView para permitir desplazamiento
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Encabezado explicativo
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    // Color más sólido con menos transparencia
                    color: theme.colorScheme.secondary,
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    localizations.hitTargetCalculationHeader,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSecondary, // Mejor contraste en texto
                    ),
                  ),
                ),
                
               
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: _togglePendiente,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pendientePositiva 
                        ? theme.colorScheme.tertiary 
                        : theme.colorScheme.secondary,
                      foregroundColor: _pendientePositiva
                        ? Colors.white
                        : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: theme.colorScheme.tertiary,
                          width: 1.5,
                        ),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _pendientePositiva ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _pendientePositiva 
                            ? localizations.hitTargetPositiveSlope 
                            : localizations.hitTargetNegativeSlope,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Campos de entrada (color sólido)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _profundidadActualController,
                        label: localizations.hitTargetCurrentDepth,
                        validator: (value) => _validateInput(value, localizations.hitTargetCurrentDepth, localizations),
                        onChanged: (value) => _profundidadActual = double.tryParse(value) ?? 0.0,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _distanciaHorizontalController,
                        label: localizations.hitTargetHorizontalDistance,
                        validator: (value) => _validateInput(value, localizations.hitTargetHorizontalDistance, localizations),
                        onChanged: (value) => _distanciaHorizontal = double.tryParse(value) ?? 0.0,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _profundidadRequeridaController,
                        label: localizations.hitTargetRequiredDepth,
                        validator: (value) => _validateInput(value, localizations.hitTargetRequiredDepth, localizations),
                        onChanged: (value) => _profundidadRequerida = double.tryParse(value) ?? 0.0,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Botón de cálculo (color sólido)
                ElevatedButton(
                  onPressed: _calcular,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4, // Elevación para dar sensación de botón
                    shadowColor: Colors.black54, // Sombra más visible
                  ),
                  child: Text(
                    localizations.hitTargetCalculateButton,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Imagen de referencia
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Image.asset(
                    _pendientePositiva 
                      ? 'assets/icon/pendientepositiva_${Localizations.localeOf(context).languageCode}.png'
                      : 'assets/icon/pendientenegativa_${Localizations.localeOf(context).languageCode}.png',
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.engineering,
                      size: 100,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Resultado (color sólido)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _pendientePositiva 
                      ? theme.colorScheme.tertiary.withAlpha(220) // Casi sólido 
                      : theme.colorScheme.secondary.withAlpha(220),
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        localizations.hitTargetResult,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_anguloNecesario.toStringAsFixed(2)}°',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white, // Texto blanco para mejor contraste
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _pendientePositiva 
                          ? localizations.hitTargetPositiveSlopeLabel
                          : localizations.hitTargetNegativeSlopeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70, // Texto blanco con ligera transparencia
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
    required Function(String) onChanged,
    required ThemeData theme,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface, // Color sólido para el texto
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: theme.colorScheme.tertiary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.tertiary,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.tertiary,
            width: 2.0, // Más grueso cuando está enfocado
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.black87, // Texto más oscuro para mejor legibilidad
      ),
    );
  }

String? _validateInput(String? value, String fieldName, AppLocalizations localizations) {
  if (value == null || value.isEmpty) {
    return localizations.hitTargetPleaseEnter(fieldName);
  }
  if (double.tryParse(value) == null) {
    return localizations.hitTargetEnterValidNumber;
  }
  return null;
}
}