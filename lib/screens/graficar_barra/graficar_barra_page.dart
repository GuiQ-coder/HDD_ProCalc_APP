import 'dart:ui' as dartui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class GraficarBarraPage extends StatefulWidget {
  const GraficarBarraPage({super.key});
  @override
  GraficarBarraPageState createState() => GraficarBarraPageState();
}

class GraficarBarraPageState extends State<GraficarBarraPage> {
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _degreesController = TextEditingController();
  final List<Map<String, dynamic>> _bars = [];
  double _maxValue = 0;
  double _minValue = 0;
  double _totalDistance = 0;
  String? _lastLengthValue;
  Uint8List? _appIconBytes;

  @override
  void initState() {
    super.initState();
    _bars.add({
      'length': 0.0,
      'degrees': 0.0,
      'x': 0.0,
      'y': 0.0,
      'isInitial': true
    });
    _loadLastLength();
    _loadAppIcon();
    _lengthController.addListener(() {
      if (_lengthController.text.isNotEmpty) {
        _saveLastLength(_lengthController.text);
      }
    });
  }

  Future<void> _loadAppIcon() async {
    try {
      final ByteData data = await rootBundle.load('assets/iconApp/IconApp.png');
      setState(() {
        _appIconBytes = data.buffer.asUint8List();
      });
    } catch (e) {
      debugPrint('Error loading app icon: $e');
    }
  }

  Future<void> _loadLastLength() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastLengthValue = prefs.getString('lastLengthValue');
      if (_lastLengthValue != null) {
        _lengthController.text = _lastLengthValue!;
      }
    });
  }

  Future<void> _saveLastLength(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastLengthValue', value);
  }

void _addBar() {
  final double? length = double.tryParse(_lengthController.text);
  final double? degrees = double.tryParse(_degreesController.text);
  
  if (length == null || degrees == null || length <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Valores inválidos')),
    );
    return;
  }

  setState(() {
    
    final double radians = degrees * pi / 180;
    final double yIncrement = length * sin(radians);
    
    if (_bars.length == 1 && _bars.first['isInitial'] == true) {
      _bars[0] = {
        'length': length,
        'degrees': degrees,
        'x': 0.0,
        'y': 0.0,
        'isInitial': false
      };
      _totalDistance = length;
    } else {
      final double yValue = _bars.last['y']! + yIncrement;
      _bars.add({
        'length': length,
        'degrees': degrees,
        'x': _totalDistance,
        'y': yValue,
        'isInitial': false
      });
      _totalDistance += length;
    }
    
    _calculateRange();
    _saveLastLength(_lengthController.text);
    _degreesController.clear();
  });
}

  void _removeLastBar() {
    if (_bars.length > 1) {
      setState(() {
        _totalDistance -= _bars.last['length']!;
        _bars.removeLast();
        _calculateRange();
      });
    }
  }

  void _calculateRange() {
    if (_bars.length == 1 && _bars.first['isInitial'] == true) {
      _maxValue = 10;
      _minValue = -10;
      return;
    }
    
    final yValues = _bars.map((bar) => bar['y']!).toList();
    _maxValue = yValues.reduce((a, b) => a > b ? a : b) + 5;
    _minValue = yValues.reduce((a, b) => a < b ? a : b) - 5;
  }

Future<Uint8List> _renderChartToImage() async {
  try {
    if (_bars.isEmpty || _totalDistance <= 0) {
      return await _createErrorImage('No hay datos suficientes');
    }

    // Configuración de dimensiones
    final double width = min(max(600.0, _totalDistance * 4), 3000.0);
    final double height = 500.0;
    const double leftMargin = 80.0;
    const double rightMargin = 40.0;
    const double topMargin = 60.0;
    const double bottomMargin = 80.0;

    // Cálculo de escalas
    final double xScale = (width - leftMargin - rightMargin) / _totalDistance;
    
    // Mejorado el ajuste automático del rango Y
    final List<double> yValues = _bars.map((bar) => bar['y']! as double).toList();
    double yMin = yValues.isEmpty ? -10 : yValues.reduce(min);
    double yMax = yValues.isEmpty ? 10 : yValues.reduce(max);

    // Asegurar que el rango Y tenga suficiente espacio
    final double yRangeMin = min(yMin, 0.0) - (yMin.abs() * 0.2);
    final double yRangeMax = max(yMax, 0.0) + (yMax.abs() * 0.2);
    
    // Asegurar un rango mínimo si los valores son muy cercanos
    final double minRangeSize = 10.0;
    double adjustedMinY = yRangeMin;
    double adjustedMaxY = yRangeMax;
    
    if ((adjustedMaxY - adjustedMinY) < minRangeSize) {
      final double midpoint = (adjustedMinY + adjustedMaxY) / 2;
      adjustedMinY = midpoint - (minRangeSize / 2);
      adjustedMaxY = midpoint + (minRangeSize / 2);
    }

    final double yRange = adjustedMaxY - adjustedMinY;
    final double yScale = (height - topMargin - bottomMargin) / yRange;

    // Posición del eje X corregida - aseguramos que esté visible en el gráfico
    final double xAxisY = height - bottomMargin - ((0 - adjustedMinY) * yScale);
    
    // Crear canvas
    final recorder = dartui.PictureRecorder();
    final canvas = Canvas(recorder, dartui.Rect.fromLTWH(0, 0, width, height));

    // Dibujar fondo
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(dartui.Rect.fromLTWH(0, 0, width, height), bgPaint);

    // Dibujar grid para mejor legibilidad
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;
      
    // Grid vertical
    final xInterval = max(5.0, (_totalDistance / 10).roundToDouble());
    for (double x = 0; x <= _totalDistance; x += xInterval) {
      canvas.drawLine(
        dartui.Offset(leftMargin + x * xScale, topMargin),
        dartui.Offset(leftMargin + x * xScale, height - bottomMargin),
        gridPaint
      );
    }
    
    // Grid horizontal y línea del eje X
    final yInterval = max(1.0, (yRange / 10).roundToDouble());
    for (double y = (adjustedMinY / yInterval).floor() * yInterval; 
         y <= adjustedMaxY; 
         y += yInterval) {
      // Grid horizontal
      final double yPos = height - bottomMargin - ((y - adjustedMinY) * yScale);
      canvas.drawLine(
        dartui.Offset(leftMargin, yPos),
        dartui.Offset(width - rightMargin, yPos),
        gridPaint
      );
      
      // Destacar el eje X (y=0)
      if (y.abs() < 0.001) {
        final zeroLinePaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 2.0;
        canvas.drawLine(
          dartui.Offset(leftMargin, yPos),
          dartui.Offset(width - rightMargin, yPos),
          zeroLinePaint
        );
      }
    }

    // Dibujar ejes
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;
    
    // Eje Y
    canvas.drawLine(
      dartui.Offset(leftMargin, topMargin), 
      dartui.Offset(leftMargin, height - bottomMargin), 
      axisPaint
    );

    // Procesar puntos del gráfico
    final barsToDraw = _bars.where((bar) => bar['isInitial'] != true).toList();
    final points = barsToDraw.map((bar) {
      final x = leftMargin + (bar['x'] as double) * xScale;
      final y = height - bottomMargin - ((bar['y'] as double) - adjustedMinY) * yScale;
      return dartui.Offset(x, y);
    }).toList();

    // Dibujar línea
    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    // Dibujar puntos
    final dotPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 5, dotPaint);
    }

    // Etiquetas del eje X
    final paragraphStyle = dartui.ParagraphStyle(
      fontSize: 12,
      textAlign: TextAlign.center,
    );
    final textStyle = dartui.TextStyle(color: Colors.black);

    // Etiquetas X con mejor distribución
    for (double x = 0; x <= _totalDistance; x += xInterval) {
      final xLabelBuilder = dartui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText('${x.toStringAsFixed(0)} m');
      final paragraph = xLabelBuilder.build();
      paragraph.layout(dartui.ParagraphConstraints(width: 60));
      
      // Posición ajustada para etiquetas X
      final double yPosition = height - bottomMargin + 15;
      canvas.drawParagraph(
        paragraph,
        dartui.Offset(leftMargin + x * xScale - 30, yPosition),
      );
    }
    
    // Etiquetas del eje Y mejoradas
    for (double y = (adjustedMinY / yInterval).floor() * yInterval; 
         y <= adjustedMaxY; 
         y += yInterval) {
      final double yPos = height - bottomMargin - ((y - adjustedMinY) * yScale);
      
      if (yPos >= topMargin && yPos <= height - bottomMargin) {
        final yLabelBuilder = dartui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(textStyle)
          ..addText('${y.toStringAsFixed(1)} m');
        final paragraph = yLabelBuilder.build();
        paragraph.layout(dartui.ParagraphConstraints(width: 60));
        canvas.drawParagraph(
          paragraph,
          dartui.Offset(leftMargin - 65, yPos - 10),
        );
      }
    }

    
    final titleStyle = dartui.TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    final titleBuilder = dartui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(titleStyle);
    final titleParagraph = titleBuilder.build();
    titleParagraph.layout(dartui.ParagraphConstraints(width: width - 100));
    canvas.drawParagraph(titleParagraph, dartui.Offset(width / 2 - 100, 20));

    // Convertir a imagen
    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: dartui.ImageByteFormat.png);
    
    return byteData?.buffer.asUint8List() ?? await _createErrorImage('Error al generar imagen');
  } catch (e, stack) {
    debugPrint('Error al renderizar gráfico: $e\n$stack');
    return await _createErrorImage('Error técnico. Revise los datos');
  }
}

 Future<Uint8List> _createErrorImage([String message = 'Error']) async {
    final recorder = dartui.PictureRecorder();
    final canvas = Canvas(recorder, const dartui.Rect.fromLTWH(0, 0, 400, 300));

    // Fondo de error
    final bgPaint = Paint()..color = Colors.red[50]!;
    canvas.drawRect(const dartui.Rect.fromLTWH(0, 0, 400, 300), bgPaint);

    // Texto de error
    final paragraphStyle = dartui.ParagraphStyle(
      fontSize: 16,
      textAlign: TextAlign.center,
      maxLines: 2,
    );
    final textStyle = dartui.TextStyle(color: Colors.red[800]!);
    final builder = dartui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(message);

    final paragraph = builder.build();
    paragraph.layout(const dartui.ParagraphConstraints(width: 360));
    canvas.drawParagraph(paragraph, const dartui.Offset(20, 140));

    final picture = recorder.endRecording();
    final image = await picture.toImage(400, 300);
    final byteData = await image.toByteData(format: dartui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

Future<void> _generateAndSharePDF(BuildContext context) async {
  if (!mounted) return;

  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context)!;
  
  try {
    // Mostrar indicador de carga
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(l10n.generatingPdf),
          ],
        ),
        duration: const Duration(minutes: 1),
      ),
    );

    // Renderizar el gráfico primero
    final chartImage = await _renderChartToImage();
    if (!mounted) return;

    // Generar el PDF directamente (sin isolate)
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              if (_appIconBytes != null)
                pw.Image(
                  pw.MemoryImage(_appIconBytes!),
                  height: 50,
                  width: 50,
                ),
              pw.Text('HDD ProCalc',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(DateTime.now().toString().split(' ')[0],
                  style: pw.TextStyle(fontSize: 12)),
            ],
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),
          
          pw.Header(
            level: 0,
            child: pw.Text(l10n.pdfTitle,
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 10),
          
          // Contenedor para la imagen con mejor adaptación
          pw.Center(
            child: pw.Container(
              height: 300,
              width: 700,
              child: pw.Image(pw.MemoryImage(chartImage), fit: pw.BoxFit.contain),
            ),
          ),
          
          pw.SizedBox(height: 20),
          
          pw.Header(
            level: 1,
            child: pw.Text(l10n.barsDataTitle,
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ),
          pw.TableHelper.fromTextArray(
            context: pdfContext,
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.center,
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headers: [
              l10n.barNumber,
              l10n.lengthLabel,
              l10n.degreesLabel,
              'X',
              'Y'
            ],
            data: _bars.where((bar) => bar['isInitial'] != true).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final bar = entry.value;
              return [
                '${index + 1}',
                '${bar['length']!.toStringAsFixed(2)} m',
                '${bar['degrees']!.toStringAsFixed(2)}°',
                bar['x']!.toStringAsFixed(2),
                bar['y']!.toStringAsFixed(2),
              ];
            }).toList(),
          ),
          
          pw.SizedBox(height: 20),
          
          pw.Header(
            level: 1,
            child: pw.Text(l10n.summaryTitle,
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('${l10n.totalDistance}: ${_totalDistance.toStringAsFixed(2)} m',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${l10n.barsCount}: ${_bars.where((bar) => bar['isInitial'] != true).length}'),
                pw.Text('${l10n.maxElevation}: ${_maxValue.toStringAsFixed(2)} m'),
                pw.Text('${l10n.minElevation}: ${_minValue.toStringAsFixed(2)} m'),
              ],
            ),
          ),
          
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.Text('${l10n.generatedBy} - ${DateTime.now().year}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
        ],
      ),
    );

    final bytes = await pdf.save();
    if (!mounted) return;
    scaffoldMessenger.hideCurrentSnackBar();

    final fecha = DateTime.now();
    final formatter = DateFormat('dd_MM_yyyy_HH_mm');
    final fechaFormateada = formatter.format(fecha);

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'graph_bar_report_$fechaFormateada.pdf',
    );
  } catch (e) {
    if (!mounted) return;
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('${l10n.pdfError}: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.barGraphPageTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generateAndSharePDF(context),
            tooltip: l10n.pdfButton,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lengthController,
                      decoration: InputDecoration(
                        labelText: l10n.lengthLabel,
                        border: const OutlineInputBorder(),
                        hintText: _lastLengthValue ?? '0.0',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _degreesController,
                      decoration: InputDecoration(
                        labelText: l10n.degreesLabel,
                        border: const OutlineInputBorder(),
                        hintText: '0.0',
                      ),
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}')),
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addBar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: Text(l10n.addBarButton),
                  ),
                  ElevatedButton(
                    onPressed: _removeLastBar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    child: Text(l10n.deleteLastButton),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
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
                              l10n.tooltipText(
                                spot.x.toStringAsFixed(2),
                                spot.y.toStringAsFixed(2),
                                _bars[spot.barIndex]['degrees']!.toStringAsFixed(2)
                              ),
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
                        spots: _bars.where((bar) => !(bar['isInitial'] == true && _bars.length == 1)).map((bar) {
                          return FlSpot(bar['x']!, bar['y']!);
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
              
              if (_bars.where((bar) => bar['isInitial'] != true).isNotEmpty) ...[
                Text(
                  l10n.enteredBarsTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _bars.where((bar) => bar['isInitial'] != true).length,
                  itemBuilder: (context, index) {
                    final bar = _bars.where((bar) => bar['isInitial'] != true).toList()[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('${l10n.barItemTitle(index + 1)}: ${bar['length']!.toStringAsFixed(2)} m, ${bar['degrees']!.toStringAsFixed(2)}°'),
                      subtitle: Text(l10n.barItemSubtitle(
                        bar['x']!.toStringAsFixed(2),
                        bar['y']!.toStringAsFixed(2)
                      )),
                    );
                  },
                ),
              ] else ...[
                Text(
                  l10n.initialPoint,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _degreesController.dispose();
    super.dispose();
  }
}