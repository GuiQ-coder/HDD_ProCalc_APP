import 'package:flutter/material.dart';
import 'dart:math';

class TablaGradosPorcentajePage extends StatelessWidget {
  const TablaGradosPorcentajePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Conversión de Grados a Porcentaje'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Encabezado explicativo con estilo del tema
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withOpacity(0.2),
                  border: Border.all(
                    color: theme.colorScheme.tertiary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Relación grados ↔ porcentaje de pendiente',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              
              // Tabla adaptada al tema
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.tertiaryContainer.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 20,
                      horizontalMargin: 20,
                      headingRowHeight: 40,
                      dataRowMinHeight: 36,
                      headingRowColor: WidgetStateProperty.resolveWith<Color>(
                        (states) => theme.colorScheme.secondaryContainer.withOpacity(0.7),
                      ),
                      columns: [
                        DataColumn(
                          label: Text(
                            'GRADOS',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            'PORCENTAJE',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          numeric: true,
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        90,
                        (index) {
                          final grados = index + 1;
                          final porcentaje = tan(grados * pi / 180) * 100;
                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color>(
                              (states) => index.isEven
                                ? theme.colorScheme.surfaceContainer.withOpacity(0.7)
                                : theme.colorScheme.primaryContainer.withOpacity(0.9),
                            ),
                            cells: [
                              DataCell(
                                Center(
                                  child: Text(
                                    '$grados°',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${porcentaje.toStringAsFixed(2)}%',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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
}