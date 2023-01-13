import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageCard extends StatelessWidget {
  final String title;
  final String? subTitle;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget? button;
  final String imageUrl;
  const ImageCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.subTitle,
    this.padding = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
    this.margin = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 108,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage(
                      image: NetworkImage(imageUrl),
                      placeholder: MemoryImage(kTransparentImage),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 124,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topLeft,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subTitle ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      button ?? const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
