import 'package:flutter/material.dart';
import 'package:test_hdd_app/screens/disclaimer/disclaimer_page.dart';
import 'package:test_hdd_app/screens/espacio_anular/espacio_anular_page.dart';
import 'package:test_hdd_app/screens/fluido_necesario/fluido_necesario_page.dart';
import 'package:test_hdd_app/screens/menu/menu_page.dart';
import 'package:test_hdd_app/screens/set_back_rig/set_back_rig_page.dart';
import 'package:test_hdd_app/screens/peso_tubo/peso_de_tubo_page.dart';
import 'package:test_hdd_app/screens/tabla_curva_salida/tabla_curva_salida_page.dart';
import 'package:test_hdd_app/screens/volumen_tanque/volumen_tanque_page.dart';
import 'screens/pull_stress/pullstress_page.dart';
import 'screens/about/aboutapp_page.dart';
import 'screens/aditivos_perforacion/aditivos_perforacion_page.dart';
import 'screens/asesores/asesores_page.dart';
import 'screens/curva_page/curva_page.dart';
import 'screens/curvatura_smys/curvatura_smys_page.dart';
import 'screens/flotabilidad/flotabilidad_page.dart';
import 'screens/make_up/makeup_page.dart';
import 'screens/rop/rop_page.dart';
import 'screens/manejo_tuberia/manejo_tuberia.dart';
import 'screens/medidas_roscas/medidas_roscas.dart';
import 'screens/manuales/manuales_page.dart';
import 'screens/radio_curva/radio_curvatura_page.dart';
import 'screens/prof_tubo/prof_tubo_page.dart';
import 'screens/graficar_barra/graficar_barra_page.dart';
import 'screens/dar_blanco/dar_blanco_page.dart';
import 'screens/tabla_porc_grados/tabla_porc_grados_page.dart';
import 'screens/tabla_salida/tabla_salida_page.dart';
import 'screens/language_settings/language_settings.dart';





final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const DisclaimerPage(),
  '/menu': (context) => const MenuPage(),
  
  // Rutas de Perforador/Driller
  '/set_back_rig': (context) => const SetBackRigPage(),
  '/peso_tubo': (context) => const PesodeTuboPage(),
  '/pull_stress': (context) => const PullStressHDPEPage(),
  '/flotabilidad': (context) => const FlotabilidadPage(),
  '/make_up': (context) => const MakeupPage(),
  '/rop': (context) => const ROPCalculatorPage(),
  '/manejo_tuberia': (context) => const ManejodeTuberiasPage(),
  '/medidas_roscas': (context) => const MedidasRoscasPage(),
  '/manuales': (context) => const ManualesPage(),
  
  // Rutas de Navegador/Navigator
  '/radio_curva': (context) => const RadioCurvaturaPage(),
  '/curvatura_smys': (context) => const RadioSMYSPage(),
  '/curva_page': (context) => const CurvaCompletaPage(),
  '/prof_tubo': (context) => const ProfundidadDistanciaPage(),
  '/graficar_barra': (context) => const GraficarBarraPage(),
  '/dar_blanco': (context) => const DarEnElBlancoPage(),
  '/tabla_porc_grados': (context) => const TablaGradosPorcentajePage(),
  '/tabla_salida': (context) => const TablaSalidasPage(),
  '/tabla_curva_salida': (context) => const TablaCurvasTuberiasPage(),
  
  // Rutas de Fluidos
  '/volumen_tanque': (context) => const VolumenTanquePage(),
  '/espacio_anular': (context) => const EspacioAnularPage(),
  '/aditivos_perforacion': (context) => const AditivosPerforacionPage(),
  '/fluido_necesario': (context) => const FluidoNecesarioPage(),
  '/asesores': (context) => const AsesoresPage(),
  '/about': (context) => const AboutPage(),
  
  // Rutas de Opciones
  '/language_settings': (context) => const LanguageSettingsPage(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  // Manejo para rutas no definidas
  if (!appRoutes.containsKey(settings.name)) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${settings.name}'),
        ),
      ),
    );
  }
  
  return MaterialPageRoute(
    builder: (context) => appRoutes[settings.name]!(context),
    settings: settings,
  );
}