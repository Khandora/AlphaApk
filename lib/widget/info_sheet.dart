import 'package:flutter/material.dart';
import 'package:unsplashgallery/models.dart';
import 'package:unsplashgallery/widget/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoSheet extends StatelessWidget {
  final UnsplashImage image;

  InfoSheet(this.image);

  @override
  Widget build(BuildContext context) =>
      Card(
        margin: const EdgeInsets.only(top: 16.0),
        elevation: 10.0,
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: image != null
                ? <Widget>[
              InkWell(
                onTap: () => launch(image?.getUser()?.getHtmlLink()),
                child: Row(
                  children: <Widget>[
                    _buildUserProfileImage(
                        image?.getUser()?.getMediumProfileImage()),
                    Text(
                      '${image.getUser().getFirstName()} ${image?.getUser()
                          ?.getLastName()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        '${image.createdAtFormatted()}'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              _buildDescriptionWidget(image.getDescription()),
              _buildLocationWidget(image.getLocation()),
            ].where((w) => w != null).toList()
                : <Widget>[LoadingIndicator(Colors.red)]),
      );

  Widget _buildUserProfileImage(String url) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
      );

  Widget _buildDescriptionWidget(String description) =>
      description != null
          ? Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: Text(
          '$description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            letterSpacing: 0.1,
          ),
        ),
      )
          : null;

  Widget _buildLocationWidget(Location location) =>
      location != null
          ? Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                )),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '${location.getCity()}, ${location.getCountry()}'
                      .toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      )
          : null;
}
