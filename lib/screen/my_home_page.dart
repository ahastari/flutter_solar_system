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

  final List<String> imageTitles = [
    'Título de la imagen 1',
    'Título de la imagen 2',
    'Título de la imagen 3',
    // Agrega más títulos según la cantidad de imágenes
  ];

  final List<String> imageSubtitles = [
    'Subtítulo de la imagen 1',
    'Subtítulo de la imagen 2',
    'Subtítulo de la imagen 3',
    // Agrega más subtítulos según la cantidad de imágenes
  ];

  @override
  void initState() {
    super.initState();
    _imageURLsFuture = fetchImageURLs();
    _localImagesFuture = fetchLocalImages();
  }

  Future<List<String>> fetchImageURLs() async {
    // Simulación de obtención de URLs de imágenes
    return [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSt9-rpjoCT3XTEKKmVMcBinhcPFadcRGHtMtwlIGTBfcu1Y7vBg8hSKOToz7axxha3_9Q&usqp=CAU',
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.pinimg.com/736x/97/04/a3/9704a3edf038940e01dae3d438eb71f0.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder(
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

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      showLocalImages = !showLocalImages;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 400,
                        height: 700,
                        child: PageView.builder(
                          itemCount: imageURLs.length,
                          controller: PageController(
                            initialPage: selectedImageIndex,
                            viewportFraction: 1.2,
                          ),
                          onPageChanged: (index) {
                            setState(() {
                              selectedImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 60),
                              child: Center(
                                
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      imageTitles[index],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      imageSubtitles[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Image.network(
                                      imageURLs[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (showLocalImages)
                        Expanded(
                          child: _buildLocalImageList(localImages),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
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
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: localImages.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final imageId = localImages[i].id;
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
                    localImages[i].image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              localImages[i].title ?? 'No title',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
