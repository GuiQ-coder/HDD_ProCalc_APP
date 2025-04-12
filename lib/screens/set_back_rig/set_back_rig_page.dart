import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            ? AppLocalizations.of(context)!.angleRangeErrorPercentage
            : AppLocalizations.of(context)!.angleRangeErrorDegrees;
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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setBackRigCalculator),
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
                      l10n.calculatorDescription,
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
                          ? _buildVerticalUnitSelector(l10n)
                          : _buildHorizontalUnitSelector(l10n),
                    ),
                    SizedBox(height: 16),
                    
                    // Campo de ángulo
                    TextField(
                      decoration: InputDecoration(
                        labelText: _isPercentage 
                            ? l10n.angleInPercentage 
                            : l10n.angleInDegrees,
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
                            ? '${l10n.equivalentTo} ${(_angle != 0 ? (atan(_angle/100) * (180/pi)).toStringAsFixed(1) : 0)}°'
                            : '${l10n.equivalentTo} ${(_angle != 0 ? (tan(_angle * pi/180) * 100).toStringAsFixed(1) : 0)}%',
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
                        labelText: l10n.entryDepth,
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
                        l10n.calculateDistance,
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
                              l10n.setBackDistance,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(255),
                              ),
                            ),
                            SizedBox(height: 8),
                           Text(
                              '${_result.toStringAsFixed(2)} ${l10n.meters}',
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
                        l10n.technicalInformation,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            _isPercentage 
                                ? l10n.technicalInfoPercentage
                                : l10n.technicalInfoDegrees,
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

  Widget _buildHorizontalUnitSelector(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              l10n.angleUnits,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
                fontSize: 14,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ),
        _buildToggleButtons(l10n),
      ],
    );
  }

  Widget _buildVerticalUnitSelector(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.angleUnits,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        _buildToggleButtons(l10n),
      ],
    );
  }

  Widget _buildToggleButtons(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(76),
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
        color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
        fillColor: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(l10n.percentage),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(l10n.degrees),
          ),
        ],
      ),
    );
  }
}