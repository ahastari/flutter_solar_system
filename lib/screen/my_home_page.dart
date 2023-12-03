import 'package:flutter/material.dart';
import 'package:flutter_solar_system/widget/my_input_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_solar_system/moduels/classes.dart' as ima;
import 'details_screen.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = 'MyHomePage';

  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<String>> _imageURLsFuture;
  late Future<List<ima.ImageData>> _localImagesFuture;
  int selectedImageIndex = 0;
  bool showLocalImages = false;

  @override
  void initState() {
    super.initState();
    _imageURLsFuture = fetchImageURLs();
    _localImagesFuture = fetchLocalImages();
  }

  Future<List<String>> fetchImageURLs() async {
    // Aquí se simula la obtención de URLs de imágenes
    return [
      'https://static.nationalgeographicla.com/files/styles/image_3200/public/1160.jpg?w=1900&h=1426',
      'https://c8.alamy.com/compes/2c5n1ct/conjunto-de-planetas-brillantes-y-coloridos-sistema-solar-espacio-con-estrellas-ilustracion-de-vector-de-dibujos-animados-2c5n1ct.jpg',
      'https://img.freepik.com/vector-premium/ilustracion-sistema-solar-estrellas-asteroides_122784-2366.jpg',
      // Agrega más URLs de imágenes según sea necesario
    ];
  }

  Future<List<ima.ImageData>> fetchLocalImages() async {
    final imageProvider = Provider.of<ima.ImageFile>(context, listen: false);
    await imageProvider.fetchImage();
    return imageProvider.items;
  }

  Future<void> _refreshImages() async {
    setState(() {
      _imageURLsFuture = fetchImageURLs();
      _localImagesFuture = fetchLocalImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([_imageURLsFuture, _localImagesFuture]),
        builder: (ctx, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text('Error loading data'),
              );
            }
            final List<String> imageURLs = snapshot.data![0];
            final List<ima.ImageData> localImages = snapshot.data![1];
            final selectedImageURL = imageURLs[selectedImageIndex];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showLocalImages = !showLocalImages;
                      });
                    },
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageURLs.length,
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          imageURLs[i],
                          fit: BoxFit.cover,
                          width: 300,
                        ),
                      ),
                    ),
                  ),
                ),
                if (showLocalImages)
                  Expanded(
                    flex: 2,
                    child: _buildLocalImageList(localImages),
                  ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return MyInputScreen(
                onSaved: _refreshImages,
              );
            },
          );
        },
        tooltip: 'Add Story',
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 10, 10, 10).withOpacity(0.6),
        foregroundColor: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _buildLocalImageList(List<ima.ImageData> localImages) {
    final List<ima.ImageData> circleLocalImages = List.from(localImages);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: circleLocalImages.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final imageId = circleLocalImages[i].id;
                if (imageId != null) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(imageId: imageId),
                    ),
                  );
                  _refreshImages();
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: ClipOval(
                  child: Image.file(
                    circleLocalImages[i].image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              circleLocalImages[i].title ?? 'No title',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
