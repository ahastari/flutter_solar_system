import 'package:flutter/material.dart';
import 'package:flutter_solar_system/moduels/classes.dart' as ima;
import 'package:flutter_solar_system/moduels/classes.dart';
import 'package:flutter_solar_system/screen/my_home_page.dart';
import 'package:flutter_solar_system/widget/my_input_screen.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = 'DetailsScreen';
  final String imageId;

  const DetailsScreen({Key? key, required this.imageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageData =
        Provider.of<ima.ImageFile>(context, listen: false).findImage(imageId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          imageData.title,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: 250,
              width: double.infinity,
              child: Image.file(
                imageData.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            imageData.title,
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            imageData.story,
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
        ],
        currentIndex: 2,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, MyHomePage.routeName);
              break;
            case 1:
              showModalBottomSheet(
                context: context,
                builder: (_) => MyInputScreen(),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
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
          DetailsScreen.routeName: (ctx) => DetailsScreen(imageId: ''), // Puedes proporcionar el imageId necesario aquí
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
