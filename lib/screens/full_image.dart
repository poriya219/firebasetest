import 'package:flutter/material.dart';

class Fullsize_Image extends StatelessWidget {

  String url;

  Fullsize_Image(this.url);
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      width: size.width,
      height: size.height,
      child: (url != '-1')
          ? FadeInImage(
        imageErrorBuilder: (context, error, stackTrace) {
          return const Image(
            image: AssetImage('assets/default2.png'),
            width: 55,
          );
        },
        width: 55,
        // fit: BoxFit.cover,
        image: NetworkImage(url),
        placeholder: const AssetImage('assets/default2.png'),
      )
          : const Image(
        image: AssetImage('assets/default2.png'),
        width: 55,
      ),
    );
  }
}
