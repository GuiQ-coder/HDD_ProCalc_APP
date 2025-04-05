import 'package:flutter/material.dart';
import 'package:test_hdd_app/screens/aditivos_perforacion/aditivos_perforacion_page.dart';
import 'package:test_hdd_app/screens/asesores/asesores_page.dart';
import 'package:test_hdd_app/screens/curva_page/curva_page.dart';
import 'package:test_hdd_app/screens/curvatura_smys/curvatura_smys_page.dart';
import 'package:test_hdd_app/screens/dar_blanco/dar_blanco_page.dart';
import 'package:test_hdd_app/screens/espacio_anular/espacio_anular_page.dart';
import 'package:test_hdd_app/screens/flotabilidad/flotabilidad_page.dart';
import 'package:test_hdd_app/screens/fluido_necesario/fluido_necesario_page.dart';
import 'package:test_hdd_app/screens/graficar_barra/graficar_barra_page.dart';
import 'package:test_hdd_app/screens/make_up/makeup_page.dart';
import 'package:test_hdd_app/screens/manejo_tuberia/manejo_tuberia.dart';
import 'package:test_hdd_app/screens/manuales/manuales_page.dart';
import 'package:test_hdd_app/screens/medidas_roscas/medidas_roscas.dart';
import 'package:test_hdd_app/screens/prof_tubo/prof_tubo_page.dart';
import 'package:test_hdd_app/screens/pull_stress/pullstress_page.dart';
import 'package:test_hdd_app/screens/radio_curva/radio_curvatura_page.dart';
import 'package:test_hdd_app/screens/rop/rop_page.dart';
import 'package:test_hdd_app/screens/set_back_rig/set_back_rig_page.dart';
import 'package:test_hdd_app/screens/peso_tubo/peso_de_tubo_page.dart';
import 'package:test_hdd_app/screens/tabla_curva_salida/tabla_curva_salida_page.dart';
import 'package:test_hdd_app/screens/tabla_porc_grados/tabla_porc_grados_page.dart';
import 'package:test_hdd_app/screens/tabla_salida/tabla_salida_page.dart';
import 'package:test_hdd_app/screens/volumen_tanque/volumen_tanque_page.dart';





// Importa todas las demás páginas necesarias

void navigateToRoute(BuildContext context, String routeName) {
  switch (routeName) {
    case '/set_back_rig':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SetBackRigPage()));
      break;
    case '/peso_tubo':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PesodeTuboPage()));
      break;
    case '/pull_stress':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PullStressHDPEPage()));
      break;
    case '/flotabilidad':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FlotabilidadPage()));
      break;
    case '/make_up':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MakeupPage()));
      break;
    case '/rop':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ROPCalculatorPage()));
      break;
    case '/manejo_tuberia':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ManejodeTuberiasPage()));
      break;
    case '/medidas_roscas':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MedidasRoscasPage()));
      break;
    case '/manuales':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualesPage()));
      break;
    case '/radio_curva':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RadioCurvaturaPage()));
      break;
    case '/curvatura_smys':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RadioSMYSPage()));
      break;
    case '/curva_page':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CurvaCompletaPage()));
      break;
    case '/prof_tubo':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfundidadDistanciaPage()));
      break;
    case '/graficar_barra':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const GraficarBarraPage()));
      break;
    case '/dar_blanco':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const DarEnElBlancoPage()));
      break;
    case '/tabla_porc_grados':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TablaGradosPorcentajePage()));
      break;
    case '/tabla_salida':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TablaSalidasPage()));
      break;
    case '/tabla_curva_salida':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TablaCurvasTuberiasPage()));
      break;
    case '/volumen_tanque':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VolumenTanquePage()));
      break;
    case '/espacio_anular':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const EspacioAnularPage()));
      break;
    case '/aditivos_perforacion':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AditivosPerforacionPage()));
      break;
    case '/fluido_necesario':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FluidoNecesarioPage()));
      break;
    case '/asesores':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AsesoresPage()));
      break;
    case '/about':
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PesodeTuboPage()));
      break;
      
    
    default:
      debugPrint('Ruta no definida: $routeName');
  }
}
