import 'package:flutter/material.dart';
import 'screen/my_home_page.dart'; // Importa la pantalla de inicio
import 'widget/my_input_screen.dart'; // Importa la pantalla de entrada
import 'package:provider/provider.dart'; // Importa el paquete Provider
import 'moduels/classes.dart'; // Importa las clases necesarias
import 'screen/details_screen.dart'; // Importa la pantalla de detalles

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ImageFile(),
      child: MaterialApp(
        title: 'Flutter Gallery',
        theme: ThemeData.dark(),
        home: MyHomePage(),
        routes: {
          MyHomePage.routeName: (context) => MyHomePage(),
          MyInputScreen.routeName: (ctx) => MyInputScreen(),
          DetailsScreen.routeName: (ctx) => DetailsScreen(
              imageId:
                  ''), // ¡Asegúrate de proporcionar el imageId necesario aquí!
        },
      ),
    );
  }
}
