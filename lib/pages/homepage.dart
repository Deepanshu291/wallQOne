import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:walliqone/pages/Wallpaper.dart';
import 'package:walliqone/services/Pixel_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  int page = 1;
  bool isloading = true;
  final scrollcontroller = ScrollController();
  var refreshkey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getresource();
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.maxScrollExtent ==
          scrollcontroller.offset) {
        loadmore();
      }
    });
  }

  @override
  void dispose() {
    scrollcontroller.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    setState(() {
      isloading = true;
      // images.clear();
    });
    getresource();
  }

  getresource() {
    getHttps().then((value) {
      setState(() {
        images = value;
        isloading = false;
      });
    });
  }

  Future<void> loadmore() async {
    setState(() {
      page = page + 1;
    });
    await getpageHttps(1).then((value) {
      setState(() {
        images.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refresh(),
      key: refreshkey,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title, style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w600),),
          ),
          body: isloading
              ? LinearProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: scrollcontroller,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            childAspectRatio: 2 / 3,
                            mainAxisSpacing: 3,
                          ),
                          itemCount: images.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < images.length) {
                              final imgurl = images[index]['src']['large2x'];
                              return InkWell(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WallpaperView(
                                  imgList: images[index],
                                ),)),
                                child: ImageCard(imageurl: imgurl));
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      // ElevatedButton(onPressed: () => loadmore(), child: Text("Loadmore"))
                    ],
                  ),
                )),
    );
  }

//   Container ImageCard(int index) {
//     return ImageCard(images: images);
//   }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.imageurl,
  });

  final String imageurl;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color:
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade300,
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: imageurl,
          fit: BoxFit.fill,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
