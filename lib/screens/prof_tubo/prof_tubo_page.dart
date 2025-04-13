import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfundidadDistanciaPage extends StatefulWidget {
  const ProfundidadDistanciaPage({super.key});
  @override
  ProfundidadDistanciaPageState createState() => ProfundidadDistanciaPageState();
}

class ProfundidadDistanciaPageState extends State<ProfundidadDistanciaPage> {
  double _pendiente = 0.0;
  double _distancia = 0.0;
  double _profundidad = 0.0;
  
  final FocusNode _pendienteFocus = FocusNode();
  final FocusNode _distanciaFocus = FocusNode();

  void _calcular() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _profundidad = _pendiente * _distancia / 100;
    });
  }

  @override
  void dispose() {
    _pendienteFocus.dispose();
    _distanciaFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.depthByDistanceTitle),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen localizada para HDD
              Image.asset(
                'assets/icon/profdist_${locale}.png',
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.engineering,
                  size: 100,
                  color: theme.colorScheme.tertiary,
                  semanticLabel: l10n.hddDiagramDescription,
                ),
              ),
              const SizedBox(height: 24),
              
              // Campo de pendiente
              TextField(
                focusNode: _pendienteFocus,
                decoration: InputDecoration(
                  labelText: l10n.slopeInput,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withOpacity(0.7),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onChanged: (value) => setState(() {
                  _pendiente = double.tryParse(value) ?? 0.0;
                }),
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_distanciaFocus),
              ),
              const SizedBox(height: 16),
              
              // Campo de distancia
              TextField(
                focusNode: _distanciaFocus,
                decoration: InputDecoration(
                  labelText: l10n.distanceInput,
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withOpacity(0.7),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                onChanged: (value) => setState(() {
                  _distancia = double.tryParse(value) ?? 0.0;
                }),
                onSubmitted: (_) => _calcular(),
              ),
              const SizedBox(height: 24),
              
              // Botón de cálculo
              ElevatedButton(
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
              const SizedBox(height: 24),
              
              // Resultado
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    children: [
                      TextSpan(text: '${l10n.depthResult} '),
                      TextSpan(
                        text: '${_profundidad.toStringAsFixed(2)} ${l10n.metersUnit}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}