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
    'Planets',
    'Starts',
    'Meteorites',
    // Agrega más títulos según la cantidad de imágenes
  ];

  final List<String> imageSubtitles = [
    'Solar System',
    'Solar System',
    'Solar System',
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
      'https://upload.wikimedia.org/wikipedia/commons/c/cf/Planet_collage_to_scale.jpg',
      'https://www.zschimmer-schwarz.es/app/uploads/2020/09/galaxia-sistema-solar-via-lactea-universo-de-que-estan-hechas-las-estrellas-composicion-quimica-de-las-estrellas.jpg',
      'https://www.ngenespanol.com/wp-content/uploads/2018/08/cual-es-la-diferencia-entre-un-meteoro-un-meteorito-y-un-meteoroide.jpg',
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
                        width: 450,
                        height: 750,
                        child: PageView.builder(
                          itemCount: imageURLs.length,
                          controller: PageController(
                            initialPage: selectedImageIndex,
                            viewportFraction: 0.8,
                          ),
                          onPageChanged: (index) {
                            setState(() {
                              selectedImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Center(
                                child: Card(
                                  elevation: 5,
                                  child: SizedBox(
                                    width: 400,
                                    height: 400,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          width: 300,
                                          height: 300,
                                        ),
                                      ],
                                    ),
                                  ),
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
