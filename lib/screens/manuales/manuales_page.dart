import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ManualesPage extends StatefulWidget {
  const ManualesPage({super.key});
  @override
  ManualesPageState createState() => ManualesPageState();
}

class ManualesPageState extends State<ManualesPage> {
  final Map<String, String> _manuales = {
    'JT25': 'https://drive.google.com/file/d/1dG7BQQPvF_z58J-St6bq_XDtUsqxJVxX/view?export=download',
    'JT30': 'https://drive.google.com/file/d/1TEDxDP-xt4wM0iXkS0a5O5qyuvQ4Y7QC/view?export=download',
    'JT40': 'https://drive.google.com/file/d/1mcCEftWNk6Sm-tOMtUXnbffdAXas-btm/view?export=download',
    'PipeTables': 'https://drive.google.com/file/d/1V6z82ivEeTNQXrt66re2wQWmrcBgn18A/view?export=download',
    'VermeerD16x20ANavigator': 'https://drive.google.com/file/d/1oRIifkKeHv2pwnfeg4Zdwf3z3iO8of4-/view?export=download',
    'VermeerD20x22Navigator': 'https://drive.google.com/file/d/1eTc1j6nyoEW-koeaejXdkO8LxLBFa9c_/view?export=download',
    'VermeerD24x40SeriesINavigator': 'https://drive.google.com/file/d/1EZS9Gp2fSmA4uKLyCuxuccBPSOO2R0DW/view?export=download',
    'VermeerD40x40NavtecNavigator': 'https://drive.google.com/file/d/17HOmkGgitXCVEvMU1kxjTzAhom7ZZ_07/view?export=download',
  };

  final Map<String, String?> _archivosDescargados = {};
  bool _isLoading = false;
  String? loadingManual;

  @override
  void initState() {
    super.initState();
    _verificarArchivosDescargados();
  }

  Future<void> _verificarArchivosDescargados() async {
    try {
      final dir = await _getDocumentDirectory();
      final manualesDir = Directory('${dir.path}/manuales');
      
      if (await manualesDir.exists()) {
        final archivos = await manualesDir.list().toList();
        
        for (var archivo in archivos) {
          if (archivo is File) {
            final nombre = archivo.path.split('/').last.replaceAll('.pdf', '');
            _archivosDescargados[nombre] = archivo.path;
          }
        }
        
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error al verificar archivos: $e');
    }
  }

  Future<Directory> _getDocumentDirectory() async {
    if (Platform.isAndroid) {
      if (await _checkStoragePermission()) {
        return Directory('/storage/emulated/0/Download');
      }
      return await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationSupportDirectory();
    }
  }

  Future<bool> _checkStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final versionString = Platform.operatingSystemVersion;
      final sdkMatch = RegExp(r'SDK (\d+)').firstMatch(versionString);
      final sdkVersion = sdkMatch != null ? int.parse(sdkMatch.group(1)!) : 0;
      
      final permission = sdkVersion >= 33 ? Permission.photos : Permission.storage;
      return await permission.status.isGranted;
    } catch (e) {
      debugPrint('Error determinando versión Android: $e');
      return await Permission.storage.status.isGranted;
    }
  }

  Future<void> _descargarYMostrarPDF(String nombre) async {
    try {
      if (Platform.isAndroid) {
        final hasPermission = await _checkStoragePermission();
        if (!hasPermission) {
          if (!mounted) return;
          _showPermissionDeniedDialog(context);
          return;
        }
      }

      setState(() {
        _isLoading = true;
        loadingManual = nombre;
      });

      final dir = await _getDocumentDirectory();
      final manualesDir = Directory('${dir.path}/manuales');
      if (!await manualesDir.exists()) {
        await manualesDir.create(recursive: true);
      }

      final rutaGuardado = '${manualesDir.path}/$nombre.pdf';
      
      final dio = Dio();
      await dio.download(
        _manuales[nombre]!,
        rutaGuardado,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint('Progreso: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      setState(() {
        _archivosDescargados[nombre] = rutaGuardado;
      });

      final result = await OpenFilex.open(rutaGuardado);
      debugPrint('Resultado al abrir archivo: ${result.message}');
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
      debugPrint('Error al descargar PDF: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          loadingManual = null;
        });
      }
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso requerido'),
        content: const Text(
          'Para descargar manuales, la app necesita acceso al almacenamiento. '
          'Por favor concede el permiso en la configuración del dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Abrir configuración', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarManual(String nombre) async {
    try {
      if (_archivosDescargados[nombre] != null) {
        final file = File(_archivosDescargados[nombre]!);
        if (await file.exists()) {
          await file.delete();
          setState(() {
            _archivosDescargados.remove(nombre);
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Manual eliminado'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manuales de Maquinaria'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar'),
                  content: const Text('¿Eliminar todos los manuales descargados?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  final dir = await _getDocumentDirectory();
                  final manualesDir = Directory('${dir.path}/manuales');
                  if (await manualesDir.exists()) {
                    await manualesDir.delete(recursive: true);
                    setState(() {
                      _archivosDescargados.clear();
                    });
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todos los manuales eliminados'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar: ${e.toString()}'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      
      
      body:
      
      
      
       _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Descargando $loadingManual...'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _manuales.length,
              itemBuilder: (context, index) {
                final nombre = _manuales.keys.elementAt(index);
                final estaDescargado = _archivosDescargados.containsKey(nombre);

                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(nombre),
                    subtitle: Text(estaDescargado ? 'Descargado' : 'No descargado'),
                    trailing: estaDescargado
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarManual(nombre),
                          )
                        : null,
                    onTap: () => _descargarYMostrarPDF(nombre),
                  ),
              
                );
              },
            ),
    );
  }
}