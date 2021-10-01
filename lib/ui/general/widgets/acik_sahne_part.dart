import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AcikSahnePart extends StatelessWidget {
  var imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/app%2Facik_sahne_cover-min.jpeg?alt=media&token=64b3f1ee-7015-4230-8c4e-525c0b0b0e40";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
              child: Center(
                child: Text("Yakında",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        );
      },
    );
  }
}
