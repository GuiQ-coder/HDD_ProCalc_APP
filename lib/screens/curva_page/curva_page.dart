import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurvaCompletaPage extends StatefulWidget {
  const CurvaCompletaPage({super.key});
  @override
  CurvaCompletaPageState createState() => CurvaCompletaPageState();
}

class CurvaCompletaPageState extends State<CurvaCompletaPage> {
  double _anguloEntrada = 0.0;
  double _longitudBarra = 0.0;
  double _radio = 0.0;
  double _profundidadRequerida = 0.0;
  double _resultado = 0.0;
  
  final FocusNode _anguloFocus = FocusNode();
  final FocusNode _longitudFocus = FocusNode();
  final FocusNode _radioFocus = FocusNode();
  final FocusNode _profundidadFocus = FocusNode();

  void _calcular() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _resultado = (_anguloEntrada * _longitudBarra) / (_radio * _profundidadRequerida);
    });
  }

  @override
  void dispose() {
    _anguloFocus.dispose();
    _longitudFocus.dispose();
    _radioFocus.dispose();
    _profundidadFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fullCurveTitle),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              
              // Imagen localizada
              Image.asset(
                'assets/icon/curvacompleta_${locale}.png',
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.error,
                  size: 100,
                  color: theme.colorScheme.tertiary,
                  semanticLabel: l10n.errorIconDescription,
                ),
              ),
              const SizedBox(height: 24),
              
              // Campos de entrada
              _buildInputField(
                focusNode: _anguloFocus,
                label: l10n.entryAngleInput,
                value: _anguloEntrada,
                onChanged: (value) => setState(() => _anguloEntrada = value),
                nextFocus: _longitudFocus,
                theme: theme,
              ),
              const SizedBox(height: 16),
              
              _buildInputField(
                focusNode: _longitudFocus,
                label: l10n.barLengthInput,
                value: _longitudBarra,
                onChanged: (value) => setState(() => _longitudBarra = value),
                nextFocus: _radioFocus,
                theme: theme,
              ),
              const SizedBox(height: 16),
              
              _buildInputField(
                focusNode: _radioFocus,
                label: l10n.radiusInput,
                value: _radio,
                onChanged: (value) => setState(() => _radio = value),
                nextFocus: _profundidadFocus,
                theme: theme,
              ),
              const SizedBox(height: 16),
              
              _buildInputField(
                focusNode: _profundidadFocus,
                label: l10n.requiredDepthInput,
                value: _profundidadRequerida,
                onChanged: (value) => setState(() => _profundidadRequerida = value),
                onSubmit: _calcular,
                theme: theme,
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    l10n.calculateButton,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Resultado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${l10n.resultLabel} ',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _resultado.toStringAsFixed(2),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required FocusNode focusNode,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    FocusNode? nextFocus,
    VoidCallback? onSubmit,
    required ThemeData theme,
  }) {
    return TextField(
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.tertiary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.7),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onChanged: (value) => onChanged(double.tryParse(value) ?? 0.0),
      onSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else if (onSubmit != null) {
          onSubmit();
        }
      },
    );
  }
}