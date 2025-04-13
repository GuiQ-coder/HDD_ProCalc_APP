import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  double _downloadProgress = 0;
  String _progressText = '0%';

  // Método para obtener las traducciones
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verificarArchivosDescargados();
  }

  @override
  void activate() {
    super.activate();
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
          if (await file.length() > 0) {
            nuevosArchivos[nombre] = file.path;
          } else {
            await file.delete();
          }
        }
        
        if (mounted) {
          setState(() {
            _archivosDescargados.clear();
            _archivosDescargados.addAll(nuevosArchivos);
          });
        }
      } else {
        await manualesDir.create(recursive: true);
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
        return await getApplicationDocumentsDirectory();
      }
      return await getApplicationDocumentsDirectory();
    } else {
      return await getApplicationSupportDirectory();
    }
  }

  Future<bool> _checkStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      if (await DeviceInfoPlugin().androidInfo.then((info) => info.version.sdkInt >= 33)) {
        if (await Permission.manageExternalStorage.isGranted) {
          return true;
        }
        
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted && mounted) {
          _showPermissionDeniedDialog(context);
        }
        return status.isGranted;
      } else {
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
    if (_isLoading) return;

    try {
      if (_archivosDescargados.containsKey(nombre)) {
        final file = File(_archivosDescargados[nombre]!);
        if (await file.exists() && await file.length() > 0) {
          final result = await OpenFilex.open(file.path);
          if (result.type == ResultType.done) return;
          await file.delete();
        }
        setState(() => _archivosDescargados.remove(nombre));
      }

      setState(() {
        _isLoading = true;
        loadingManual = nombre;
        _downloadProgress = 0;
        _progressText = '0%';
      });

      final directory = await _getDocumentDirectory();
      final manualesDir = Directory('${directory.path}/manuales');
      
      if (!await manualesDir.exists()) {
        await manualesDir.create(recursive: true);
      }
      
      final tempPath = '${manualesDir.path}/$nombre.temp';
      final finalPath = '${manualesDir.path}/$nombre.pdf';
      
      final dio = Dio();
      await dio.download(
        _manuales[nombre]!,
        tempPath,
        deleteOnError: true,
        onReceiveProgress: (received, total) {
          if (mounted) {
            setState(() {
              _downloadProgress = received / total;
              _progressText = '${(_downloadProgress * 100).toStringAsFixed(0)}%';
            });
          }
        },
      );

      final tempFile = File(tempPath);
      if (!await tempFile.exists() || await tempFile.length() == 0) {
        await tempFile.delete();
        throw Exception(l10n.fileCorrupt);
      }

      await tempFile.rename(finalPath);

      setState(() => _archivosDescargados[nombre] = finalPath);
      await OpenFilex.open(finalPath);
      
    } catch (e) {
      try {
        final directory = await _getDocumentDirectory();
        final tempPath = '${directory.path}/manuales/$nombre.temp';
        if (await File(tempPath).exists()) {
          await File(tempPath).delete();
        }
      } catch (_) {}
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          loadingManual = null;
          _downloadProgress = 0;
          _progressText = '0%';
        });
      }
    }
  }


  void _showPermissionDeniedDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.permissionRequired),
        content: Text(l10n.storagePermissionMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(
              l10n.openSettings, 
              style: const TextStyle(color: Colors.white)
            ),
          ),
      ]),
    );
  }

  Future<void> _eliminarManual(String nombre) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      if (_archivosDescargados[nombre] != null) {
        final file = File(_archivosDescargados[nombre]!);
        if (await file.exists()) {
          await file.delete();
          setState(() {
            _archivosDescargados.remove(nombre);
          });
          await _verificarArchivosDescargados();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.manualDeleted),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.error}: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
 Widget _buildLoadingOverlay() {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {},
        child: AbsorbPointer(
          absorbing: true,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 5,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${l10n.downloading(loadingManual ?? '')}...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _progressText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: LinearProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.pleaseWait,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manualsTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.confirm),
                  content: Text(l10n.deleteAllConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        l10n.cancel, 
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        l10n.deleteAll, 
                        style: const TextStyle(color: Colors.red),
                      ),
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
                    await _verificarArchivosDescargados();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.allDeleted),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.error}: ${e.toString()}'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _manuales.length,
            itemBuilder: (context, index) {
              final nombre = _manuales.keys.elementAt(index);
              final estaDescargado = _archivosDescargados.containsKey(nombre);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(nombre),
                  subtitle: Text(estaDescargado ? l10n.downloaded : l10n.notDownloaded),
                  trailing: estaDescargado && !_isLoading
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarManual(nombre),
                        )
                      : null,
                  onTap: _isLoading ? null : () => _descargarYMostrarPDF(nombre),
                ),
              );
            },
          ),
          
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }
}