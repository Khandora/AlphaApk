import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unsplashgallery/image_page.dart';
import 'package:unsplashgallery/models.dart';

class ImageTile extends StatelessWidget {
  final UnsplashImage image;

  const ImageTile(this.image);

  Widget _addRoundedCorners(Widget widget) =>
      ClipRRect(borderRadius: BorderRadius.circular(4.0), child: widget);

  Widget _buildImagePlaceholder({UnsplashImage image}) => Container(
        color: image != null
            ? Color(int.parse(image.getColor().substring(1, 7), radix: 16) +
                0x64000000)
            : Colors.grey[200],
      );

  Widget _buildImageErrorWidget() => Container(
        color: Colors.grey[200],
        child: Center(
            child: Icon(
          Icons.broken_image,
          color: Colors.grey[400],
        )),
      );

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  ImagePage(image.getId(), image.getFullUrl()),
            ),
          );
        },
        child: image != null
            ? Hero(
                tag: '${image.getId()}',
                child: _addRoundedCorners(CachedNetworkImage(
                  imageUrl: image?.getSmallUrl(),
                  placeholder: (context, url) =>
                      _buildImagePlaceholder(image: image),
                  errorWidget: (context, url, obj) => _buildImageErrorWidget(),
                  fit: BoxFit.cover,
                )))
            : _buildImagePlaceholder(),
      );
}
