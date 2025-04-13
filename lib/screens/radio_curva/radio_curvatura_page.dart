import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RadioCurvaturaPage extends StatefulWidget {
  const RadioCurvaturaPage({super.key});
  @override
  RadioCurvaturaPageState createState() => RadioCurvaturaPageState();
}

class RadioCurvaturaPageState extends State<RadioCurvaturaPage> {
  double _diametro = 0.0;
  double _longitudTubo = 0.0;
  double _radioCurvatura = 0.0;
  double _gradosPorTubo = 0.0;
  double _porcentajePorBarra = 0.0;
  final FocusNode _diametroFocusNode = FocusNode();
  final FocusNode _longitudFocusNode = FocusNode();

  void _calcular() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _radioCurvatura = _diametro * 1000 / (2 * 3.1416);
      _gradosPorTubo = 360 / (_longitudTubo / _radioCurvatura);
      _porcentajePorBarra = (_gradosPorTubo / 360) * 100;
    });
  }

  @override
  void dispose() {
    _diametroFocusNode.dispose();
    _longitudFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.radiusOfCurvatureTitle),
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
                  semanticLabel: l10n.errorIconDescription,
                ),
              ),
              const SizedBox(height: 16),
              
              // Campo de diámetro
              TextField(
                focusNode: _diametroFocusNode,
                decoration: InputDecoration(
                  labelText: l10n.diameterInput,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.tertiary),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true
                ),
                textInputAction: TextInputAction.next,
                onChanged: (value) => setState(() {
                  _diametro = double.tryParse(value) ?? 0.0;
                }),
                onSubmitted: (_) {
                  _diametroFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_longitudFocusNode);
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de longitud
              TextField(
                focusNode: _longitudFocusNode,
                decoration: InputDecoration(
                  labelText: l10n.tubeLengthInput,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.tertiary),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true
                ),
                textInputAction: TextInputAction.done,
                onChanged: (value) => setState(() {
                  _longitudTubo = double.tryParse(value) ?? 0.0;
                }),
                onSubmitted: (_) {
                  _longitudFocusNode.unfocus();
                  _calcular();
                },
              ),
              const SizedBox(height: 20),
              
              // Botón de cálculo
              ElevatedButton(
                onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  l10n.calculateButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                    color: theme.colorScheme.tertiary.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.resultsTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildResultItem(l10n.radiusResult, '${_radioCurvatura.toStringAsFixed(2)} m', theme),
                    _buildResultItem(l10n.degreesPerTube, '${_gradosPorTubo.toStringAsFixed(2)}°', theme),
                    _buildResultItem(l10n.percentagePerBar, '${_porcentajePorBarra.toStringAsFixed(2)}%', theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          Text(
            value,
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