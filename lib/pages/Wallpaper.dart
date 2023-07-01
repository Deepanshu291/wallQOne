import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class WallpaperView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final imgList;
  const WallpaperView({super.key, required this.imgList});

  @override
  State<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  // ignore: non_constant_identifier_names
  Future<void> Setwallpaper() async {
    String result;
    String url = widget.imgList['src']['large2x'];
    var file = await DefaultCacheManager().getSingleFile(url);
    print(file.path);
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error() 
        )? 'Wallpaper set': 'Failed to get Wallpaper';
    } on PlatformException{
      result = 'Failed to get Wallpaper';
    }
    // int location = WallpaperManagerFlutter.HOME_SCREEN;
    // await WallpaperManagerFlutter().setwallpaperfromFile(file, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.imgList['alt']),
      ),
      body: Hero(
        tag: widget.imgList['src']['large2x'],
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: CachedNetworkImage(
                imageUrl: widget.imgList['src']['large2x'],
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => Setwallpaper(),
                child: Container(
                  height: 60,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Set Wallpaper",
                      style: TextStyle(
                          fontSize: 30, color: Colors.white, letterSpacing: 5),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
