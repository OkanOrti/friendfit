import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ContentScroll extends StatelessWidget {
  final List<dynamic>? images;
  final String? title;
  final double? imageHeight;
  final double? imageWidth;

  ContentScroll({
    this.images,
    this.title,
    this.imageHeight,
    this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /*Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => print('View $title'),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),*/
        Container(
          //color: Colors.grey,
          height: imageHeight,
          child: ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: images!.length > 1 ? 0 : 30),
            scrollDirection: Axis.horizontal,
            itemCount: images!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: images!.length > 1 ? 10 : 0,
                  vertical: 20.0,
                ),
                width: imageWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                    image: CachedNetworkImageProvider(
                        images![index]), //AssetImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
