import 'package:flutter/material.dart';
import 'package:flutter_solar_system/widget/imagen_input.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter_solar_system/moduels/classes.dart';

class MyInputScreen extends StatefulWidget {
  static const routeName = 'MyInputScreen';
  final Function()? onSaved;

  const MyInputScreen({Key? key, this.onSaved}) : super(key: key);

  @override
  _MyInputScreenState createState() => _MyInputScreenState();
}

class _MyInputScreenState extends State<MyInputScreen> {
  final _titleController = TextEditingController();
  final _storyController = TextEditingController();
  final _especieController = TextEditingController();
  late File savedImage;

  void savedImages(File image) {
    setState(() {
      savedImage = image;
    });
  }

  void onSave() {
    if (_titleController.text.isEmpty ||
        _storyController.text.isEmpty ||
        savedImage == null) {
      return;
    } else {
      Provider.of<ImageFile>(context, listen: false).addImagePlace(
          _titleController.text, _storyController.text, savedImage);
      widget.onSaved?.call(); // Call the callback function to refresh the page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Page'),
        actions: [
          IconButton(
            onPressed: onSave,
            icon: Icon(Icons.save),
          ),
        ],
        backgroundColor: Colors.blue.withOpacity(0.5), // Ajusta la transparencia aquí
        elevation: 0, // Quita la sombra de la AppBar si lo deseas
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://marketplace.canva.com/EAFC85ytNMY/1/0/900w/canva-fondo-para-whatsapp-del-espacio-El7sSnLbULs.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: _storyController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: _especieController,
                  decoration: InputDecoration(
                    labelText: 'Especie',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ImagenInput(savedImages),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
