import 'package:flutter/material.dart';
import '/screens/submenu/submenu_card.dart';

Map<String, List<Map<String, dynamic>>> options = {
      'Perforador': [
      {'name': 'Set Back Rig', 'icon': 'assets/icon/sbricon.png', 'route': '/set_back_rig'},
      {'name': 'Peso de Tubo', 'icon': Icons.fitness_center_outlined, 'route': '/peso_tubo'},
      {'name': 'Pull Stress HDPE', 'icon': Icons.expand_outlined, 'route': '/pull_stress'},
      {'name': 'Flotabilidad', 'icon': Icons.sailing_outlined, 'route': '/flotabilidad'},
      {'name': 'Make Up', 'icon': Icons.speed_outlined, 'route': '/make_up'},
      {'name': 'ROP (tiempo/barra)', 'icon': Icons.hourglass_full_outlined, 'route': '/rop'},
      {'name': 'Manejo de tubería', 'icon': Icons.group_work_outlined, 'route': '/manejo_tuberia'},
      {'name': 'Medidas de Roscas', 'icon': Icons.swap_vert_circle_outlined, 'route': '/medidas_roscas'},
      {'name': 'Manuales', 'icon': Icons.auto_stories, 'route': '/manuales'},
    ],
    'Navegador': [
      {'name': 'Radio de curvatura', 'icon': 'assets/icon/rcurvicon.png', 'route': '/radio_curva'},
      {'name': 'Radio por S.M.Y.S', 'icon': 'assets/icon/rcurvicon.png', 'route': '/curvatura_smys'},
      {'name': 'Curva', 'icon': Icons.looks, 'route': '/curva_page'},
      {'name': 'Profundidad/tubo', 'icon': Icons.play_for_work_outlined, 'route': '/prof_tubo'},
      {'name': 'Graficar/barra', 'icon': Icons.auto_graph_outlined, 'route': '/graficar_barra'},
      {'name': 'Dar en el blanco', 'icon': Icons.golf_course, 'route': '/dar_blanco'},
      {'name': 'Tabla ° y %', 'icon': Icons.architecture, 'route': '/tabla_porc_grados'},
      {'name': 'Tabla de salida', 'icon': Icons.backup_table_outlined, 'route': '/tabla_salida'},
      {'name': 'Tabla curva de tubería', 'icon': Icons.assignment, 'route': '/tabla_curva_salida'},
    ],
    'Fluidos': [
      {'name': 'Volumen Tanque', 'icon': Icons.view_in_ar_outlined, 'route': '/volumen_tanque'},
      {'name': 'Espacio Anular', 'icon': Icons.album_outlined, 'route': '/espacio_anular'},
      {'name': 'Aditivos de perforación', 'icon': Icons.local_drink_outlined, 'route': '/aditivos_perforacion'},
      {'name': 'Fluido necesario', 'icon': Icons.water_drop_outlined, 'route': '/fluido_necesario'},
      {'name': 'Asesores', 'icon': Icons.engineering, 'route': '/asesores'},
      {'name': 'Información de la app', 'icon': Icons.perm_device_info, 'route': '/about'},
    ],
    'Opciones': [
      {'name': 'Idioma', 'icon': Icons.translate},
      {'name': 'Modo oscuro', 'icon': Icons.tungsten_outlined}
    ]
  };


List<Widget> getOptions(String category, BuildContext context) {
  final items = category == 'Todo' 
      ? options.values.expand((list) => list).toList()
      : options[category]!;
  
  return items.map((opt) => SubMenuCard(
    option: opt,
    context: context,
  )).toList();
}