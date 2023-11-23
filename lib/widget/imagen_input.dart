import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImagenInput extends StatefulWidget {
  final Function imagesaveat;
  ImagenInput(this.imagesaveat);
  @override
  _ImagenInputState createState() => _ImagenInputState();
}

class _ImagenInputState extends State<ImagenInput> {
  File? _imageFile; // Almacena la imagen seleccionada o capturada desde la galería o la cámara

  // Función para obtener una imagen desde la galería
  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path); // Actualiza la imagen seleccionada en la interfaz
      });
    }

    // Obtiene la ruta del directorio de documentos de la aplicación y guarda la imagen seleccionada en esa ubicación
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile!.path);
    final saveImagePath = await _imageFile!.copy('${appDir.path}/$fileName');

    // Llama a una función proporcionada desde fuera para guardar la ruta de la imagen seleccionada
    widget.imagesaveat(saveImagePath);
  }

  // Función para capturar una imagen usando la cámara
  Future<void> _getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path); // Actualiza la imagen capturada en la interfaz
      });
    }

    // Obtiene la ruta del directorio de documentos de la aplicación y guarda la imagen capturada en esa ubicación
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imageFile!.path);
    final saveImagePath = await _imageFile!.copy('${appDir.path}/$fileName');

    // Llama a una función proporcionada desde fuera para guardar la ruta de la imagen capturada
    widget.imagesaveat(saveImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.deepOrange),
          ),
          child: _imageFile != null
              ? Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                )
              : Center(
                  child: Text('No Image Yet, add one'),
                ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botón para seleccionar una imagen desde la galería
            TextButton.icon(
              onPressed: _getImageFromGallery,
              icon: Icon(Icons.image),
              label: Text('Add your image'),
            ),
            // Botón para capturar una imagen usando la cámara
            TextButton.icon(
              onPressed: _getImageFromCamera,
              icon: Icon(Icons.camera),
              label: Text('Take picture'),
            ),
          ],
        ),
      ],
    );
  }
}
