import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplashgallery/models.dart';
import 'package:unsplashgallery/unsplash_image_provider.dart';
import 'package:unsplashgallery/widget/image_tile.dart';
import 'package:unsplashgallery/widget/loading_indicator.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int page = 0,
      totalPages = -1;

  List<UnsplashImage> images = [];

  bool loadingImages = false;

  String keyword;

  @override
  initState() {
    super.initState();
    _loadImages();
  }

  _resetImages() {
    images = [];
    page = 0;
    totalPages = -1;
    keyword = null;
    _loadImages();
  }

  _loadImages({String keyword}) async {
    if (loadingImages) {
      return;
    }
    if (totalPages != -1 && page >= totalPages) {
      return;
    }
    await Future.delayed(Duration(microseconds: 1));
    setState(() {
      loadingImages = true;
      if (this.keyword != keyword) {
        this.images = [];
        this.page = 0;
      }
      this.keyword = keyword;
    });

    List<UnsplashImage> images;
    if (keyword == null) {
      images = await UnsplashImageProvider.loadImages(page: ++page);
    } else {
      List res = await UnsplashImageProvider.loadImagesWithKeyword(keyword,
          page: ++page);
      totalPages = res[0];
      images = res[1];
    }

    setState(() {
      loadingImages = false;
      this.images.addAll(images);
    });
  }

  Future<UnsplashImage> _loadImage(int index) async {
    if (index >= images.length - 2) {
      _loadImages(keyword: keyword);
    }

    return index < images.length ? images[index] : null;
  }

  @override
  Widget build(BuildContext context) =>
      WillPopScope(
        onWillPop: () async {
          if (keyword != null) {
            _resetImages();
            return false;
          }
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.black12,
            body: OrientationBuilder(
                builder: (context, orientation) =>
                    CustomScrollView(
                        slivers: <Widget>[
                          _buildSearchAppBar(),
                          _buildImageGrid(orientation: orientation),
                          loadingImages
                              ? SliverToBoxAdapter(
                            child: LoadingIndicator(Colors.redAccent),
                          )
                              : null,
                        ].where((w) => w != null).toList()))),
      );

  Widget _buildSearchAppBar() =>
      SliverAppBar(
        title: keyword != null
            ?
        TextField(
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Search...', border: InputBorder.none, fillColor: Colors.white),
          onSubmitted: (String keyword) =>
          _loadImages(keyword: keyword),
          autofocus: true,
        )
            : const Text('Unsplash Dream Gallery',
            style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          keyword != null
              ? IconButton(
            icon: Icon(Icons.clear),
            color: Colors.red,
            onPressed: () {
              _resetImages();
            },
          )
              : IconButton(
            icon: Icon(Icons.search),
            color: Colors.red,
            onPressed: () =>
            setState(() => keyword = ""),
          )
        ],
        backgroundColor: Colors.black87,
      );

  StaggeredTile _buildStaggeredTile(UnsplashImage image, int columnCount) {
    double aspectRatio =
        image.getHeight().toDouble() / image.getWidth().toDouble();
    double columnWidth = MediaQuery
        .of(context)
        .size
        .width / columnCount;
    return StaggeredTile.extent(1, aspectRatio * columnWidth);
  }

  Widget _buildImageGrid({orientation = Orientation.portrait}) {
    int columnCount = orientation == Orientation.portrait ? 2 : 3;
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverStaggeredGrid.countBuilder(
        crossAxisCount: columnCount,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildImageItemBuilder(index),
        staggeredTileBuilder: (int index) =>
            _buildStaggeredTile(images[index], columnCount),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
    );
  }

  Widget _buildImageItemBuilder(int index) =>
      FutureBuilder(
        future: _loadImage(index),
        builder: (context, snapshot) =>
        ImageTile(snapshot.data),
      );
}
