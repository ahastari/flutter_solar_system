import 'package:flutter/material.dart';
import 'package:flutter_solar_system/moduels/classes.dart' as ima;
import 'package:flutter_solar_system/moduels/classes.dart';
import 'package:flutter_solar_system/screen/my_home_page.dart';
import 'package:flutter_solar_system/widget/my_input_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_solar_system/moduels/database.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = 'DetailsScreen';
  final String imageId;

  const DetailsScreen({Key? key, required this.imageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ima.ImageFile>(context, listen: false);
    final imageData = imageProvider.findImage(imageId);

    void deleteImage() async {
      try {
        await DataHelper.delete('user_image', imageId);
        imageProvider.deleteImage(imageId);
        Navigator.pop(context); // Vuelve a la pantalla anterior después de eliminar
      } catch (error) {
        // Manejo de errores si la eliminación falla
        print('Error deleting image: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(imageData.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://i.pinimg.com/736x/97/04/a3/9704a3edf038940e01dae3d438eb71f0.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
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
            icon: Icon(Icons.delete), // Botón de eliminación
            label: 'Delete',
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
            case 2:
              deleteImage(); // Elimina la imagen cuando se selecciona el botón
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
