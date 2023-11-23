import 'package:flutter/material.dart';
import 'package:flutter_solar_system/widget/my_input_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_solar_system/moduels/classes.dart' as ima;
import 'details_screen.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = 'MyHomePage';

  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<ima.ImageData>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = fetchImages();
  }

  Future<List<ima.ImageData>> fetchImages() async {
    final imageProvider = Provider.of<ima.ImageFile>(context, listen: false);
    await imageProvider.fetchImage();
    return imageProvider.items;
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
                  'https://marketplace.canva.com/EAFC85ytNMY/1/0/900w/canva-fondo-para-whatsapp-del-espacio-El7sSnLbULs.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder(
            future: _imagesFuture,
            builder: (ctx, AsyncSnapshot<List<ima.ImageData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text('Error loading data'),
                  );
                }
                final List<ima.ImageData> imageData = snapshot.data!;
                final List<ima.ImageData> circleImageData = List.from(imageData); // Create a separate list for circles
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: imageData.isEmpty // Show only square images
                          ? Center(child: Text('No square images'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageData.length,
                              itemBuilder: (ctx, i) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    final imageId = imageData[i].id;
                                    if (imageId != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsScreen(imageId: imageId),
                                        ),
                                      );
                                    } else {
                                      // Handle scenario where imageId is null
                                    }
                                  },
                                  child: SizedBox(
                                    width: 350,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.file(
                                          imageData[i].image,
                                          fit: BoxFit.cover,
                                          height: 400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 16), // Space between lists
                    Container(
                      height: 200, // Set height for circle images
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: circleImageData.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final imageId = circleImageData[i].id;
                                  if (imageId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsScreen(imageId: imageId),
                                      ),
                                    );
                                  } else {
                                    // Handle scenario where imageId is null
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
                                      circleImageData[i].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                circleImageData[i].title ?? 'No title',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                onSaved: () {
                  setState(() {
                    _imagesFuture = fetchImages(); // Refresh images after saving
                  });
                },
              );
            },
          );
        },
        tooltip: 'Add Story',
        child: Icon(Icons.add),
      ),
    );
  }
}
