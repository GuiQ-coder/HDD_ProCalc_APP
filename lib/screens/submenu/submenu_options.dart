import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_hdd_app/screens/submenu/submenu_card.dart';
import 'package:test_hdd_app/constants/category_ids.dart';

final Map<String, List<Map<String, dynamic>>> options = {
  CategoryIds.driller: [
    {'id': 'set_back_rig', 'icon': 'assets/icon/sbricon.png', 'route': '/set_back_rig'},
    {'id': 'pipe_weight', 'icon': Icons.fitness_center_outlined, 'route': '/peso_tubo'},
    {'id': 'pull_stress', 'icon': Icons.expand_outlined, 'route': '/pull_stress'},
    {'id': 'buoyancy', 'icon': Icons.sailing_outlined, 'route': '/flotabilidad'},
    {'id': 'make_up', 'icon': Icons.speed_outlined, 'route': '/make_up'},
    {'id': 'rop', 'icon': Icons.hourglass_full_outlined, 'route': '/rop'},
    {'id': 'pipe_handling', 'icon': Icons.group_work_outlined, 'route': '/manejo_tuberia'},
    {'id': 'thread_measurements', 'icon': Icons.swap_vert_circle_outlined, 'route': '/medidas_roscas'},
    {'id': 'manuals', 'icon': Icons.auto_stories, 'route': '/manuales'},
  ],
  CategoryIds.navigator: [
    {'id': 'curve_radius', 'icon': 'assets/icon/rcurvicon.png', 'route': '/radio_curva'},
    {'id': 'smys_curve', 'icon': 'assets/icon/rcurvicon.png', 'route': '/curvatura_smys'},
    {'id': 'curve', 'icon': Icons.looks, 'route': '/curva_page'},
    {'id': 'depth_per_pipe', 'icon': Icons.play_for_work_outlined, 'route': '/prof_tubo'},
    {'id': 'graph_per_bar', 'icon': Icons.auto_graph_outlined, 'route': '/graficar_barra'},
    {'id': 'hit_target', 'icon': Icons.golf_course, 'route': '/dar_blanco'},
    {'id': 'degree_percent_table', 'icon': Icons.architecture, 'route': '/tabla_porc_grados'},
    {'id': 'exit_table', 'icon': Icons.backup_table_outlined, 'route': '/tabla_salida'},
    {'id': 'pipe_curve_table', 'icon': Icons.assignment, 'route': '/tabla_curva_salida'},
  ],
  CategoryIds.fluids: [
    {'id': 'tank_volume', 'icon': Icons.view_in_ar_outlined, 'route': '/volumen_tanque'},
    {'id': 'annular_space', 'icon': Icons.album_outlined, 'route': '/espacio_anular'},
    {'id': 'drilling_additives', 'icon': Icons.local_drink_outlined, 'route': '/aditivos_perforacion'},
    {'id': 'required_fluid', 'icon': Icons.water_drop_outlined, 'route': '/fluido_necesario'},
    {'id': 'advisors', 'icon': Icons.engineering, 'route': '/asesores'},
    {'id': 'app_info', 'icon': Icons.perm_device_info, 'route': '/about'},
  ],
  CategoryIds.settings: [
    {'id': 'language', 'icon': Icons.translate, 'route': '/language_settings'},
  ]
};

List<Widget> getOptions(String categoryId, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  final items = categoryId == 'all'
      ? options.values.expand((list) => list).where((item) => item['id'] != null).toList()
      : (options[categoryId] ?? []).where((item) => item['id'] != null).toList();
  

  return items.map((opt) {
    final id = opt['id'] as String;
    return SubMenuCard(
      option: opt,
      displayName: _getLocalizedName(id, l10n),
      context: context,
    );
  }).toList();
}

String _getLocalizedName(String id, AppLocalizations l10n) {
  switch(id) {
    // Items de Perforador/Driller
    case 'set_back_rig': return l10n.setBackRig;
    case 'pipe_weight': return l10n.pipeWeight;
    case 'pull_stress': return l10n.pullStress;
    case 'buoyancy': return l10n.buoyancy;
    case 'make_up': return l10n.makeUp;
    case 'rop': return l10n.rop;
    case 'pipe_handling': return l10n.pipeHandling;
    case 'thread_measurements': return l10n.threadMeasurements;
    case 'manuals': return l10n.manuals;

    // Items de Navegador/Navigator
    case 'curve_radius': return l10n.curveRadius;
    case 'smys_curve': return l10n.smysCurve;
    case 'curve': return l10n.curve;
    case 'depth_per_pipe': return l10n.depthPerPipe;
    case 'graph_per_bar': return l10n.graphPerBar;
    case 'hit_target': return l10n.hitTarget;
    case 'degree_percent_table': return l10n.degreePercentTable;
    case 'exit_table': return l10n.exitTable;
    case 'pipe_curve_table': return l10n.pipeCurveTable;

    // Items de Fluidos/Fluids
    case 'tank_volume': return l10n.tankVolume;
    case 'annular_space': return l10n.annularSpace;
    case 'drilling_additives': return l10n.drillingAdditives;
    case 'required_fluid': return l10n.requiredFluid;
    case 'advisors': return l10n.advisors;
    case 'app_info': return l10n.appInfo;

    // Items de Opciones/Settings
    case 'language': return l10n.language;

    default: return id;
  }
}