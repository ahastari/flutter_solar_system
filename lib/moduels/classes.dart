import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'database.dart'; // Importa alguna lógica de base de datos

// Clase que representa los datos de una imagen
class ImageData {
  final String id;
  final String title;
  final String story;
  final File image;

  ImageData({
    required this.image,
    required this.title,
    required this.id,
    required this.story, required String especie,
  });

  get imageUrl => null;

  get images => null;

  void add(ImageData imageData) {}
}

// Clase que gestiona una lista de ImageData
class ImageFile with ChangeNotifier {
  List<ImageData> _items = []; // Lista interna de datos de imágenes
  List<ImageData> get items {
    return [..._items]; // Devuelve una copia de la lista de imágenes para evitar modificaciones externas
  }

  Future<List<ImageData>>? get horizontalImages => null;

  List<ImageData>? get circularImages => null;


  // Método para añadir una nueva imagen con título, historia y archivo de imagen
  Future<void> addImagePlace(String title, String story, File image) async {
    final newImage = ImageData(
      image: image,
      title: title,
      id: DateTime.now().toString(), // Genera un ID único basado en la fecha y hora actual
      story: story, especie: '',
    );
    _items.add(newImage); // Agrega la nueva imagen a la lista interna
    notifyListeners(); // Notifica a los oyentes (como los widgets) sobre el cambio en los datos

    // Guarda la imagen en la base de datos utilizando algún método de inserción
    DataHelper.insert('user_image', {
      'id': newImage.id,
      'story': newImage.story,
      'image': newImage.image.path,
      'title': newImage.title,
    });
  }

  // Método para encontrar una imagen específica por su ID
  ImageData findImage(String imageId) {
    return _items.firstWhere((image) => image.id == imageId);
  }

  // Método para obtener las imágenes desde la base de datos
  Future<void> fetchImage() async {
    final lis = await DataHelper.getData('user_image'); // Obtiene datos de la base de datos
    _items = lis
        .map((item) => ImageData(
              image: File(item['image']),
              title: item['title'],
              id: item['id'],
              story: item['story'], especie: '',
            ))
        .toList(); // Mapea los datos obtenidos a objetos ImageData
    notifyListeners(); // Notifica a los oyentes sobre el cambio en los datos
  }

  removeImage(String id) {}

  fetchHorizontalImages() {}

  fetchCircularImages() {}

  void addImagePlaceWithUrls(String text, String text2, String text3, List<String> imageUrls) {}

  void deleteImage(String imageId) {}
}