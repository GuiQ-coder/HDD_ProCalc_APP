import 'package:flutter/material.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({super.key});

  @override
  DisclaimerPageState createState() => DisclaimerPageState();
}

class DisclaimerPageState extends State<DisclaimerPage> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Descargo de responsabilidades', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 20),
            
            Text(
              'La información, recomendaciones, enlaces, así como '
              'todos los cálculos relacionados mostrados en esta aplicación está ' 
              'basada en experiencia colectiva y conocimiento investigado de '
              'publicaciones de este ramo y solamente expuesta y ejecutada en '
              'forma de aplicación para su difusión, pero los usuarios '
              'deben determinar como usar la información de esta y comprobar '
              'de manera personal sus propios cálculos, esta app no se hace '
              'responsable por daños o errores que puedan resultar del uso de '
              'la misma ni damos garantía como tal. Para utilizarla es necesario '
              'aceptar este descargo de responsabilidad y aceptar que es responsable del uso '
              'que le de a la misma.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.justify,  
            ),
            
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAccepted = value ?? false;
                    });
                  },
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
                Text('Acepto los términos.', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isAccepted
                  ? () => Navigator.pushNamed(context, '/menu')
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Continuar', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}