import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:unsplashgallery/models.dart';
import 'package:unsplashgallery/widget/info_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unsplashgallery/unsplash_image_provider.dart';

class ImagePage extends StatefulWidget {
  final String imageId, imageUrl;

  ImagePage(this.imageId, this.imageUrl, {Key key}) : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PersistentBottomSheetController bottomSheetController;

  UnsplashImage image;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  _loadImage() async {
    UnsplashImage image = await UnsplashImageProvider.loadImage(widget.imageId);
    setState(() {
      this.image = image;
      if (bottomSheetController != null) {
        _showInfoBottomSheet();
      }
    });
  }

  Widget _buildAppBar() => AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading:
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                ),
                onPressed: () => Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.red,

              ),
              tooltip: 'Image Info',
              onPressed: () => bottomSheetController = _showInfoBottomSheet()),
          IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.red,
              ),
              tooltip: 'Open in Browser',
              onPressed: () => launch(image?.getHtmlLink())),
        ],
      );

  Widget _buildPhotoView(String imageId, String imageUrl) => PhotoView(
        imageProvider: NetworkImage(imageUrl),
        initialScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.covered,
        maxScale: PhotoViewComputedScale.covered,
        // ignore: deprecated_member_use
        loadingChild: const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
        )),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildPhotoView(widget.imageId, widget.imageUrl),
          Positioned(top: 0.0, left: 0.0, right: 0.0, child: _buildAppBar()),
        ],
      ),
    );
  }

  PersistentBottomSheetController _showInfoBottomSheet() {
    return _scaffoldKey.currentState.showBottomSheet(
      (context) => InfoSheet(image),
    );
  }
}
