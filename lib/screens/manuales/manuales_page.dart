import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ManualesPage extends StatefulWidget {
  const ManualesPage({super.key});
  @override
  ManualesPageState createState() => ManualesPageState();
}

class ManualesPageState extends State<ManualesPage> {
  final Map<String, String> _manuales = {
    'JT25': 'https://drive.google.com/uc?export=download&id=1dG7BQQPvF_z58J-St6bq_XDtUsqxJVxX',
    'JT30': 'https://drive.google.com/uc?export=download&id=1TEDxDP-xt4wM0iXkS0a5O5qyuvQ4Y7QC',
    'JT40': 'https://drive.google.com/uc?export=download&id=1mcCEftWNk6Sm-tOMtUXnbffdAXas-btm',
    'PipeTables': 'https://drive.google.com/uc?export=download&id=1V6z82ivEeTNQXrt66re2wQWmrcBgn18A',
    'VermeerD16x20ANavigator': 'https://drive.google.com/uc?export=download&id=1oRIifkKeHv2pwnfeg4Zdwf3z3iO8of4-',
    'VermeerD20x22Navigator': 'https://drive.google.com/uc?export=download&id=1eTc1j6nyoEW-koeaejXdkO8LxLBFa9c_',
    'VermeerD24x40SeriesINavigator': 'https://drive.google.com/uc?export=download&id=1EZS9Gp2fSmA4uKLyCuxuccBPSOO2R0DW',
    'VermeerD40x40NavtecNavigator': 'https://drive.google.com/uc?export=download&id=17HOmkGgitXCVEvMU1kxjTzAhom7ZZ_07',
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
      final archivos = await manualesDir.list().where((f) => f is File).toList();
      
      final nuevosArchivos = <String, String>{};
      for (var archivo in archivos) {
        final file = archivo as File;
        final nombre = file.path.split('/').last.replaceAll('.pdf', '');
        nuevosArchivos[nombre] = file.path;
      }
      
      if (mounted) {
        setState(() {
          _archivosDescargados
            ..clear()
            ..addAll(nuevosArchivos);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _archivosDescargados.clear();
        });
      }
    }
  } catch (e) {
    debugPrint('Error al verificar archivos: $e');
    if (mounted) {
      setState(() {
        _archivosDescargados.clear();
      });
    }
  }
}

  Future<Directory> _getDocumentDirectory() async {
    if (Platform.isAndroid) {
      if (await _checkStoragePermission()) {
        return await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      }
      return await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationSupportDirectory();
    }
  }

Future<bool> _checkStoragePermission() async {
  if (!Platform.isAndroid) return true;

  try {
    // Para Android 13+ (API 33+)
    if (await DeviceInfoPlugin().androidInfo.then((info) => info.version.sdkInt >= 33)) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted && mounted) {
        _showPermissionDeniedDialog(context);
      }
      return status.isGranted;
    }
    // Para versiones anteriores
    else {
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted && mounted) {
          _showPermissionDeniedDialog(context);
        }
        return result.isGranted;
      }
      return true;
    }
  } catch (e) {
    debugPrint('Error verificando permisos: $e');
    return false;
  }
}
Future<void> _descargarYMostrarPDF(String nombre) async {
  String? rutaGuardado;

  try {
    if (_archivosDescargados.containsKey(nombre)) {
      rutaGuardado = _archivosDescargados[nombre]!;
      final file = File(rutaGuardado);
      if (await file.exists()) {
        final result = await OpenFilex.open(rutaGuardado);
        if (result.type != ResultType.done) {
          // Si falla al abrir, eliminar el archivo corrupto
          await file.delete();
          setState(() {
            _archivosDescargados.remove(nombre);
          });
          throw Exception('Archivo corrupto. Por favor descárgalo nuevamente.');
        }
        return;
      }
    }

    setState(() {
      _isLoading = true;
      loadingManual = nombre;
    });

    final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final manualesDir = Directory('${directory.path}/manuales');
    
    if (!await manualesDir.exists()) {
      await manualesDir.create(recursive: true);
    }
    
    rutaGuardado = '${manualesDir.path}/$nombre.pdf'; 
    

    final dio = Dio(BaseOptions(
      receiveTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 30),
    ));

    final response = await dio.download(
      _manuales[nombre]!,
      rutaGuardado,
      onReceiveProgress: (received, total) {
        debugPrint('Progreso: ${(received / total * 100).toStringAsFixed(0)}%');
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error en la descarga: ${response.statusCode}');
    }

    final file = File(rutaGuardado);
    if (!await file.exists()) {
      throw Exception('El archivo no se descargó correctamente');
    }

    setState(() {
      _archivosDescargados[nombre] = rutaGuardado;
    });

    final result = await OpenFilex.open(rutaGuardado);
    if (result.type != ResultType.done) {
      throw Exception('No se pudo abrir el archivo: ${result.message}');
    }
    
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
          // Actualizar el estado y verificar archivos
          setState(() {
            _archivosDescargados.remove(nombre);
          });
          await _verificarArchivosDescargados(); // <-- Añade esta línea
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
                    await _verificarArchivosDescargados(); // <-- Añade esta línea
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
                    onTap: () {
                      if (estaDescargado) {
                        setState(() {
                          loadingManual = nombre;
                          _isLoading = true;
                        });
                        _descargarYMostrarPDF(nombre).then((_) {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                              loadingManual = null;
                            });
                          }
                        });
                      } else {
                        _descargarYMostrarPDF(nombre);
                      }
                    },
                  ),
              
                );
              },
            ),
    );
  }
}

